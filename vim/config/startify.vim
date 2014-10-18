"===============================================================================
" File: startify.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for startify
"===============================================================================

autocmd! User Startified call AirlineRefresh
let g:startify_custom_header = map(split(system('fortune | cowsay -f hypnotoad'), '\n'), '"   ". v:val') + ['','']
