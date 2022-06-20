let s:default = {}

function! config#get(name) abort
    return get(g:, 'env_' . a:name, s:default[a:name]())
endfunction

function! s:default.project_root_dir() abort
    return expand('%:h')
endfunction

function! s:default.test_command_phpunit() abort
    return './vendor/bin/phpunit'
endfunction
