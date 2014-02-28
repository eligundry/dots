"===============================================================================
" File: font.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for my favorite fonts
"===============================================================================

if has("gui_win32")
	set guifont=Consolas:h11
elseif has("gui_gtk2")
	set guifont=Pragmata\ Pro\ 10
elseif has("gui_mac")
	set guifont=Monaco 10
endif
