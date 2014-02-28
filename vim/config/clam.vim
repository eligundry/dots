"===============================================================================
" File: clam.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for Clam
"===============================================================================

" Name: Clam.vim
" Author: Steve Losh
" URL: https://github.com/sjl/clam.vim
function! ClamSettings()
	nnoremap ! :Clam<Space>
	vnoremap ! :ClamVisual<Space>
endfunction

autocmd VimEnter * if exists("loaded_clam") | call ClamSettings() | endif
