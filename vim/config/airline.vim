"===============================================================================
" File: airline.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for airline
"===============================================================================

let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#eclim#enabled = 1

" CSV Stuff
let g:airline#extensions#csv#enabled = 1

" Version Contols Stuff
let g:airline#extensions#hunks#enabled = 1

" Fancy Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

" Fancy Powerline symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
