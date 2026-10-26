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

is_wsl() {
  [[ -n ${WSL_DISTRO_NAME:-} ]] && return 0
  [[ -r /proc/version ]] && grep -qi microsoft /proc/version
}

package_supported() {
  case $1 in
    ghostty) ! is_wsl ;;
    *) return 0 ;;
  esac
}

# Files these packages link into $HOME. If one already exists as a regular
# file it is replaced by the symlink (identical content) or moved aside first.
displaced_targets() {
  case $1 in
    codebook) printf '%s\n' ".config/codebook/codebook.toml" ;;
    ghostty) printf '%s\n' ".config/ghostty/config" ;;
  esac
}

displace_targets() {
  local package=$1 rel target backup

  while IFS= read -r rel; do
    [[ -n $rel ]] || continue
    target="$HOME/$rel"
    [[ -e $target && ! -L $target ]] || continue

    if cmp -s "$DOTFILES_DIR/$package/$rel" "$target"; then
      say "Replacing $target with a stow symlink (content identical)"
      rm -f "$target"
      continue
    fi

    backup="$target.bak.$(date +%s)"
    say "Moving $target aside (not a stow symlink): $backup"
    warn "review $backup and copy any wanted changes into $DOTFILES_DIR/$package"
    mv "$target" "$backup"
  done < <(displaced_targets "$package")
}

install_arch() {
  say "Installing packages with pacman"
  "${SUDO[@]}" pacman -S --needed --noconfirm \
    neovim tree-sitter-cli tmux gcc eza zoxide fzf starship stow git curl tar
}

# Minimums required by the configs: nvim-treesitter's main branch needs
# nvim 0.12 and tree-sitter 0.26.1; .tmux.conf uses extended-keys-format (3.5).
NVIM_MIN_VERSION=0.12.0
TREE_SITTER_MIN_VERSION=0.26.1
TMUX_MIN_VERSION=3.5

# Set by --tools-only: replace release-installed tools whenever a newer stable
# release exists, not only when they are missing or below the minimum.
UPGRADE_TO_LATEST=false

# Version of an installed command, e.g. 0.12.6 or 3.5a. Pre-release suffixes
# such as -dev are dropped.
installed_version() {
  local cmd=$1 flag=--version
  command -v "$cmd" >/dev/null 2>&1 || return 1
  [[ $cmd == tmux ]] && flag=-V
  "$cmd" "$flag" 2>/dev/null | head -n1 | grep -oE '[0-9]+(\.[0-9]+)+[a-z]?' | head -n1
}

# Succeeds when $1 is installed at version $2 or newer.
has_version() {
  local current
  current=$(installed_version "$1") || return 1
  [[ -n $current ]] || return 1
  [[ $(printf '%s\n%s\n' "$2" "$current" | sort -V | head -n1) == "$2" ]]
}

# Tag of a GitHub repo's latest stable release (e.g. v0.12.6), read from the
# /releases/latest redirect, which skips pre-releases and has no API rate limit.
latest_tag() {
  local url
  url=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest") || return 1
  [[ $url == */releases/tag/* ]] || return 1
  printf '%s\n' "${url##*/tag/}"
}

# Succeeds when $1 should be (re)installed: when missing or below minimum $2,
# and with --tools-only also whenever it is not the latest release tag $3.
needs_install() {
  has_version "$1" "$2" || return 0
  $UPGRADE_TO_LATEST && [[ $(installed_version "$1") != "${3#v}" ]]
}

# Release asset arch names: neovim uses x86_64/arm64, tree-sitter x64/arm64.
release_arch() {
  case $(uname -m) in
    x86_64) printf '%s %s\n' x86_64 x64 ;;
    aarch64|arm64) printf '%s %s\n' arm64 arm64 ;;
    *) die "unsupported architecture for release binaries: $(uname -m)" ;;
  esac
}

# Debian/Ubuntu apt versions are too old, so install stable releases
# system-wide: nvim into /opt with a /usr/local/bin link, and the tree-sitter
# binary into /usr/local/bin (ahead of /usr/bin, and in sudo's PATH).
install_release_binaries() {
  local nvim_arch ts_arch tmp tag
  read -r nvim_arch ts_arch < <(release_arch)
  tmp=$(mktemp -d)

  tag=$(latest_tag neovim/neovim) || die "could not determine the latest Neovim release"
  if needs_install nvim "$NVIM_MIN_VERSION" "$tag"; then
    say "Installing Neovim $tag into /opt"
    curl -fsSL "https://github.com/neovim/neovim/releases/download/$tag/nvim-linux-$nvim_arch.tar.gz" |
      tar -xz -C "$tmp"
    "${SUDO[@]}" rm -rf "/opt/nvim-linux-$nvim_arch"
    "${SUDO[@]}" mv "$tmp/nvim-linux-$nvim_arch" /opt/
    "${SUDO[@]}" chown -R root:root "/opt/nvim-linux-$nvim_arch"
    "${SUDO[@]}" ln -sfn "/opt/nvim-linux-$nvim_arch/bin/nvim" /usr/local/bin/nvim
  fi

  tag=$(latest_tag tree-sitter/tree-sitter) || die "could not determine the latest tree-sitter release"
  if needs_install tree-sitter "$TREE_SITTER_MIN_VERSION" "$tag"; then
    say "Installing tree-sitter CLI $tag into /usr/local/bin"
    curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/download/$tag/tree-sitter-linux-$ts_arch.gz" |
      gunzip >"$tmp/tree-sitter"
    "${SUDO[@]}" install -m 755 "$tmp/tree-sitter" /usr/local/bin/tree-sitter
  fi

  rm -rf "$tmp"
}

