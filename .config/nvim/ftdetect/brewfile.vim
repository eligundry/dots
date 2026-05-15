"===============================================================================
" File: brewfile.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Detect Brewfiles as Ruby
"===============================================================================

autocmd BufRead,BufNewFile Brewfile.*,.Brewfile,.Brewfile.* setfiletype ruby
