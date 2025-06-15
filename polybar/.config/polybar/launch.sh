#!/usr/bin/env bash

# Kill existing polybar instances
polybar-msg cmd quit
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.5; done

# Preferred monitor
if polybar --list-monitors | grep -q "^HDMI-A-0"; then
  MONITOR="HDMI-A-0"
else
  # Fallback: primary monitor
  MONITOR=$(polybar --list-monitors | grep primary | cut -d: -f1)

  # Fallback to first monitor if no primary
  [ -z "$MONITOR" ] && MONITOR=$(polybar --list-monitors | head -n1 | cut -d: -f1)
fi

# Launch polybar
env MONITOR=$MONITOR polybar --reload example &
