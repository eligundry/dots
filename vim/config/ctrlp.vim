"===============================================================================
" File: ctrlp.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for ctrl-p
"===============================================================================

let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 10
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](node_modules|vendor)|\.(git|hg|svn|env|vagrant)$',
	\ 'file': '\v\.(exe|so|dll|pyo|pyc)$'
\ }
