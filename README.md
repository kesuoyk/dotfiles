# dotfiles

このリポジトリは、個人開発環境の dotfiles を管理します。
現在は以下を主に管理対象としています。

- Git (`.gitconfig`, `.gitignore_global`)
- Tig (`.tigrc`)
- Zsh (`.zshrc`)
- Neovim (`.config/nvim/`)

## Setup

依存関係を一括導入:

```bash
bash setup.sh
```

導入確認:

```bash
brew bundle check --file Brewfile
```

## Neovim 詳細

Neovim 設定の詳細は以下を参照:

- `.config/nvim/README.md`
