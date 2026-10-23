#!/bin/bash

# omarchy:summary=Set the scrolling-layout column width based on the monitor in use
#
# When an ultrawide monitor is present, use a two-column width (0.5); when only
# smaller screens are connected, use a single full-width column (1). Re-evaluated
# when monitors are plugged in or removed.
#
# Tune via environment variables (set them in your shell or looknfeel.lua launch):
#   OMARCHY_ULTRAWIDE_RATIO    aspect ratio (width/height) at/above which a screen
#                              counts as ultrawide. Default: 2.1 (covers 21:9+).
#   OMARCHY_ULTRAWIDE_MONITORS comma-separated output names that always count as
#                              ultrawide, e.g. "DP-1,HDMI-A-1". Overrides the ratio.
#   OMARCHY_COLUMN_WIDE        column_width when an ultrawide is present. Default: 0.5.
#   OMARCHY_COLUMN_NARROW      column_width when only smaller screens are present. Default: 1.

ULTRAWIDE_RATIO="${OMARCHY_ULTRAWIDE_RATIO:-2.1}"
ULTRAWIDE_MONITORS="${OMARCHY_ULTRAWIDE_MONITORS:-}"
COLUMN_WIDE="${OMARCHY_COLUMN_WIDE:-0.5}"
COLUMN_NARROW="${OMARCHY_COLUMN_NARROW:-1}"

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/omarchy-scrolling-column-width.pid"

# A reload re-fires hyprland.start and Hyprland kills the previous exec child,
# so a fresh launch must take over from any lingering instance instead of
# refusing to start. Replace any stale instance, then become the live one.
if [[ -f "$PIDFILE" ]]; then
  old_pid="$(cat "$PIDFILE" 2>/dev/null)"
  if [[ -n "$old_pid" ]] && kill -0 "$old_pid" 2>/dev/null; then
    kill "$old_pid" 2>/dev/null
    # Give the old socat loop a moment to release the socket reader.
    sleep 0.3
  fi
fi
echo "$$" > "$PIDFILE"
SOCK_PID=""
cleanup() {
  [[ -f "$PIDFILE" ]] && [[ "$(cat "$PIDFILE" 2>/dev/null)" == "$$" ]] && rm -f "$PIDFILE"
  [[ -n "$SOCK_PID" ]] && kill "$SOCK_PID" 2>/dev/null
}
trap cleanup EXIT

is_ultrawide() {
  local name="$1" w="$2" h="$3"
  local IFS=','

  if [[ -n $ULTRAWIDE_MONITORS ]]; then
    for m in $ULTRAWIDE_MONITORS; do
      [[ "$name" == "$m" ]] && return 0
    done
  fi

  awk -v w="$w" -v h="$h" -v r="$ULTRAWIDE_RATIO" 'BEGIN { exit !(h > 0 && w / h >= r) }'
}

current_value() {
  hyprctl getoption scrolling:column_width -j 2>/dev/null | jq -r '.float // empty'
}

apply() {
  # Wide layout whenever ANY enabled ultrawide monitor is present (most work
  # happens there); otherwise a single full-width column for the smaller screens.
  local data
  data="$(hyprctl monitors -j 2>/dev/null)" || return 0

  local target="$COLUMN_NARROW"
  local name width height
  while IFS=$'\t' read -r name width height; do
    [[ -z "$name" ]] && continue
    if is_ultrawide "$name" "$width" "$height"; then
      target="$COLUMN_WIDE"
      break
    fi
  done < <(printf '%s' "$data" | jq -r '.[] | select(.disabled == false) | [.name, .width, .height] | @tsv')

  local cur
  cur="$(current_value)"
  if [[ "$cur" != "$target" ]]; then
    hyprctl eval "hl.config({ scrolling = { column_width = $target } })" >/dev/null 2>&1
  fi
}

# Apply now for the current setup.
apply

# And re-apply whenever a monitor is plugged in or removed (focus changes are
# harmless: apply() is idempotent when the ultrawide's presence is unchanged).
if [[ -S $SOCKET ]]; then
  exec 4< <(socat -U - "UNIX-CONNECT:$SOCKET" 2>/dev/null)
  SOCK_PID=$!
  while read -r event <&4; do
    case "$event" in
      focusedmon\>\>*|monitoradded\>\>*|monitoraddedv2\>\>*|monitorremoved\>\>*|monitorremovedv2\>\>*|configreloaded\>\>*)
        # Give the layout a moment to settle after a hotplug before reading state.
        if [[ "$event" == monitor* ]]; then
          sleep 1
        fi
        apply
        ;;
    esac
  done
fi
