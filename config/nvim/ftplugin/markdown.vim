"===============================================================================
" File: markdown.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Markdown specific vim settings
"===============================================================================

"===============================================================================
" => Omnifunc
"===============================================================================

set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

"===============================================================================
" => Omnifunc
"===============================================================================

" Disabling this as it makes inline code completion impossible
" setlocal omnifunc=htmlcomplete#CompleteTags

"===============================================================================
" => Fenced Code Blocks
"===============================================================================

let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript',
	\ 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html', 'php',
	\ 'python', 'less', 'vim', 'sh', 'shell=sh', 'bash=sh']
