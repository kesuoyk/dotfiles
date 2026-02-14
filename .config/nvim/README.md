# nvim-next

`lazy.nvim + Lua` ベースの Neovim 設定です。
新規導入を前提に、必要な依存関係と初期セットアップ手順をまとめています。

## Requirements

以下のコマンドが `PATH` にあることを想定しています。

- `nvim` (0.11+)
- `git`
- `rg` (ripgrep)
- `node` / `npm` (Vue/TypeScript LSP 用)
- `ruby` (ruby-lsp 用)
- C コンパイラ (`cc`) と `make` (treesitter parser ビルド用)

## Install

1. 設定を配置

```bash
git clone <your-dotfiles-or-repo> ~/.config/nvim
```

2. Neovim を起動してプラグイン同期

```vim
:Lazy sync
```

3. treesitter parser をインストール

```vim
:TSUpdate
```

## Directory

- `init.lua`: エントリポイント
- `lua/config/options.lua`: 基本オプション
- `lua/config/keymaps.lua`: 主要キーマップ
- `lua/config/lazy.lua`: lazy.nvim bootstrap
- `lua/plugins/*.lua`: 機能別プラグイン定義

## LSP

この設定で有効化している LSP:

- `ts_ls`
- `vue_ls`
- `ruby_lsp`

## Env Overrides

Vue/TypeScript LSP 連携のパスは、以下の環境変数で上書きできます。

- `NVIM_NODE_MODULES_DIR`: global `node_modules` のルート
- `NVIM_VUE_TYPESCRIPT_PLUGIN`: `@vue/typescript-plugin` の絶対パス
- `NVIM_TYPESCRIPT_TSDK`: TypeScript `lib` ディレクトリの絶対パス

未指定時は `npm root -g` を優先し、見つからない場合のみ既知パスへフォールバックします。
