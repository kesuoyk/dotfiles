# Neovim Configurations

## Requirements

以下のコマンドが `PATH` にあることを想定しています。

- `nvim`
- `git`
- `node` / `npm` - Vue/TypeScript LSP 用
- `ruby` - ruby-lsp 用
- Cコンパイラ (`cc`) と `make` - treesitter parser ビルド用
- [rg](https://github.com/BurntSushi/ripgrep) - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) 用
- [fd](https://github.com/sharkdp/fd) - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) 用

依存導入は dotfiles ルートのセットアップスクリプトを使用

## Install

1. Neovim を起動してプラグイン同期

```vim
:Lazy sync
```

2. treesitter parser をインストール

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
- `lua_ls`

## Env Overrides

Vue/TypeScript LSP 連携のパスは、以下の環境変数で上書きできます。

- `NVIM_NODE_MODULES_DIR`: global `node_modules` のルート
- `NVIM_VUE_TYPESCRIPT_PLUGIN`: `@vue/typescript-plugin` の絶対パス
- `NVIM_TYPESCRIPT_TSDK`: TypeScript `lib` ディレクトリの絶対パス

未指定時は `npm root -g` を優先し、見つからない場合のみ既知パスへフォールバックします。
