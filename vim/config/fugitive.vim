"===============================================================================
" File: fugitive.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for fugitive
"===============================================================================

" Name: Fugitive
" Author: Tim Pope
" URL: https://github.com/tpope/vim-fugitive
function! FugitiveSettings()
	nnoremap <silent> <Leader>gs :Gstatus<CR>
	nnoremap <silent> <Leader>gb :Gblame<CR>
	nnoremap <silent> <Leader>gd :Gdiff<CR>
	nnoremap <silent> <Leader>gp :Git push<CR>
	nnoremap <silent> <Leader>gl :Glog<CR>
	autocmd FileType gitcommit nnoremap <buffer> <Leader>s :wq<CR>
endfunction

autocmd VimEnter * if exists("g:loaded_fugitive") | call FugitiveSettings() | endif
