# gitsessions.vim

## Description

gitsessions.vim improves on vim's [`:mksession`][mks] command (saving open
windows, tabs, splits, marks, etc) by eliminating most of the unnecessary work:

- automatically load and update sessions
- automatically determine a session save location

## Usage

Once sessions have been initialized by running `:GitSessionSave`, session
management is automatically handled thereafter. Opening vim without a file in
the project folder will automatically resume a session, and sessions are
automatically saved upon exit and entering a buffer (in case vim crashes).

A project directory is based on the location of the git repository and branch
name. If you're not in a git repository then it's based on vim's current working
directory (determined by where vim was opened).

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

#### Change sessions save location

Default session directory is `~/.vim/sessions` and can be modified in `.vimrc`:

    let g:gitsessions_dir = 'relative/path/in/.vim/'

Or

    let g:gitsessions_dir = '/absolute/path/'

#### Toggle auto load session behavior

If you don't want the session to be loaded automatically when launching vim,
you can disable this behavior:

    let g:gitsessions_disable_auto_load = 1

You need to set this variable _before_ loading the plugin.

#### Toggle session caching behavior

By default the plugin caches the session file so it's not recalculated when
switching between buffers. However this means when switching between git
branches the user needs manually save to start saving against the new branch's
git session.

To disable this behavior and always save vim sessions against the current git
branch name please add the following toggle to .vimrc:

    let g:gitsessions_use_cache = 0

This does mean that the user has to actively purge the cache (by running
`GitSessionSave`) on all open vim programs using a repository if the underlying
git repo has changed branches. For example:

    # on terminal 1:
    $ cd ~/project && git checkout master
    $ vim
    <vim> :let g:gitsessions_use_cache = 1
    # save / load a gitsession, continue working

    # on terminal 2:
    $ cd ~/project && git checkout feature_branch

    # on terminal 1, vim is still running
    # If I exit vim now, it is still using the cached branch and will save to
    # the `master` session file instead of `feature_branch`.
    # Manually purge the cached session file:
    <vim> :GitSessionSave
    # If I exit vim now, it will save to the `feature_branch` session file.

\* [~550ms](https://github.com/wting/gitsessions.vim/pull/10) when working in
extremely large git repositories.

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
