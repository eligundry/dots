"===============================================================================
" File: delimitmate.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for delimitmate.vim
"===============================================================================

" Name: delimitMate
" Author: Israel Chauca Fuentes
" URL: https://github.com/Raimondi/delimitMate
let delimitMateAutoClose = 1
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_smart_quotes = 1
autocmd FileType vim,html,xml,xhtml let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
