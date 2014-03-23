# gitsessions.vim

## Description

gitsessions.vim improves on vim's [`:mksession`][mks] command (saving open
windows, tabs, splits, marks, etc) by eliminating most of the unnecessary work:

- automatically save, load, and update sessions
- automatically determine a session save location

## Usage

Once the user has saved the initial session via `:GitSessionSave`, session
management is automatically handled. Opening vim without a file in the project
folder will automatically resume a session, and sessions are automatically saved
upon exit and entering a buffer (in case vim crashes).

A project directory saved based on the location of the git repository and branch
name. If you're not in a git repository then it's based on the current working
directory.

To load a session, run vim in the same git repository and branch (or path for
non-git projects) and previous sessions should automatically be reloaded.

### Commands

- `:GitSessionSave` save session
- `:GitSessionLoad` load session
- `:GitSessionDelete` delete session

### Example Keybindings

    nnoremap <leader>gss :GitSessionSave<cr>
    nnoremap <leader>gsl :GitSessionLoad<cr>
    nnoremap <leader>gsd :GitSessionDelete<cr>

### Options

Default session directory is `~/.vim/sessions` and can be modified in `.vimrc`:

    let g:gitsessions_dir = 'relative/path/in/.vim/'

Or

    let g:gitsessions_dir = '/absolute/path/'

### Misc

*plugin updates*

Vim sessions save plugin state and keybindings. If you update a plugin and load
a session, vim might complain about not being able to find old plugin functions
that were changed / removed. Either ignore the errors or start a new session
from scratch that does not have old plugin state.

*git branch names*

`/` in git branch names are replaced with `_`. As a result, it is possible to
clobber sessions if one branch is named `foo/123` and another `foo_123` in the
same repository.

## Installation

### Using [Vundle][v]

1. Add `Bundle 'wting/gitsessions.vim'` to `~/.vimrc`
2. `vim +BundleInstall +qall`

### Using [Pathogen][p]

1. `cd ~/.vim/bundle`
2. `git clone git://github.com/wting/gitsessions.vim.git`

## Acknowledgement

This plugin is based on Vim Wikia's [Go Away And Come Back][vw] entry.

## License

Released under MIT License, full details in `LICENSE` file.

[mks]: http://vimdoc.sourceforge.net/htmldoc/starting.html#:mksession
[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
[vqs]: https://github.com/gmarik/vundle#quick-start
[vw]: http://vim.wikia.com/wiki/Go_away_and_come_back
