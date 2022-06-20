" ----------
"   初期化
" ----------
let s:config_dir = ''
let s:config_file = ''

filetype off
filetype plugin indent off

" --- 汎用関数 ---
function! MkdirIfNoExists(dir)
    if !isdirectory(a:dir)
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
    return a:dir
endfunction

if has('nvim')
    let s:config_dir = $HOME . '/.config/nvim'
    let s:config_file = s:config_dir . '/init.vim'
else
    let s:config_dir = $HOME . '/.vim'
    let s:config_file = $HOME . '/.vimrc'
endif

call MkdirIfNoExists(s:config_dir)

" ディレクトリ作成
for dir in ['colors', 'dicts', 'plugins', 'sessions', 'tags', 'tmp', 'undo', 'template', 'snips']
    call MkdirIfNoExists(s:config_dir . '/' . dir)
endfor


" ------------------
"   プラグイン管理
" ------------------
" --- dein ---
let s:dein_dir = s:config_dir . '/plugins/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
    set nocompatible
endif

" deinが導入されてなければclone
if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim.git' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

" 管理するプラグイン
call dein#begin(s:dein_dir)
call dein#add(s:dein_repo_dir)

call dein#add('scrooloose/nerdtree')
call dein#add('scrooloose/nerdcommenter')
call dein#add('michaeljsmith/vim-indent-object')
call dein#add('tpope/vim-surround')
call dein#add('cohama/lexima.vim')
call dein#add('thinca/vim-quickrun')
call dein#add('ToruIwashita/git-switcher.vim')
call dein#add('mattn/emmet-vim')
call dein#add('flyinshadow/php_localvarcheck.vim')
call dein#add('junegunn/vim-easy-align')
call dein#add('glidenote/memolist.vim')
call dein#add('junegunn/fzf.vim')
call dein#add('SirVer/ultisnips')
call dein#add('kana/vim-submode')

" シンタックスハイライト系
call dein#add('othree/html5.vim')
call dein#add('ap/vim-css-color')
call dein#add('hail2u/vim-css3-syntax')
call dein#add('othree/yajs.vim')
call dein#add('jwalton512/vim-blade')
call dein#add('posva/vim-vue')

" Color Schemes
call dein#add('tomasr/molokai')
call dein#add('ciaranm/inkpot')
call dein#add('jacoborus/tender.vim')
call dein#add('jpo/vim-railscasts-theme')

"call dein#add('nathanaelkane/vim-indent-guides') " シンタックスハイライトがおかしくなる？
"call dein#add('Valloric/MatchTagAlways') " 重くなる
"call dein#add('cocopon/vaffle.vim')
"call dein#add('vim-syntastic/syntastic')
"call dein#add('mtscout6/syntastic-local-eslint.vim')
"call dein#add('davidhalter/jedi-vim')
"call dein#add('wincent/command-t')
"call dein#add('tpope/vim-fugitive')
"call dein#add('Shougo/denite.nvim')
"call dein#add('editorconfig/editorconfig-vim') " なぜか.vueのインデントが4に固定される

call dein#end()

" 未インストールのプラグインをインストール
if dein#check_install()
    call dein#install()
endif

