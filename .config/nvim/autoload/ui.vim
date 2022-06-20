function! ui#statusline() abort
    let s = '#%{winnr()} %<%f%m%r%h%w  %=[%{&fileencoding}][%{&filetype}][%l/%L,%c]'
    return s
endfunction

function! ui#tabline() abort
    let s = ' '

    for i in range(tabpagenr('$'))
        let s .= '%' . (i + 1) . 'T' " タブページ番号の設定 (マウスクリック用)
        let s .= ui#tablabel(i + 1) . '  '
    endfor

    " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセットする
    let s .= '%#TabLineFill#%T'

    " セッションを表示
    if (v:this_session == '')
        let session = 'No session'
    else
        let session = substitute(fnamemodify(v:this_session, ':t'), '\v\.vim', '', '')
    endif
    let s .= '%=%#ColorColumn#' . '[' . session . ']'

    return s
endfunction

function! ui#tablabel(n) abort
    let s = ''

    let s .= '%#Title#'

    " タブページ内のウィンドウの個数を表示
    let win_count = tabpagewinnr(a:n, '$')
    if win_count > 1
        let s .= win_count
    endif

    let s .= a:n == tabpagenr()
                \ ? '%#TabLineSel#'
                \ : '%#TabLine#'

    if win_count > 1
        let s .= ' '
    endif

    let buflist = tabpagebuflist(a:n)

    " カレントウィンドウのバッファ名を表示
    let bn = bufname(buflist[tabpagewinnr(a:n) - 1])
    if bn == ''
        let s .= '[New]'
    elseif getbufvar(bn, '&buftype') == 'help'
        let s .= '[Help] ' . fnamemodify(bufname(bn), ':t:s/.txt$//')
    elseif getbufvar(bn, '&buftype') == 'quickfix'
        let s .= '[Quickfix]'
    else
        " let s .= fnamemodify(bn, ':~:.') " 相対パス
        let s .= fnamemodify(bn, ':t') " ファイル名のみ
    endif

    " 変更のあるバッファの数を表示
    let modified = 0
    for b in uniq(sort(buflist))
        if getbufvar(b, "&modified")
            let modified += 1
        endif
    endfor
    if modified > 0
        let s .= ' [' . modified . '+]'
    endif

    return s
endfunction
