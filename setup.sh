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
echo "Done."
