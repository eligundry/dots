"===============================================================================
" File: ferret.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings Ferret
" Plugin URL: https://github.com/wincent/ferret
"===============================================================================

function! FerretSettings()
	let g:FerretDispatch = 1
	nnoremap <leader>a <Plug>(FerretAck)
	nnoremap <leader>z <Plug>(FerretAcks)
endfunction

autocmd VimEnter * if exists(":Ack") | call FerretSettings() | endif
