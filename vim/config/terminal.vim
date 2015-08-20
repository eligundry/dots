"===============================================================================
" File: terminal.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings exclusive to the terminal
"===============================================================================

" Must use this conditional or else GVim won't open
if !has("gui")
	set shell=$SHELL

	if !has('nvim')
		set term=$TERM
	endif

	set lazyredraw " Makes macros work smoother by not redrawing screen
	set ttyfast " I usually work locally, so my connection is fast
endif
