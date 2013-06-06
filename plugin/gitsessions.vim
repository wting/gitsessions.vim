" gitsessions.vim - auto save/load vim sessions based on git branches
" Maintainer:       William Ting <io at williamting.com>
" Site:             https://github.com/wting/gitsessions.vim

if exists('g:loaded_gitsessions') || v:version < 700 || &cp
    finish
endif
let g:loaded_gitsessions = 1

function! g:rtrim_slashes(string)
    return substitute(a:string, '[/\\]$', '', '')
endfunction

if !exists('g:gitsessions_dir')
    let g:gitsessions_dir = 'sessions'
else
    let g:gitsessions_dir = g:rtrim_slashes(g:gitsessions_dir)
endif

if !exists('s:session_exist')
    let s:session_exist = 0
endif

if !exists('s:start_dir')
    let s:start_dir = getcwd()
endif

if !exists('g:VIMFILESDIR')
    let g:VIMFILESDIR = has('unix') ? $HOME . '/.vim/' : $VIM . '/vimfiles/'
endif

function! s:replace_bad_ch(string)
    return substitute(a:string, '/', '_', '')
endfunction

function! s:trim(string)
    return substitute(substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', ''), '\n', '', '')
endfunction

function! s:gitbranchname()
    return s:replace_bad_ch(s:trim(system("\git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //'")))
endfunction

function! s:in_git_repo()
    return empty(s:trim(system("\git status >/dev/null")))
endfunction

function! s:os_sep()
    return has('unix') ? '/' : '\'
endfunction

function! s:is_abs_path(path)
    return a:path[0] == s:os_sep()
endfunction

function! s:parent_dir(path)
    let l:sep = s:os_sep()
    let l:front = s:is_abs_path(a:path) ? l:sep : ''
    return l:front . join(split(a:path, l:sep)[:-2], l:sep)
endfunction

function! s:find_git_dir(dir)
    if !s:in_git_repo()
        echoerr "not in git repo"
        return
    endif

    if isdirectory(a:dir . '/.git')
        return a:dir . '/.git'
    elseif has('file_in_path') && has('path_extra')
        return finddir('.git', a:dir . ';')
    elseif
        return s:find_git_dir_aux(a:dir)
    endif
endfunction

function! s:find_git_dir_aux(dir)
    return isdirectory(a:dir . '/.git') ? a:dir . '/.git' : s:find_git_dir_aux(s:parent_dir(a:dir))
endfunction

function! s:find_proj_dir(dir)
    return s:parent_dir(s:find_git_dir(a:dir))
endfunction

function! s:session_path(sdir, pdir)
    let l:path = a:sdir . a:pdir
    return s:is_abs_path(a:sdir) ? l:path : g:VIMFILESDIR . l:path
endfunction

function! s:sessiondir()
    if s:in_git_repo()
        return s:session_path(g:gitsessions_dir, s:find_proj_dir(s:start_dir))
    else
        return s:session_path(g:gitsessions_dir, s:start_dir)
    endif
endfunction

function! s:sessionfile()
    let l:dir = s:sessiondir()
    let l:branch = s:gitbranchname()
    return (empty(l:branch)) ? l:dir . '/master' : l:dir . '/' . l:branch
endfunction

function! g:SaveSession()
    let l:dir = s:sessiondir()
    let l:file = s:sessionfile()

    if !isdirectory(l:dir)
        call mkdir(l:dir, 'p')

        if !isdirectory(l:dir)
            echoerr "cannot create directory:" l:dir
            return
        endif
    endif

    if isdirectory(l:dir) && (filewritable(l:dir) != 2)
        echoerr "cannot write to:" l:dir
        return
    endif

    let s:session_exist = 1
    if filereadable(l:file)
        execute 'mksession!' l:file
        echom "session updated:" l:file
    else
        execute 'mksession!' l:file
        echom "session saved:" l:file
    endif
    redrawstatus!
endfunction

function! g:UpdateSession()
    let l:file = s:sessionfile()
    if s:session_exist && filereadable(l:file)
        execute 'mksession!' l:file
        echom "session updated:" l:file
    endif
endfunction

function! g:LoadSession(...)
    if argc() != 0
        return
    endif

    let l:show_msg = a:0 > 0 ? a:1 : 0
    let l:file = s:sessionfile()

    if filereadable(l:file)
        let s:session_exist = 1
        execute 'source' l:file
        echom "session loaded:" l:file
    elseif l:show_msg
        echom "session not found:" l:file
    endif
    redrawstatus!
endfunction

function! g:DeleteSession()
    let l:file = s:sessionfile()
    let s:session_exist = 0
    if filereadable(l:file)
        call delete(l:file)
        echom "session deleted:" l:file
    endif
endfunction

augroup gitsessions
    autocmd!
    autocmd VimEnter * nested :call g:LoadSession()
    autocmd VimLeave * :call g:UpdateSession()
augroup END

command SaveSession call g:SaveSession()
command LoadSession call g:LoadSession(1)
command DeleteSession call g:DeleteSession()

silent! nnoremap <unique> <silent> <leader>ss :call g:SaveSession()<cr>
silent! nnoremap <unique> <silent> <leader>ls :call g:LoadSession(1)<cr>
silent! nnoremap <unique> <silent> <leader>ds :call g:DeleteSession()<cr>

