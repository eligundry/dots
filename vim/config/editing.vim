"===============================================================================
" File: editing.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for editing files
"===============================================================================

" Stay in the same column when jumping around
set nostartofline

" Backspace all the things!
set backspace=indent,eol,start

" I don't want other people's files messing up my settings
set nomodeline
set modelines=0

" Don't use more than one space after punctuation
set nojoinspaces

if has("folding")
	set nofoldenable " I hate folds...
	set foldmethod=manual " ...but if there are folds, let me control them
endif

" I don't need Vim telling me where I can't go!
if has("virtualedit")
	set virtualedit=all
endif

" Change current directory to whatever file I'm editing
if exists("+autochdir")
	set autochdir
endif
