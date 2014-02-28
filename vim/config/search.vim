"===============================================================================
" File: search.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for searching files
"===============================================================================

" Fancy (quick) search highlighting
if has("extra_search")
	set hlsearch
	set incsearch
endif

set ignorecase infercase " When I search, I don't need to capitalize...
set smartcase " ...but when I do, it'll pair down the search.
set shellslash " When in Windows, you can use / instead of \
set magic " Do You Believe In (Perl) Magic?
set gdefault " Use global by default when replacing
