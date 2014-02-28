"===============================================================================
" File: ruby.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Detect nginx files
"===============================================================================

autocmd BufRead,BufNewFile /etc/nginx/* setfiletype nginx
