#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_ROOT/Brewfile"

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

echo "Installing global npm packages ..."
npm install -g \
  typescript \
  typescript-language-server \
  @vue/language-server \
  @vue/typescript-plugin \
  @tailwindcss/language-server \
  @anthropic-ai/claude-code

echo "Installing Ruby via mise and global gems ..."
if ! command -v mise >/dev/null 2>&1; then
  echo "Error: mise not found in PATH after brew bundle." >&2
  exit 1
fi
mise use -g ruby@3.4.4
mise exec ruby@3.4.4 -- gem install ruby-lsp

echo "Done."
