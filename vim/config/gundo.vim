"===============================================================================
" File: gundo.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for gundo
"===============================================================================

" Name: gundo.vim
" Author: Steve Losh
" URL: https://github.com/sjl/gundo.vim
let g:gundo_help = 0
let g:gundo_preview_height = 20
let g:gundo_width = 60

function! GundoSettings()
	nnoremap <silent> <Leader>gu :NERDTreeClose<CR>:GundoToggle<CR>
	autocmd FileType gundo setlocal colorcolumn=""
endfunction

autocmd VimEnter * if exists(":Gundo") | call GundoSettings() | endif
