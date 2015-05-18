"===============================================================================
" File: tagbar.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for tagbar
"===============================================================================

let g:tagbar_show_linenumbers = 0
let g:tagbar_iconchars = ['▷', '◢']

let g:tagbar_type_coffee = {
	\ 'ctagstype' : 'coffee',
	\ 'kinds'     : [
		\ 'c:classes',
		\ 'm:methods',
		\ 'f:functions',
		\ 'v:variables',
		\ 'f:fields',
	\ ]
\ }

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

let g:tagbar_type_make = {
	\ 'kinds':[
		\ 'm:macros',
		\ 't:targets'
	\ ]
\ }

let g:tagbar_type_markdown = {
	\ 'ctagstype' : 'markdown',
	\ 'kinds' : [
		\ 'h:Heading_L1',
		\ 'i:Heading_L2',
		\ 'k:Heading_L3'
	\ ]
\ }

function! TagBarSettings()
	nnoremap <silent> <Leader>tb :TagbarToggle<CR>
endfunction

autocmd VimEnter * if exists(":TagbarToggle") | call TagBarSettings() | endif
