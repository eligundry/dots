"===============================================================================
" File: lektor.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Detect Lektor config files
"===============================================================================

autocmd BufRead,BufNewFile *.lr setfiletype markdown
autocmd BufRead,BufNewFile *.lektorproject setfiletype dosini
