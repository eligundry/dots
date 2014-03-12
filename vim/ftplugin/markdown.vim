"===============================================================================
" File: markdown.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Markdown specific vim settings
"===============================================================================

"===============================================================================
" => Spelling
"===============================================================================

autocmd BufNew,BufEnter setlocal spell
setlocal omnifunc=htmlcomplete#CompleteTags
