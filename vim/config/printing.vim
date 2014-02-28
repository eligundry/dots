"===============================================================================
" File: printing.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for how hardcopy works
"===============================================================================

if has("printer")
	set printoptions=header:0,number:y,duplex:long
endif
