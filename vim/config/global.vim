"===============================================================================
" File: global.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Global vim settings
"===============================================================================

if has("autocmd")
	filetype plugin indent on
endif

" I needs my syntax highlighting
if has("syntax")
	syntax enable
endif

" I don't use sessions currently, but I shall set this anyways.
if has("mksession")
	set sessionoptions=blank,buffers,curdir,folds,help,options,resize,slash,winpos,winsize
endif
