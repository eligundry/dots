"===============================================================================
" File: javascript.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: JavaScript specific vim settings
"===============================================================================

"===============================================================================
" => Omnifunctions
"===============================================================================

setlocal syntax=jquery
setlocal omnifunc=javascriptcomplete#CompleteJS

" Load libraries for completion
autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 1
autocmd BufReadPre *.js let b:javascript_lib_use_backbone = 1
autocmd BufReadPre *.js let b:javascript_lib_use_require = 1
autocmd BufReadPre *.js let b:javascript_lib_use_prelude = 0
autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 0
autocmd BufReadPre *.js let b:javascript_lib_use_angularui= 0
autocmd BufReadPre *.js let b:javascript_lib_use_sugar = 0
autocmd BufReadPre *.js let b:javascript_lib_use_jasmine = 0
