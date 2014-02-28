"===============================================================================
" File: file-handling.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for file handling
"===============================================================================

" Buffer is unloaded when abandoned
set hidden

" Reload if modified, write on certain commands
setglobal autoread
setglobal autowrite

" Set default line endings as Unix
setglobal fileformat=unix
set fileformats=unix,dos,mac

" I love UTF-8
if has("multi_byte")
	scriptencoding utf-8
	let &termencoding = &encoding
	setglobal encoding=utf-8
	setglobal fileencoding=utf-8
	setglobal nobomb
endif

" Disable encryption
if has("cryptv")
	setglobal key=
endif
