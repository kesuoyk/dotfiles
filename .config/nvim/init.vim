let g:nvim_config_file = $XDG_CONFIG_HOME . '/nvim/init.vim'

source $XDG_CONFIG_HOME/nvim/autoload/util.vim

" ローカル設定ファイルを読み込む
" 読み込み順を制御したいので exrc は使わない
if (filereadable('./.localrc.vim'))
    source ./.localrc.vim
endif

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" ------------------
"   プラグイン管理
" ------------------
" {{{

" dein のプラグイン用ディレクトリ
let s:dein_plugin_dir = $XDG_CACHE_HOME . '/dein/plugins'

" dein 本体のディレクトリ
let s:dein_dir = s:dein_plugin_dir . '/repos/github.com/Shougo/dein.vim'

" dein を導入してなかったら git clone
if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim.git ' . s:dein_dir
endif

" runtimepath に追加
execute 'set runtimepath+=' . s:dein_dir

if &compatible
  set nocompatible
endif

if dein#load_state(s:dein_plugin_dir)
  call dein#begin(s:dein_plugin_dir)

  " プラグインを TOML から読み込む
  call dein#load_toml($XDG_CONFIG_HOME . '/dein/plugin.toml', {'lazy': 0})
  call dein#load_toml($XDG_CONFIG_HOME . '/dein/plugin_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" 未インストールのプラグインをインストール
if dein#check_install()
    call dein#install()
endif

" アンイストール用コマンド
function! s:deinClean()
  if len(dein#check_clean())
      call map(dein#check_clean(), 'delete(v:val)')
      call dein#recache_runtimepath()
      echo 'dein clean finished'
  else
      echo '[ERR] no disabled plugins'
  endif
endfunction
command! DeinClean :call s:deinClean()

" nvim-lsp の設定
lua << EOF
vim.lsp.config('ts_ls', {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "typescript",
    "javascript",
    "vue",
  },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/opt/homebrew/lib/node_modules/@vue/typescript-plugin",
        languages = {
          "javascript",
          "typescript",
          "vue"
        },
      },
    },
    typescript = {
      serverPath = "/opt/homebrew/lib/node_modules/typescript-language-server",
      tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
    },
  },
})

--vim.lsp.config('volar', {
--  filetypes = {'typescript', 'javascript', 'vue', 'json'}
--})

vim.lsp.config('ruby_lsp', {
--  init_options = {
--    formatter = 'standard',
--    linters = { 'standard' },
--  },
--  addonSettings = {
--    ["Ruby LSP Rails"] = {
--      enablePendingMigrationsPrompt = false,
--    },
--  },
})

vim.lsp.config('eslint', {
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 1000,
  },
})

vim.lsp.enable('ts_ls')
vim.lsp.enable('ruby_lsp')
vim.lsp.enable('eslint')

EOF

augroup plugin
    autocmd!
    " autocmd Filetype json :IndentGuidesDisable
    autocmd Filetype json set conceallevel=0
augroup END

"}}}

" --------------
"   マッピング
" --------------
"{{{

" ハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" 次のバッファへ移動
" nnoremap <silent> <C-n> :<C-u>bn<CR>

" 前のバッファへ移動
" nnoremap <silent> <C-p> :<C-u>bp<CR>

" インサートモード中に横移動
inoremap <C-b> <C-o>h
inoremap <C-f> <C-o>l

" 表示行単位での移動を基本に
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj jk

" ウィンドウ切り替え
nnoremap <C-p> <C-w><S-w>
nnoremap <C-n> <C-w><C-w>

" コマンドラインで Emacs 風に移動
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

" quickfix window 用
nnoremap ]q :<C-u>cnext<CR>
nnoremap [q :<C-u>cprevious<CR>

" LSP
nnoremap <silent> ]d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ga <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gd <cmd>lua vim.diagnostic.open_float()<CR>

tmap <C-¥> <C-\>

"}}}

" ---------------------
"   Leader マッピング
" ---------------------
"{{{

let mapleader = "\<Space>"

" 設定ファイルを開く
nnoremap <silent> <Leader>,<Space> :<C-u>tabnew \| call util#open_config_file()<CR>
" 設定ファイルを再読込
nnoremap <silent> <Leader>,r :<C-u>call util#reload_config_file()<CR>

nnoremap <silent> <Leader>q<Space> :<C-u>q<CR>
nnoremap <silent> <Leader>qa<Space> :<C-u>qa<CR>
nnoremap <silent> <Leader>w<Space> :<C-u>w<CR>
nnoremap <silent> <Leader>wq<Space> :<C-u>wq<CR>
nnoremap <silent> <Leader>wqa<Space> :<C-u>wqa<CR>

