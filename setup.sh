#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_ROOT/Brewfile"
MISE_CONFIG_DIR="$REPO_ROOT/.config/mise"
MISE_CONFIG="$MISE_CONFIG_DIR/config.toml"
HOME_MISE_CONFIG="$HOME/.config/mise/config.toml"

if ! command -v brew >/dev/null 2>&1; then
  echo "Error: Homebrew is required but 'brew' was not found in PATH." >&2
  echo "Install Homebrew first: https://brew.sh" >&2
  exit 1
fi

if [[ ! -f "$BREWFILE" ]]; then
  echo "Error: Brewfile not found at $BREWFILE" >&2
  exit 1
fi

echo "Installing dependencies from $BREWFILE ..."
brew bundle --file "$BREWFILE"

if ! command -v mise >/dev/null 2>&1; then
  echo "Error: mise not found in PATH after brew bundle." >&2
  exit 1
fi

echo "Linking mise config to $HOME_MISE_CONFIG ..."
mkdir -p "$(dirname "$HOME_MISE_CONFIG")"
if [[ -e "$HOME_MISE_CONFIG" && ! -L "$HOME_MISE_CONFIG" ]]; then
  if cmp -s "$MISE_CONFIG" "$HOME_MISE_CONFIG"; then
    rm "$HOME_MISE_CONFIG"
  else
    backup="$HOME_MISE_CONFIG.backup.$(date +%Y%m%d%H%M%S)"
    mv "$HOME_MISE_CONFIG" "$backup"
    echo "Backed up existing mise config to $backup"
  fi
fi
ln -sfn "$MISE_CONFIG" "$HOME_MISE_CONFIG"

echo "Installing tools from $HOME_MISE_CONFIG ..."
mise trust "$HOME_MISE_CONFIG"
mise install --yes

echo "Installing Ruby gems for mise-managed Ruby ..."
mise exec ruby -- gem install ruby-lsp

echo "Done."
