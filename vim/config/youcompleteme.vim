"===============================================================================
" File: youcompletement.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for YouCompleteMe
"===============================================================================

" Name: YouCompleteMe
" Author: Val Markovic
" URL: https://github.com/Valloric/YouCompleteMe

let g:ycm_key_invoke_completion = '<C-n>'
let g:ycm_cache_omnifunc = 1
let g:ycm_use_ultisnips_completer = 1
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_filetype_blacklist = {
	\ 'tagbar' : 1,
	\ 'qf' : 1,
	\ 'notes' : 1,
	\ 'unite' : 1,
	\ 'text' : 1,
	\ 'vimwiki' : 1,
	\ 'pandoc' : 1
	\}
