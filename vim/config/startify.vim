"===============================================================================
" File: startify.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for startify
"===============================================================================

autocmd User Startified call AirlineRefresh
autocmd FileType startify setlocal buftype=
let g:startify_custom_header = map(split(system('fortune | cowsay -f hypnotoad'), '\n'), '"   ". v:val') + ['','']
let g:startify_skiplist = [
	\ 'COMMIT_EDITMSG',
	\ $VIMRUNTIME .'/doc',
	\ 'bundle/.*/doc',
	\ '\.DS_Store'
	\ ]
