# gitsessions - auto save/load sessions based on git branches

## Description

Automatically saves and loads sessions based on the current working directory
and git branch name *after* the first manual save.

If the directory is not a git repository, then the session saves it to a default
`master` file.

## Usage

`cd` to the project directory, open buffers/windows/splits and work as normal.
Save the session at least once if no session existed.

On subsequent runs, run Vim in the correct directory and git branch and the
previous settings will be automatically loaded.

Sessions are automatically saved when exiting Vim.

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

*Note:* Vundle will not automatically detect Rust files properly if `filetype
on` is executed before Vundle. Please check the [quickstart][vqs] for more
details.

### Using [Pathogen][p]

1. `cd ~/.vim/bundle`
2. `git clone git://github.com/wting/gitsessions.vim.git`

## Acknowledgement

This plugin is based on the comments in Vim Wikia's [Go Away And Come Back][vw]
entry.

## License

Released under MIT License, full details in `LICENSE` file.

[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
[vqs]: https://github.com/gmarik/vundle#quick-start
[vw]: http://vim.wikia.com/wiki/Go_away_and_come_back