" 最初のレジスタを貼り付け
nnoremap <silent> <Leader>rp "0p
" 下に改行を挿入
nnoremap <Leader>o o<ESC>
" 上に改行を挿入
nnoremap <Leader><S-o> O<ESC>
" ペーストモード切り替え
nnoremap <silent> <Leader>p :<C-u>call util#toggle_paste_mode()<CR>
" 折返しの有無の切り替え
nnoremap <silent> <Leader>wt :<C-u>call util#toggle_wrap()<CR>

nnoremap <silent> <Leader>bd :<C-u>bd<CR>

" ウィンドウ切り替え
for i in range(1, 9)
  execute "nnoremap \<Leader>" . i . " " . i . "<C-w><C-w>"
endfor

" タブ切り替え
for i in range(1, 9)
  execute "nnoremap \<Leader><Space>" . i . " " . i . "gt"
endfor

nnoremap <silent> <Leader>l :exe "vertical resize " . "+16"<CR>
nnoremap <silent> <Leader>h :exe "vertical resize " . "-16"<CR>
nnoremap <silent> <Leader>k :exe "resize " . "+8"<CR>
nnoremap <silent> <Leader>j :exe "resize " . "-8"<CR>

" vim-indent-guides
nnoremap <silent> <Leader>ig <Plug>IndentGuidesToggle

" fugitive
nnoremap <silent> <Leader>g :<C-u>Git<CR>
nnoremap <silent> <Leader>gq :<C-u>Git<CR>

" vim-quickrun
nnoremap <silent> <Leader>x :<C-u>QuickRun<CR>

" Defx
nnoremap <silent> <Leader>e<Space> :<C-u>Defx -buffer-name=`'defx' . tabpagenr()` -toggle<CR>
nnoremap <silent> <Leader>e. :<C-u>Defx `expand('%:p:h')` -buffer-name=`'defx' . tabpagenr()` -search=`expand('%:p')`<CR>

" Denite
nnoremap <silent> <Leader>sb :<C-u>Denite buffer<CR>
nnoremap <silent> <Leader>sc :<C-u>Denite command<CR>
nnoremap <silent> <Leader>sh :<C-u>Denite command_history<CR>
nnoremap <silent> <Leader>sd :<C-u>Denite directory_rec<CR>
nnoremap <silent> <Leader>sg :<C-u>Denite grep -resume -refresh -buffer-name=denite-grep<CR>
nnoremap <silent> <Leader>sf :<C-u>Denite file/rec -resume -refresh -buffer-name=denite-file-rec<CR>
nnoremap <silent> <Leader>sl :<C-u>Denite line<CR>
nnoremap <silent> <Leader>so :<C-u>Denite outline<CR>
nnoremap <silent> <Leader>sm :<C-u>Denite mark<CR>

" memolist.vim
nnoremap <Leader>mn :vnew \| wincmd L \| vertical resize 50 \| set winfixwidth \| set nonumber \| MemoNew<CR>
nnoremap <Leader>ml :vnew \| wincmd L \| vertical resize 50 \| set winfixwidth \| set nonumber \| MemoList<CR>
nnoremap <Leader>mg :vnew \| wincmd L \| vertical resize 50 \| set winfixwidth \| set nonumber \| MemoGrep<CR>

" vim-test
nnoremap <Leader>tn :<C-u>TestNearest<CR>
nnoremap <Leader>tf :<C-u>TestFile<CR>
nnoremap <Leader>ts :<C-u>TestSuite<CR>
nnoremap <Leader>tl :<C-u>TestLast<CR>
nnoremap <Leader>tg :<C-u>TestVisit<CR>

"}}}

" -----------
"   Vim設定
" -----------
" {{{

" --- 基本オプション ---
let g:netrw_dirhistmax = 0 "netrw の履歴ファイルを作らない

syntax on
"set exrc " ローカルの設定ファイルをを許可
"set secure " ローカルの設定ファイルで autocmd を許可しない
set redrawtime=10000 "重い再描画の際に syntax off になるまでの時間
set backupcopy=yes
set conceallevel=0
set concealcursor=niv

set mouse=a " マウス機能
set hidden " 隠れバッファの許可
set clipboard^=unnamed,unnamedplus " yank 時に '+' と '*' レジスタにコピーする
set breakindent " 行の折り返し時にインデントを考慮する
set undofile " 永続的Undo機能
set diffopt+=iwhite " vimdiff のとき空白を無視
set ambiwidth=double
set virtualedit=all
set background=dark

