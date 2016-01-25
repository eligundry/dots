"===============================================================================
" File: wildmenu.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for how wildmenu works
"===============================================================================

if has("wildmenu")
	set wildmenu " Really helpful tab command completion
	set wildmode=longest,full
endif

if has("wildmenu") && v:version >= 703
	set wildignorecase
endif

" I have these wildignores commented out because they prevent NERDTree from
" showing these files and will break Fugitive. Uncomment these if you want to
" make Vim's autocomplete more relevant.
if has("wildignore")
	" set wildignore+=.git,.svn,.hg " Version control files
	" set wildignore+=*.jpg,*.jpeg,*.png,*.psd,*.ai,*.bmp,*.gif " Images
	set wildignore+=*.psd,*.ai " Images
	set wildignore+=*.o,*.obj,*.bak,*.exe
	set wildignore+=*.mp4,*.ogg,*.m4v,*.ogv,*.mp3 " Mulitmedia files
	set wildignore+=*.pyc,*.pyo " Python bullshit
	set wildignore+=.DS_Store " OSX bullshit
	set wildignore+=*.hist
endif
