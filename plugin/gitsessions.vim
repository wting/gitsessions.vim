" gitsessions.vim - Save / autoload vim sessions on git branches
" Maintainer:       William Ting <http://williamting.com>
" Version:          0.1

if exists('g:loaded_gitsessions') || &cp
    finish
endif
let g:loaded_gitsessions = 1

let g:gitsessions_dir = '/.vim/tmp/sessions'

function! s:trim(string)
    return substitute(substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', ''), '\n', '', '')
endfunction

function! s:gitbranchname()
    return trim((system("git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //'")))
endfunction

function! s:sessiondir()
    let l:dir = $HOME . g:gitsessions_dir . getcwd()
    if (filewritable(l:dir) != 2)
        exe 'silent !mkdir -p ' l:dir
        redraw!
    endif
    return l:dir
endfunction

function! s:sessionfile()
    let l:branch = GitBranchName()
    if (l:branch == '')
        return sessiondir() . '/session.vim'
    endif
    return sessiondir() . '/' . l:branch
endfunction

function! g:SaveSession()
    let l:file = sessionfile()
    exe "mksession! " . l:file
    echom "session created: " . l:file
endfunction

function! g:UpdateSession()
    let l:file = sessionfile()
    if (filereadable(l:file))
        exe "mksession! " . l:file
        echom "session updated: " . l:file
    endif
endfunction

function! g:LoadSession()
    let l:file = sessionfile()
    if (filereadable(l:file))
        echom "session loaded: " . l:file
        exe 'source ' l:file
    else
        echom "session not found: " . l:file
    endif
endfunction

au VimEnter * nested :call LoadSession()
au VimLeave * :call UpdateSession()

nnoremap <leader>ss :call SaveSession()<cr>
nnoremap <leader>ls :call LoadSession()<cr>
