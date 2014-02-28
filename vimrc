"===============================================================================
" File: vimrc
" Author: Eli Gundry <eligundry@gmail.com>
" Description: A collection of all my Vim settings
"===============================================================================

"===============================================================================
" => Legacy Settings
"===============================================================================

" ...or more accurately, I don't give a shit about Vi. This is Vim!
set nocompatible

"===============================================================================
" => Vundle
"===============================================================================

set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#rc()

Bundle 'gmarik/Vundle.vim'
Bundle 'gregsexton/MatchTag'
Bundle 'vim-scripts/c.vim'
Bundle 'sjl/clam.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-fugitive'
Bundle 'sjl/gundo.vim'
Bundle 'othree/html5.vim'
Bundle 'nono/jquery.vim'
Bundle 'vim-scripts/matchit.zip'
Bundle 'scrooloose/nerdtree'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'tpope/vim-repeat'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'
Bundle 'tomtom/tcomment_vim'
Bundle 'zaiste/tmux.vim'
Bundle 'edkolev/tmuxline.vim'
Bundle 'bling/vim-airline'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'tpope/vim-eunuch'
Bundle 'airblade/vim-gitgutter'
Bundle 'digitaltoad/vim-jade'
Bundle 'groenewege/vim-less'
Bundle 'tpope/vim-markdown'
Bundle 'tristen/vim-sparkup'
Bundle 'tpope/vim-tbone'
Bundle 'bronson/vim-visual-star-search'
Bundle 'Valloric/YouCompleteMe'
Bundle 'SirVer/ultisnips'
Bundle 'jmcantrell/vim-virtualenv'

"===============================================================================
" => Config Loading
"===============================================================================

runtime! config/**/*.vim
