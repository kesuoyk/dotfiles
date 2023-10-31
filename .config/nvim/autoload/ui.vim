function! ui#statusline() abort
    let fileencoding = empty(&fileencoding) ? '' : printf("[%s]", &fileencoding)
    let filetype = empty(&filetype) ? '' : printf("[%s]", &filetype)
    return [
        \ '#%{winnr()} %<%f%m%r%h%w  %=',
        \ fileencoding,
        \ filetype,
        \ '[%l/%L,%c]'
        \ ]->join('')
endfunction

function! ui#tabline() abort
    let s = ' '

    let last = tabpagenr('$')
    for i in range(last)
        let s .= ui#tablabel(i + 1, last)
    endfor

    " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセットする
    let s .= '%#TabLineFill#%T'

    " セッションを表示
    if (v:this_session == '')
        let session = 'No session'
    else
        let session = substitute(fnamemodify(v:this_session, ':t'), '\v\.vim', '', '')
    endif
    let s .= '%=%#Normal#' . '[' . session . ']'

    return s
endfunction

function! ui#tablabel(n, last) abort
    let s = ''

    " タブページ番号の設定 (マウスクリック用)
    let s .= '%' . a:n . 'T'

    " タブページ番号を表示
    " let s .= '%#TabLineSel#'
    let s .= a:n == tabpagenr() ? '%#TabLineSel#' : '%#Delimiter#'
    let s .= '#' . a:n . ' '

    let buflist = tabpagebuflist(a:n)

    " カレントウィンドウのバッファ名を表示
    let s .= a:n == tabpagenr()
                \ ? '%#TabLineSel#'
                \ : '%#TabLine#'
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

    " 区切りを追加
    let s .= '%#TabLineFill#'
    let s .= a:n == a:last ? '' : '  '

    return s
endfunction
