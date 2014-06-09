"===============================================================================
" File: tbone.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for Tbone
"===============================================================================

" Name: vim-tbone
" Author: Tim Pope <http://tpo.pe/>
" URL: http://github.com/tpope/vim-tbone
function! TboneSettings()
	vnoremap <Leader>y :Tyank<CR>
	nnoremap <Leader>p :Tput<CR>
endfunction

autocmd VimEnter * if exists(":Tmux") | call TboneSettings() | endif
