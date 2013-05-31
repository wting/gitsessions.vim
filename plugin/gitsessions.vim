" gitsessions.vim - auto save/load vim sessions based on git branches
" Maintainer:       William Ting <io at williamting.com>
" Site:             https://github.com/wting/gitsessions.vim

if exists('g:loaded_gitsessions') || &cp
    finish
endif
let g:loaded_gitsessions = 1

if !exists('g:gitsessions_dir')
    let g:gitsessions_dir = 'sessions'
endif

if !exists('s:session_exist')
    let s:session_exist = 0
endif

if !exists('g:VIMFILESDIR')
    if (has('unix'))
        let g:VIMFILESDIR = $HOME . '/.vim/'
    elseif (has('win32'))
        let g:VIMFILESDIR = $VIM . '/vimfiles/'
    endif
endif

function! s:replace_bad_ch(string)
    return substitute(a:string, '/', '_', '')
endfunction

function! s:trim(string)
    return substitute(substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', ''), '\n', '', '')
endfunction

function! s:gitbranchname()
    return s:replace_bad_ch(s:trim(system("git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //'")))
endfunction

function! s:sessiondir(...)
    let l:dir = g:VIMFILESDIR . g:gitsessions_dir . getcwd()
    let l:create_dir = a:0 > 0 ? a:1 : 0

    if (l:create_dir && (filewritable(l:dir) != 2))
        call mkdir(l:dir, 'p')
        echom "created directory:" l:dir
        redraw!
    endif

    return l:dir
endfunction

function! s:sessionfile()
    let l:branch = s:gitbranchname()
    if (empty(l:branch))
        return s:sessiondir() . '/master'
    endif
    return s:sessiondir() . '/' . l:branch
endfunction

function! g:SaveSession()
    let l:dir = s:sessiondir(1)
    let l:file = s:sessionfile()
    let s:session_exist = 1
    execute 'mksession!' l:file
    echom "session created:" l:file
endfunction

function! g:UpdateSession()
    let l:file = s:sessionfile()
    if (s:session_exist && filereadable(l:file))
        execute 'mksession!' l:file
        echom "session updated:" l:file
    endif
endfunction

function! g:LoadSession(...)
    if (argc() != 0)
        return
    endif

    let l:show_msg = a:0 > 0 ? a:1 : 0
    let l:file = s:sessionfile()

    if (filereadable(l:file))
        let s:session_exist = 1
        execute 'source' l:file
        echom "session loaded:" l:file
    elseif (l:show_msg)
        echom "session not found:" l:file
    endif
endfunction

function! g:DeleteSession()
    let l:file = s:sessionfile()
    if (filereadable(l:file))
        echom "session deleted:" l:file
        call delete(l:file)
    endif
endfunction

augroup gitsessions
    autocmd!
    autocmd VimEnter * nested :call g:LoadSession()
    autocmd VimLeave * :call g:UpdateSession()
augroup END

silent! nnoremap <unique> <silent> <leader>ss :call g:SaveSession()<cr>
silent! nnoremap <unique> <silent> <leader>ls :call g:LoadSession(1)<cr>
silent! nnoremap <unique> <silent> <leader>ds :call g:DeleteSession()<cr>

command SaveSession call g:SaveSession()
command LoadSession call g:LoadSession(1)
command DeleteSession call g:DeleteSession()
