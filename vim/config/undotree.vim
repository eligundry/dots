"===============================================================================
" File: undotree.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for undotree
"===============================================================================

function! UndotreeSettings()
	nnoremap <silent> <Leader>ut :NERDTreeClose<CR>:UndotreeShow<CR>:UndotreeFocus<CR>
endfunction

autocmd VimEnter * if exists(":UndotreeShow") | call UndotreeSettings() | endif