function! s:deinClean()
  if len(dein#check_clean())
      call map(dein#check_clean(), 'delete(v:val)')
      echo 'dein clean finished'
  else
      echo '[ERR] no disabled plugins'
  endif
endfunction
command! DeinClean :call s:deinClean()


" -- git-switcher.vim ---
" セッションを保存するディレクトリパス。
let g:gsw_sessions_dir = s:config_dir . '/sessions'

" Gswコマンド実行時にセッションの保存の確認を行う。デフォルトはyes。
let g:gsw_save_session_confirm = 'yes'

" vim起動時のセッション自動ロード設定。yes、no、confirmを設定可能でデフォルトはno。
let g:gsw_autoload_session = 'confirm'

" vim起動時保存したセッションのうちローカルに同じ名前のブランチが存在しないものを削除する。
" yes、no、confirmを設定可能でデフォルトはno。
let g:gsw_autodelete_sessions_if_branch_not_exist = 'confirm'


" --- Syntastic.vim ---
" linterの設定
let g:syntastic_javascript_checkers=['eslint']

" エラー行に sign を表示
let g:syntastic_enable_signs = 1

" location list を常に更新
let g:syntastic_always_populate_loc_list = 1

" location list を常に表示
let g:syntastic_auto_loc_list = 0

" ファイルを開いた時にチェックを実行する
let g:syntastic_check_on_open = 1

" :wq で終了する時もチェックする
let g:syntastic_check_on_wq = 0


" --- vim-indent-guides ---
"let g:indent_guides_start_level = 2
"let g:indent_guides_guide_size = 1


" --- emmet-vim ---
let g:user_emmet_mode = 'a'
let g:user_emmet_leader_key = '<C-Y>'


" --- fzf.vim ---
set rtp+=/usr/local/opt/fzf


" --- MatchTagAlways ---
let g:mta_filetypes = {
  \ 'html': 1,
  \ 'xhtml': 1,
  \ 'xml': 1,
  \ 'jinja': 1,
  \ 'smarty': 1,
  \ 'blade': 1,
  \ 'vue': 1,
\ }

" --- UltiSnips ---
let g:UltiSnipsSnippetsDir = s:config_dir . '/snips'
let g:UltiSnipsSnippetDirectories = [s:config_dir . '/snips']


" -----------
"   Vim設定
" -----------
let s:win_width_min=50
let s:win_height_min=20

" --- キーマッピング ---
function! MyInsCompl()
  let c = nr2char(getchar())
  if c == "l"
    return "\<C-x>\<C-l>"
  elseif c == "n"
    return "\<C-x>\<C-n>"
  elseif c == "p"
    return "\<C-x>\<C-p>"
  elseif c == "k"
    return "\<C-x>\<C-k>"
  elseif c == "t"
    return "\<C-x>\<C-t>"
  elseif c == "i"
    return "\<C-x>\<C-i>"
  elseif c == "]"
    return "\<C-x>\<C-]>"
  elseif c == "f"
    return "\<C-x>\<C-f>"
  elseif c == "d"
    return "\<C-x>\<C-d>"
  elseif c == "v"
    return "\<C-x>\<C-v>"
  elseif c == "u"
    return "\<C-x>\<C-u>"
  elseif c == "o"
    return "\<C-x>\<C-o>"
  elseif c == "s"
    return "\<C-x>s"
  endif
  return "\<C-Space>"
endfunction

" 改行されてても上下移動
nnoremap j gj
nnoremap k gk

" 誤爆しないように
nnoremap Q <Nop>

" 次のタブへ移動
nnoremap <silent> <C-n> :<C-u>tabnext<CR>

" 前のタブへ移動
nnoremap <silent> <C-p> :<C-u>tabprevious<CR>

" 次のウィンドウへ移動
nnoremap <C-j> <C-w>w

" 前のウィンドウへ移動
nnoremap <C-k> <C-w>W

" インサートモード中に横移動
inoremap <C-b> <C-o>h
inoremap <C-f> <C-o>l

" 補完
"inoremap <expr><C-Space> pumvisible() ? "\<C-n>" : MyInsCompl()

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" NVimのターミナル脱出
if has('nvim')
    tnoremap <silent> <ESC> <C-\><C-n>
endif

" --- Leaderマッピング ---
let mapleader = "\<Space>"
let s:is_full_win_mode = 0
let s:is_full_horizontal_win_mode = 0
let s:is_full_vertical_win_mode = 0

function! OpenConfigFile()
    execute 'tabe '. s:config_file
endfunction

if !exists('*ReloadConfigFile')
    function! ReloadConfigFile()
        execute 'bufdo source '. s:config_file
        echo s:config_file . ' loaded'
    endfunction
endif

function! ToggleFullWindowMode()
    if s:is_full_win_mode
        execute 'set winwidth=' . s:win_width_min
        execute 'set winheight=' . s:win_height_min
        let s:is_full_win_mode = 0
        execute "normal! \<C-w>="
    else
        set winwidth=9999
        set winheight=9999
        let s:is_full_win_mode = 1
    endif
endfunction

function! ToggleHorizontalFullWindowMode()
    if s:is_full_horizontal_win_mode
        execute 'set winwidth=' . s:win_width_min
        let s:is_full_horizontal_win_mode = 0
        execute "normal! \<C-w>="
    else
        set winwidth=9999
        let s:is_full_horizontal_win_mode = 1
        if s:is_full_vertical_win_mode
            let s:is_full_win_mode = 1
        endif
    endif
endfunction

function! ToggleVerticalFullWindowMode()
    if s:is_full_vertical_win_mode
        execute 'set winheight=' . s:win_height_min
        let s:is_full_vertical_win_mode = 0
        execute "normal! \<C-w>="
    else
        set winheight=9999
        let s:is_full_vertical_win_mode = 1
        if s:is_full_horizontal_win_mode
            let s:is_full_win_mode = 1
        endif
    endif
endfunction

function! TogglePasteMode()
    if &paste == 'paste'
        set nopaste
        echo 'Paste mode off'
    else
        set paste
        echo 'Paste mode on'
    endif
endfunction

augroup mapping
    autocmd!
augroup END

" 設定ファイルを開く
nnoremap <silent> <Leader>co :<C-u>call OpenConfigFile()<CR>

" 設定ファイルを再読込
nnoremap <silent> <Leader>cr :<C-u>call ReloadConfigFile()<CR>

" 最初のレジスタを貼り付け
nnoremap <silent> <Leader>rp "0p

" 下に改行を挿入
nnoremap <Leader><Space> o<ESC>

" 現在行と列のハイライトを切替
nnoremap <silent> <Leader>cl :<C-u>setlocal cursorline! cursorcolumn!<CR>

" 常にカレントウィンドウの大きさを最大にする or 戻す
nnoremap <silent> <Leader>wa :<C-u>call ToggleFullWindowMode()<CR>

" 常にカレントウィンドウの幅を最大にする or 戻す
nnoremap <silent> <Leader>wh :<C-u>call ToggleHorizontalFullWindowMode()<CR>

" 常にカレントウィンドウの高さを最大にする or 戻す
nnoremap <silent> <Leader>wv :<C-u>call ToggleVerticalFullWindowMode()<CR>

" ペーストモード切り替え
nnoremap <silent> <Leader>p :<C-u>call TogglePasteMode()<CR>

" NERDTree
nnoremap <silent> <Leader>ft :<C-u>NERDTreeToggle<CR>

" vim-indent-guides
"nnoremap <silent> <Leader>ig :<C-u>IndentGuidesToggle<CR>

" memolist.vim
nnoremap <silent> <Leader>mn  :<C-u>MemoNew<CR>
nnoremap <silent> <Leader>ml  :<C-u>MemoList<CR>
nnoremap <silent> <Leader>mg  :<C-u>MemoGrep<CR>

" fzf.vim
nnoremap <silent> <Leader>bff :<C-u>Buffers<CR>
nnoremap <silent> <Leader>fff :<C-u>Files<CR>
nnoremap <silent> <Leader>tff :<C-u>Tags<CR>

" vim-quickrun
nnoremap <silent> <Leader>x :<C-u>QuickRun<CR>


" --- 基本オプション ---
colorscheme tender
syntax on

" [Backspace] で既存の文字を削除できるように設定
"   start  - 既存の文字を削除できるように設定
"   eol    - 行頭で[Backspace]を使用した場合上の行と連結
"   indent - オートインデントモードでインデントを削除できるように設定
set backspace=start,eol,indent

set mouse=a      " マウス機能
set hidden       " 隠れバッファの許可
set undofile     " 永続的Undo機能
"set binary noeol " 行末に勝手に改行しない
set winminheight=0
set norelativenumber


" --- カーソル移動 ---
set scrolloff=8      " 上下8行の視界を確保
set sidescrolloff=16 " 左右スクロール時の視界を確保
set sidescroll=1     " 左右スクロールは1文字ずつ行う


" --- エンコーディング ---
set encoding=utf8     " Vimが内部で用いるエンコーディング
set termencoding=utf8 " 端末の出力に用いられるエンコーディング


" --- スペルチェック（コメントだけ） ---
"set spell                   " スペルチェックを有効にする
"set spelllang+=cjk          " 日本語を除外
"hi SpellBad cterm=underline " 間違いの表示をアンダーラインに
"hi clear SpellBad


" --- テンプレート ---
augroup template
    autocmd!
    autocmd BufNewFile *.vue execute '0r ' . s:config_dir . '/template/vue.txt'
augroup END


" --- ディレクトリ ---
execute 'set directory=' . s:config_dir . '/tmp'
execute 'set backupdir=' . s:config_dir . '/tmp'
execute 'set undodir='   . s:config_dir . '/undo'
execute 'set tags='      . s:config_dir . '/tags'


" --- セッション ---
set sessionoptions=curdir,folds,help,localoptions,tabpages,winpos,winsize

" セッションファイルがロードされていた場合、Vim終了時に現在のセッションで上書きする
" ロードされていてもいなくても、previous.vimとして保存する
function! StoreSession()
    if v:this_session != ''
        execute ':mksession! ' . v:this_session
    endif
    execute ':mksession! ' . s:config_dir . '/sessions/previous.session.vim'
endfunction

augroup session
    autocmd!
    autocmd VimLeave * call StoreSession()
augroup END


" --- 見た目 ---
set showmatch       " 対応する括弧を強調表示
set nocursorline    " カーソルラインの強調表示
set number          " 行番号の表示
set colorcolumn=100 " 縦のライン表示
set showcmd         " 入力中のコマンドを表示

augroup appearance
    autocmd!
augroup END


" --- 不可視文字 ---
set list
set listchars=tab:>-,trail:-,eol:↲


" --- 検索 / 置換 ---
set hlsearch   " 検索キーワードをハイライト
set incsearch  " インクリメンタル検索を有効化
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 小文字のときのみ区別しない
set gdefault   " 置換の時 g オプションをデフォルトで有効にする


" --- タブ ---
" タブページのラベルの表示方法
" 0: 表示しない
" 1: 2個以上タブがあるときに表示
" 2: 常に表示
set showtabline=1


" --- ウィンドウ ---
set splitbelow   " 新しいウィンドウを下に開く
set splitright   " 新しいウィンドウを右に開く

" ウィンドウの最小幅
execute 'set winwidth=' . s:win_width_min

" ウィンドウの最小の高さ
execute 'set winheight=' . s:win_height_min


" --- ステータスライン ---
set laststatus=2 " ステータスラインを常に表示

function! InitStatusLine()
    " %< 切り詰め開始位置
    " %f カレントディレクトリからの相対パス
    " %m 編集したら"[+]"を表示
    " %r 読み込み専用なら"[RO]"を表示
    " %h ヘルプページなら"[HELP]"を表示
    " %w プレビューページなら"[Preview]"を表示
    " %= これ以降は右寄せで表示
    set statusline=%<%f%m%r%h%w%=
endfunction

function! SwitchStatusLineCurrent()
    call InitStatusLine()

    " 現在のセッション
    if v:this_session != ''
        " 拡張子を2段階で削除
        setlocal statusline+=[%(%{fnamemodify(fnamemodify(v:this_session,':t:r'),':r')}%)]
    endif

    " ファイルタイプ
    if &filetype != ''
        setlocal statusline+=[%{&filetype}]
    endif

    "setlocal statusline+=[%{&fileencoding}] " ファイルのエンコーディング
    setlocal statusline+=[%l/%L,%c] " 現在行/全行数,現在列
endfunction

augroup statusLine
    autocmd!
    autocmd * call SwitchStatusLineCurrent()
    autocmd WinEnter,BufEnter,SessionLoadPost * call SwitchStatusLineCurrent()
    autocmd WinLeave * call InitStatusLine()
augroup END

call SwitchStatusLineCurrent()


" --- 補完機能 ---
set nowildmenu            " 候補をビジュアル的に表示しない
set wildmode=list:longest " 補完時の一覧表示機能有効化

augroup complement
    autocmd!
"    autocmd BufRead *.js setlocal dictionary=$HOME.'/.vim/dict/javascript.dict'
"    autocmd BufRead *.php setlocal dictionary=$HOME.'/.vim/dict/php.dict'
augroup END


" --- インデント ---
set tabstop=4     " タブ文字の幅
set softtabstop=4 " 削除する空白の数
set shiftwidth=4  " >>で移動するタブ幅
set autoindent    " 自動インデント
set smartindent   " C言語スタイルのブロックを自動挿入
set expandtab     " タブ文字を空白に展開

filetype plugin indent on

augroup indent
    autocmd!
    autocmd FileType css        setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType html       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType ruby       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType sass       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType scss       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType vue        setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END


" --- Linting ---
set errorformat=%m\ in\ %f:\ line\ %l " エラー表示のフォーマットを設定

augroup linting
    autocmd!
    autocmd BufRead *.php setlocal makeprg=php\ -l\ %

    " エラーがあればQuickFixに表示
    autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif
augroup END


" --- ユーザー定義コマンド ---
" :Bt <N>...でバッファ番号からバックグラウンドにタブを開く
command! -nargs=+ Bt call BufsToTabs(<f-args>)
function! BufsToTabs(...)
    let l:c_tab = tabpagenr()
    for l:e in a:000
        if !buflisted(str2nr(l:e))
            echoerr "No such buffers number: " . l:e
        else
            let l:name = bufname(str2nr(l:e))
            execute 'tabedit ' . l:name 
        endif
    endfor
    execute l:c_tab . ' tabnext'
endfunction
