"===============================================================================
" File: history.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for backups and history
"===============================================================================

set history=700

" I hate backups. There's no point anymore!
set nobackup
set nowritebackup
set backupdir=~/.vim/backup

" I'm done using swaps. They are annoying.
set noswapfile
set directory=~/.vim/swap

" Persistent undo is pretty awesome. It basically builds all sorts
" of version control straight into your editor. It commits when ever
" you leave insert/replace/change/etc. to normal. Gundo allows you to
" see all of your edits in diff style so you can revert back to certain
" parts in time.
if has("persistent_undo")
	set undofile
	set undolevels=3000
	set undodir=~/.vim/undo
else
	" If persistent undo isn't available, let's enable backups.
	set backup
	set writebackup
	set swapfile
endif
