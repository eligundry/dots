"===============================================================================
" File: ruby.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Ruby specific vim settings
"===============================================================================

"===============================================================================
" => Tabs
"===============================================================================

setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

"===============================================================================
" => Omnifunctions
"===============================================================================

setlocal omnifunc=rubycomplete#Complete
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:loaded_rails = 1
let g:rubycomplete_rails = 1
let ruby_operators = 1
let ruby_space_errors = 1
let ruby_no_expensive = 0
