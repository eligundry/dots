"===============================================================================
" File: neocomplete.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for neocomplete
"===============================================================================

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1

if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.java = '\k\.\k*'
