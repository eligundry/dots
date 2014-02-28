"===============================================================================
" File: tcomment.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for TComment
"===============================================================================

" Name: TComment
" Author: Thomas Link
" URL: https://github.com/tomtom/tcomment_vim
let g:tcommentBlankLines = 1

function! TCommentSettings()
	nnoremap <Leader>cc :TComment<CR>
	vnoremap <Leader>cb :TCommentBlock<CR>
endfunction

autocmd VimEnter * if exists(":TComment") | call TCommentSettings() | endif
