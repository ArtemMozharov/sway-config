" Portable Vim defaults for the Fedora setup.
set nocompatible
set number
set ruler
set mouse=a
set hidden
set ignorecase
set smartcase
set incsearch
set hlsearch
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set backspace=indent,eol,start
syntax on
filetype plugin indent on

" Clear search highlighting with Escape.
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>
