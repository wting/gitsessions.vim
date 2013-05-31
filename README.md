# gitsessions

## Description

Automatically saves and loads sessions based on the root directory of the git
repository and the git branch name *after* the first manual save.

If the current directory is not a subdirectory of a git repository, then the
session is saved based on the path.

## Usage

`cd` to the directory and work as normal. Save the session at least once per
directory and git branch. Once a session has been saved, they will be updated
automatically when exiting Vim.

In the future, run Vim in the same directory and git branch and previous
settings will be restored.

### Commands

- `<leader>ss` save session
- `<leader>ls` load session
- `<leader>ds` delete session
- `:SaveSession` save session
- `:LoadSession` load session
- `:DeleteSession` delete session

## Options

Default session directory is `~/.vim/sessions` and can be modified in `~/.vimrc`:

    let g:gitsessions_dir = 'sessions'

## Installation

### Using [Vundle][v]

1. Add `Bundle 'wting/gitsessions.vim'` to `~/.vimrc`
2. `vim +BundleInstall +qall`

### Using [Pathogen][p]

1. `cd ~/.vim/bundle`
2. `git clone git://github.com/wting/gitsessions.vim.git`

## Misc

- `/` in feature names are replaced with `_`. As a result, it is possible to
clobber sessions if one branch is named `foo/123` and another `foo_123`.

## Acknowledgement

This plugin is based on Vim Wikia's [Go Away And Come Back][vw] entry.

## License

Released under MIT License, full details in `LICENSE` file.

[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
[vqs]: https://github.com/gmarik/vundle#quick-start
[vw]: http://vim.wikia.com/wiki/Go_away_and_come_back
