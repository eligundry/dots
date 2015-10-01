"===============================================================================
" File: spelling.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for spelling and language
"===============================================================================

if has("spell")
	set spell
	set spelllang=en_us
endif

if has("rightleft")
	set norevins
	set noallowrevins
	set norightleft
endif

if has("farsi")
	set noaltkeymap
endif