# Debian/Ubuntu apt tmux is too old, and tmux ships no prebuilt binaries, so
# build the release from source into /usr/local as its README describes.
install_tmux_from_source() {
  local version tmp
  version=$(latest_tag tmux/tmux) || die "could not determine the latest tmux release"
  needs_install tmux "$TMUX_MIN_VERSION" "$version" || return 0

  say "Building tmux $version from source into /usr/local"
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/tmux/tmux/releases/download/$version/tmux-$version.tar.gz" |
    tar -xz -C "$tmp"
  (
    cd "$tmp/tmux-$version"
    ./configure --prefix=/usr/local >/dev/null
    make -j"$(nproc)" >/dev/null
    "${SUDO[@]}" make install >/dev/null
  )
  rm -rf "$tmp"
}

install_debian() {
  say "Installing packages with apt"
  "${SUDO[@]}" apt-get update
  "${SUDO[@]}" apt-get install -y \
    build-essential zoxide fzf stow git curl tar gzip \
    libevent-dev libncurses-dev bison pkg-config

  if ! "${SUDO[@]}" apt-get install -y eza; then
    warn "eza is not available in this apt release; install it from https://github.com/eza-community/eza"
  fi

  if ! command -v starship >/dev/null 2>&1; then
    say "Installing starship"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
  fi

  install_release_binaries
  install_tmux_from_source
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
       ./install.sh --tools-only

Installs the required tools, then stows dotfiles packages into $HOME.

  (no arguments)  Stow every package
  all             Stow every package
  <package>...    Stow only the named packages (e.g. bash nvim tmux)
  --tools-only    Install tools and upgrade Neovim, tree-sitter and tmux to
                  their latest stable releases; stow nothing
  -h, --help      Show this help

On Debian/Ubuntu, Neovim, tree-sitter and tmux come from their upstream
releases. Normal runs only replace them when missing or below the version the
configs need; --tools-only always moves them to the latest stable release. On
Arch they come from pacman, so update them with a full system upgrade.

The ghostty package is skipped on WSL, where Ghostty is not supported.
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

  for tool in nvim tree-sitter tmux eza zoxide fzf starship stow opencode; do
    command -v "$tool" >/dev/null 2>&1 || warn "$tool is not installed"
  done

  has_version nvim "$NVIM_MIN_VERSION" || warn "nvim $NVIM_MIN_VERSION or newer is required by the nvim config"
  has_version tree-sitter "$TREE_SITTER_MIN_VERSION" ||
    warn "tree-sitter $TREE_SITTER_MIN_VERSION or newer is required by nvim-treesitter"
  has_version tmux "$TMUX_MIN_VERSION" || warn "tmux $TMUX_MIN_VERSION or newer is required by .tmux.conf"

  if ! is_wsl; then
    command -v ghostty >/dev/null 2>&1 || warn "ghostty is not installed"
  fi
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

    if ! package_supported "$package"; then
      say "Skipping $package (not supported on this platform)"
      continue
    fi

    if [[ $package == bash && -e "$HOME/.config/bash" && ! -L "$HOME/.config/bash" ]]; then
      die "$HOME/.config/bash already exists and is not a symlink; move it aside and re-run"
    fi

    displace_targets "$package"
    ( cd "$DOTFILES_DIR" && stow --target="$HOME" "$package" )
  done
}

# Remove symlinks left pointing into this repo at files or packages that no
# longer exist (e.g. after a package is deleted or restructured). Only broken
# links into $DOTFILES_DIR are touched.
prune_stale_links() {
  local link target

  while IFS= read -r -d '' link; do
    target=$(readlink -m -- "$link")
    [[ $target == "$DOTFILES_DIR"/* ]] || continue
    say "Removing stale link $link (pointed to ${target#"$DOTFILES_DIR"/})"
    rm -- "$link"
  done < <(
    find "$HOME" -maxdepth 1 -xtype l -print0
    find "$HOME/.config" "$HOME/.local/bin" -maxdepth 3 -xtype l -print0 2>/dev/null
  )
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
  local tools_only=false
  local arg

  for arg in "$@"; do
    case $arg in
      -h|--help)
        usage
        exit 0
        ;;
      --tools-only)
        tools_only=true
        UPGRADE_TO_LATEST=true
        ;;
      -*)
        die "unknown option: $arg (see --help)"
        ;;
      all)
        mapfile -t -O "${#packages[@]}" packages < <(all_packages)
        ;;
      *)
        packages+=("$arg")
        ;;
    esac
  done

  if $tools_only; then
    [[ ${#packages[@]} -eq 0 ]] || die "--tools-only does not take package names"
    install_tools
    say "Done. Tools installed; nothing was stowed."
    return
  fi

  if [[ ${#packages[@]} -eq 0 ]]; then
    mapfile -t packages < <(all_packages)
  fi

  install_tools
  sync_inputrc
  prune_stale_links
  link_packages "${packages[@]}"
  ensure_bashrc_source
  say "Done. Open a new shell or run: exec bash"
}

main "$@"
