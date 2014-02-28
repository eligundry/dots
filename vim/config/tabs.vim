"===============================================================================
" File: tabs.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for tab preferences
"===============================================================================

set tabstop=4 " I like my tabs to seem like four spaces
set shiftwidth=4 " I'd also like to shift lines the same amount of spaces
set softtabstop=4 " If using expandtab for some reason, use four spaces
set autoindent " Copy indenting from original block of text when yanked/pulled
set noexpandtab " Tabs are '\t', not four spaces
set smarttab " Make expandtab more tolerable
set shiftround " Round indents to multiples of shiftwidth
set copyindent

" Does a certain amount of guessing with indentation
if has("smartindent")
	set smartindent
endif
