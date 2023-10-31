function! util#mkdir_if_not_exists(path) abort
    if !isdirectory(a:path)
        call mkdir(iconv(a:path, &encoding, &termencoding), 'p')
    endif

    return a:path
endfunction

function! util#file_path_full() abort
    return util#file_path('p')
endfunction

function! util#file_path_relative() abort
    return util#file_path('')
endfunction

function! util#file_path(suffix) abort
    return expand('%' . (a:suffix != ''  ? (':' . a:suffix) : ''))
endfunction

function! util#remove_tmp_files() abort
    call system("rm -rf ~/.local/share/nvim/swap/")
    echo 'Swap files cleaned up.'
endfunction

function! util#remove_undo_files() abort
    call system("rm -rf ~/.local/share/nvim/undo/")
    echo 'Undo files cleaned up.'
endfunction

function! util#copy_to_clipboard(str) abort
    let @* = a:str
endfunction

function! util#remove_trailing_spaces_on_current_buffer() abort
    %s/\v\s+$//
endfunction

function! util#remove_suffix_recursive(path) abort
    if fnamemodify(a:path, ':e') == ''
        return a:path
    endif

    return util#remove_suffix_recursive(fnamemodify(a:path, ':r'))
endfunction

command! CopyFilePathFullToClipBoard
            \ call util#copy_to_clipboard(util#file_path_full())

command! CopyFilePathRelativeToClipBoard
            \ call util#copy_to_clipboard(util#file_path_relative())

command! CleanUpTmpFiles
            \ call util#remove_tmp_files()

command! RemoveTrailingSpacesOnCurrentBuffer
            \ call util#remove_trailing_spaces_on_current_buffer()

command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis

function! util#open_config_file() abort
    execute 'edit '. g:nvim_config_file
endfunction

function! util#reload_config_file() abort
    execute 'source ' . g:nvim_config_file
    echo 'Config reloaded'
endfunction

function! util#toggle_paste_mode() abort
    if &paste == 1
        set nopaste
        echo 'Paste mode off'
    else
        set paste
        echo 'Paste mode on'
    endif
endfunction

function! util#toggle_wrap() abort
    if &wrap == 1
        set nowrap
        echo 'wrap off'
    else
        set wrap
        echo 'wrap on'
    endif
endfunction

function! util#unescape_utf8() abort
    execute '%s/\\u\([0-9a-f]\{4}\)/\=nr2char(eval("0x".submatch(1)),1)'
endfunction

function! util#clean_buffer() abort
endfunction
