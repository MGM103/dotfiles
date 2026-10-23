#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

say() { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

SUDO=()
if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  command -v sudo >/dev/null 2>&1 || die "sudo is required"
  SUDO=(sudo)
fi

install_arch() {
  say "Installing packages with pacman"
  "${SUDO[@]}" pacman -S --needed --noconfirm \
    neovim eza zoxide fzf starship stow git curl
}

install_debian() {
  say "Installing packages with apt"
  "${SUDO[@]}" apt-get update
  "${SUDO[@]}" apt-get install -y \
    neovim zoxide fzf stow git curl

  if ! "${SUDO[@]}" apt-get install -y eza; then
    warn "eza is not available in this apt release; install it from https://github.com/eza-community/eza"
  fi

  if ! command -v starship >/dev/null 2>&1; then
    say "Installing starship"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
  fi
}

all_packages() {
  local dir
  for dir in "$DOTFILES_DIR"/*/; do
    [[ -d $dir ]] || continue
    basename "${dir%/}"
  done
}

usage() {
  cat <<'EOF'
Usage: ./install.sh [package|all]...

Installs the required tools, then stows dotfiles packages into $HOME.

  (no arguments)  Stow every package
  all             Stow every package
  <package>...    Stow only the named packages (e.g. bash nvim tmux)
  -h, --help      Show this help
EOF
}

install_tools() {
  if command -v pacman >/dev/null 2>&1; then
    install_arch
  elif command -v apt-get >/dev/null 2>&1; then
    install_debian
  else
    die "Unsupported package manager (expected pacman or apt-get)"
  fi

  for tool in nvim eza zoxide fzf starship stow; do
    command -v "$tool" >/dev/null 2>&1 || warn "$tool is not installed"
  done
}

sync_inputrc() {
  local source=/usr/share/omarchy/default/bash/inputrc
  local target="$DOTFILES_DIR/bash/.config/bash/inputrc"

  [[ -r $source ]] || return 0
  cmp -s "$source" "$target" && return 0

  say "Syncing inputrc from Omarchy"
  cp "$source" "$target"
  warn "dotfiles inputrc updated; commit the change"
}

link_packages() {
  local -a packages=()
  local -A seen=()
  local package

  for package in "$@"; do
    [[ -n ${seen[$package]:-} ]] && continue
    seen[$package]=1
    packages+=("$package")
  done

  [[ ${#packages[@]} -gt 0 ]] || die "no packages to stow"

  say "Stowing: ${packages[*]}"
  for package in "${packages[@]}"; do
    [[ -d "$DOTFILES_DIR/$package" ]] || die "no such stow package: $package"

    if [[ $package == bash && -e "$HOME/.config/bash" && ! -L "$HOME/.config/bash" ]]; then
      die "$HOME/.config/bash already exists and is not a symlink; move it aside and re-run"
    fi

    ( cd "$DOTFILES_DIR" && stow --target="$HOME" "$package" )
  done
}

ensure_bashrc_source() {
  local bashrc="$HOME/.bashrc"
  touch "$bashrc"

  if grep -qF '.config/bash/rc' "$bashrc"; then
    say "$bashrc already sources the personal bash layer"
    return
  fi

  say "Adding personal bash layer to $bashrc"
  cat >>"$bashrc" <<'EOF'

# >>> personal bash layer >>>
[ -f "$HOME/.config/bash/rc" ] && . "$HOME/.config/bash/rc"
# <<< personal bash layer <<<
EOF
}

main() {
  local packages=()
  local arg

  for arg in "$@"; do
    case $arg in
      -h|--help)
        usage
        exit 0
        ;;
      all)
        mapfile -t -O "${#packages[@]}" packages < <(all_packages)
        ;;
      *)
        packages+=("$arg")
        ;;
    esac
  done

  if [[ ${#packages[@]} -eq 0 ]]; then
    mapfile -t packages < <(all_packages)
  fi

  install_tools
  sync_inputrc
  link_packages "${packages[@]}"
  ensure_bashrc_source
  say "Done. Open a new shell or run: exec bash"
}

main "$@"
