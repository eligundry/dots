"===============================================================================
" File: terminal.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings exclusive to the terminal
"===============================================================================

" Must use this conditional or else GVim won't open
if !has("gui")
	set shell=$SHELL
	set term=$TERM
	set lazyredraw " Makes macros work smoother by not redrawing screen
	set ttyfast " I usually work locally, so my connection is fast
endif
