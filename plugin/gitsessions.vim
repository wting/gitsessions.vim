" gitsessions.vim - auto save/load vim sessions based on git branches
" Maintainer:       William Ting <http://williamting.com>
" Version:          0.1

if exists('g:loaded_gitsessions') || &cp
    finish
endif
let g:loaded_gitsessions = 1

if !exists("g:gitsessions_dir")
    let g:gitsessions_dir = 'sessions'
endif

function! s:trim(string)
    return substitute(substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', ''), '\n', '', '')
endfunction

function! s:gitbranchname()
    return s:trim((system("git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //'")))
endfunction

function! s:sessiondir()
    let l:dir = $HOME . '/.vim/' . g:gitsessions_dir . getcwd()
    if (filewritable(l:dir) != 2)
        exe 'silent !mkdir -p ' l:dir
        redraw!
    endif
    return l:dir
endfunction

function! s:sessionfile()
    let l:branch = s:gitbranchname()
    if (l:branch == '')
        return s:sessiondir() . '/master'
    endif
    return s:sessiondir() . '/' . l:branch
endfunction

function! g:SaveSession()
    let l:file = s:sessionfile()
    exe "mksession! " . l:file
    echom "session created: " . l:file
endfunction

function! g:UpdateSession()
    let l:file = s:sessionfile()
    if (filereadable(l:file))
        exe "mksession! " . l:file
        echom "session updated: " . l:file
    endif
endfunction

function! g:LoadSession()
    if (argc() != 0)
        return
    endif

    let l:file = s:sessionfile()
    if (filereadable(l:file))
        echom "session loaded: " . l:file
        exe 'source ' l:file
    endif
endfunction

function! g:DeleteSession()
    let l:file = s:sessionfile()
    if (filereadable(l:file))
        echom "session deleted: " . l:file
        call delete(l:file)
    endif
endfunction

au VimEnter * nested :call g:LoadSession()
au VimLeave * :call g:UpdateSession()

silent! nnoremap <unique> <silent> <leader>ss :call g:SaveSession()<cr>
silent! nnoremap <unique> <silent> <leader>ls :call g:LoadSession()<cr>
silent! nnoremap <unique> <silent> <leader>ds :call g:DeleteSession()<cr>

command SaveSession call g:SaveSession()
command LoadSession call g:LoadSession()
command DeleteSession call g:DeleteSession()
