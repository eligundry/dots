"===============================================================================
" File: functions.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Custom Vim functions I wrote
"===============================================================================

" Toggle relative line numbering
function! ToggleRelativeNumber()
	if &relativenumber
		set number
	elseif !&number
		set relativenumber
	else
		set nonumber norelativenumber
	endif
endfunction

" Toggle virtualedit settings
function! ToggleVirtualEdit()
	if &virtualedit == "all"
		set virtualedit=onemore
	else
		set virtualedit=all
	endif
endfunction

" Toggle mouse modes
function! ToggleMouse()
	if &mouse == "a"
		set mouse=
	else
		set mouse=a
	endif
endfunction

" Toggle arrow keys for weaklings trying to use my vim
let g:ArrowKeysEnabled = 0
function! ToggleArrowKeys()
	let g:ArrowKeysEnabled = !g:ArrowKeysEnabled

	if g:ArrowKeysEnabled == 1
		nnoremap <silent> <Up> k
		nnoremap <silent> <Down> j
		nnoremap <silent> <Left> h
		nnoremap <silent> <Right> l
		inoremap <Left> <Nop>
		inoremap <Right> <Nop>
		inoremap <Up> <Nop>
		inoremap <Down> <Nop>
		echo "Arrow Keys enabled"
	else
		nnoremap <silent> <Up> :resize +5<cr>
		nnoremap <silent> <Down> :resize -5<cr>
		nnoremap <silent> <Left> :vertical resize -5<cr>
		nnoremap <silent> <Right> :vertical resize +5<cr>
		inoremap <Left> <Nop>
		inoremap <Right> <Nop>
		inoremap <Up> <Nop>
		inoremap <Down> <Nop>
		echo "Arrow Keys disabled"
	endif
endfunction

" Return to current line when reopening file
augroup line_return
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\     execute 'normal! g`"zvzz' |
		\ endif
augroup END

" Remove trailing whitespace when saving files
autocmd BufWritePre * :%s/\s\+$//e

" Exit paste mode upon leaving insert
autocmd InsertLeave * set nopaste paste?

" Use SudoWrite on read only files
autocmd FileChangedRO * nnoremap <buffer> <Leader>s :SudoWrite<CR>

" Resize splits as vim is resized
autocmd! VimResized * exe "normal! \<C-w>="

" Source vim files on save
autocmd! BufWritePost *vimrc source %
