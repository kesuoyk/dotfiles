#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_ROOT/Brewfile"
MISE_CONFIG_DIR="$REPO_ROOT/.config/mise"
MISE_CONFIG="$MISE_CONFIG_DIR/config.toml"
HOME_MISE_CONFIG="$HOME/.config/mise/config.toml"

link_path() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    ln -sfn "$source" "$target"
    return
  fi

  if [[ -e "$target" ]]; then
    if [[ -f "$source" && -f "$target" ]] && cmp -s "$source" "$target"; then
      rm "$target"
    else
      local backup="$target.backup.$(date +%Y%m%d%H%M%S)"
      mv "$target" "$backup"
      echo "Backed up existing $target to $backup"
    fi
  fi

  ln -s "$source" "$target"
}

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

echo "Linking dotfiles ..."
link_path "$REPO_ROOT/.gitconfig" "$HOME/.gitconfig"
link_path "$REPO_ROOT/.gitignore_global" "$HOME/.gitignore_global"
link_path "$REPO_ROOT/.tigrc" "$HOME/.tigrc"
link_path "$REPO_ROOT/.zprofile" "$HOME/.zprofile"
link_path "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
link_path "$REPO_ROOT/.config/nvim" "$HOME/.config/nvim"
link_path "$MISE_CONFIG" "$HOME_MISE_CONFIG"

for skill_dir in "$REPO_ROOT/.claude/skills"/*/; do
  skill_name="$(basename "$skill_dir")"
  link_path "$REPO_ROOT/.claude/skills/$skill_name" "$HOME/.claude/skills/$skill_name"
done

if ! command -v mise >/dev/null 2>&1; then
  echo "Error: mise not found in PATH after brew bundle." >&2
  exit 1
fi

echo "Installing tools from $HOME_MISE_CONFIG ..."
mise trust "$HOME_MISE_CONFIG"
mise install --yes

echo "Done."
