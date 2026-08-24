#!/bin/bash
set -euo pipefail

"$HOME/.local/bin/tmux-theme-palette"

tmux list-sessions >/dev/null 2>&1 || exit 0
tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1 || true
