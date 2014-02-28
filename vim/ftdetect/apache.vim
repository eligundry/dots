"===============================================================================
" File: apache.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Detect Apache config files
"===============================================================================

autocmd BufRead,BufNewFile /etc/apache2/sites-*/* setfiletype apache
