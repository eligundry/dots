"===============================================================================
" File: neosnippet.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for neosnippet
"===============================================================================

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-backbone/snippets'

" For snippet_complete marker.
if has('conceal')
	set conceallevel=2
	set concealcursor=i
endif