augroup basic
    autocmd!
    " 参考: https://vim.fandom.com/wiki/Fix_syntax_highlighting
    " autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
    " autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
augroup END

" --- カーソル移動 ---
set scrolloff=8 " 上下8行の視界を確保
set sidescrolloff=16 " 左右スクロール時の視界を確保
set sidescroll=1 " 左右スクロールは1文字ずつ行う

" --- エンコーディング ---
set encoding=utf8 " Vimが内部で用いるエンコーディング

" --- 折りたたみ ---
set foldopen-=search
set foldminlines=0
set foldmethod=manual

function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    " if getline(v:lnum) =~ '^## .*$'
    "     return ">2"
    " endif
    " if getline(v:lnum) =~ '^### .*$'
    "     return ">3"
    " endif
    " if getline(v:lnum) =~ '^#### .*$'
    "     return ">4"
    " endif
    " if getline(v:lnum) =~ '^##### .*$'
    "     return ">5"
    " endif
    " if getline(v:lnum) =~ '^###### .*$'
    "     return ">6"
    " endif
    return "="
endfunction

augroup folding
    autocmd!
    " autocmd BufEnter *.md,*.markdown setlocal foldexpr=MarkdownLevel()
    " autocmd BufEnter *.md,*.markdown setlocal foldmethod=expr
augroup END

" --- タグ ---
" set tags=tags
set tagbsearch " タグファイル検索時に二分探索を使う
set tagcase=ignore " タグファイルの検索

" --- セッション ---
" セッションに保存する項目
set sessionoptions=buffers,curdir,folds,help,localoptions,tabpages,winpos,winsize

" --- 見た目 ---
set showmatch " 対応する括弧を強調表示
set cursorline " カーソルラインの強調表示
"set cursorcolumn " カーソルラインの強調表示（縦）
set number " 行番号の表示
set colorcolumn=100 " 縦のライン表示
set showcmd " 入力中のコマンドを表示
set list " 不可視文字を表示
set listchars=tab:>-,trail:-

" --- 検索 / 置換 ---
set hlsearch " 検索キーワードをハイライト
set incsearch " インクリメンタル検索を有効化
set ignorecase " case-insensitive で検索する
set smartcase " 検索パターンが upper-case の場合は case-sensitive にする
set gdefault " 置換の時 g オプションをデフォルトで有効にする
set inccommand=split
set wildignore+=**/node_modules/**
set wildignore+=**/\.git/**
set wildignore+=**/vendor/**

" --- タブ ---
set showtabline=2 " タブラインを常に表示
set tabline=%!ui#tabline()

" --- ウィンドウ ---
set splitbelow " 新しいウィンドウを下に開く
set splitright " 新しいウィンドウを右に開く
set winwidth=30 " ウィンドウの最小幅
set winheight=10 " カレントウィンドウの最小の高さ
set winminheight=0 " ウィンドウの最小の高さ
set noequalalways " ウィンドウを閉じたり開いたりした場合に、カレントウィンドウ以外の高さ、幅を整えない

augroup window
    autocmd!
    " autocmd FileType qf wincmd L | vertical resize 70 | set winfixwidth
augroup END

" --- ステータスライン ---
set laststatus=2 " ステータスラインを常に表示
set statusline=%!ui#statusline()

" --- 補完機能 ---
set wildmenu " 候補をビジュアル的に表示
set wildmode=list:full

" --- インデント ---
set tabstop=4 " タブ文字の幅
set softtabstop=4 " 削除する空白の数
set shiftwidth=4 " >>で移動するタブ幅
set autoindent " 自動インデント
set smartindent " C言語スタイルのブロックを自動挿入
set expandtab " タブ文字を空白に展開

filetype plugin indent on

augroup indent
    autocmd!
    autocmd FileType css             setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType html            setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType javascript      setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType json            setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType markdown        setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType pug             setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType ruby            setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType sass            setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType scss            setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType smarty          setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType toml            setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType typescript      setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType typescript.tsx  setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType typescriptreact setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType vue             setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType yaml            setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" ---------------------
"     テンプレート
" ---------------------
autocmd BufNewFile *.php 0r $XDG_CONFIG_HOME/nvim/template/t.php
autocmd BufNewFile *.sh 0r $XDG_CONFIG_HOME/nvim/template/t.sh

" vim:set foldmethod=marker:
