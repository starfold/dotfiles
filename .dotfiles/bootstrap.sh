#!/usr/bin/env bash
set -euo pipefail

DOT="${DOTFILES_DIR:-$HOME/.dotfiles}"
REPO="${DOTFILES_REPO:-git@github.com:starfold/dotfiles.git}"

if [[ ! -d "$DOT" ]]; then
  git clone --bare "$REPO" "$DOT"
fi

dot() { git --git-dir="$DOT/" --work-tree="$HOME" "$@"; }

dot config --local status.showUntrackedFiles no

if ! dot checkout; then
  echo "Checkout blocked by existing files. Back them up, then rerun."
  dot checkout 2>&1 | sed -n '/^\s/p'
  exit 1
fi

echo "Dotfiles checked out. Reload the shell."
