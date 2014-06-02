"===============================================================================
" File: nerdtree.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for NERDTree
"===============================================================================

" Name: NERDTree
" Author: Martin Grenfell
" URL: https://github.com/scrooloose/nerdtree
let g:NERDChristmasTree = 1
let g:NERDTreeCasadeOpenSingleChildDir = 1
let g:NERDTreeChDirMode = 1
let g:NERDTreeDirArrows = 0
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeIgnore = ['\.swp$', '\~$', '\.pyc']
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowFiles = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeWinSize = 22

function! NERDTreeSettings()
	nnoremap <silent> <Leader>nt :UndotreeHide<CR>:NERDTreeToggle<CR>
	autocmd FileType nerdtree setlocal colorcolumn=""
endfunction

autocmd VimEnter * if exists(":NERDTree") | call NERDTreeSettings() | endif
