"===============================================================================
" File: solarized.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Solarized settings
"===============================================================================

" Name: Solarized
" Author: Ethan Schoonover
" URL: https://github.com/altercation/vim-colors-solarized
let g:solarized_bold = 1
let g:solarized_italic = 1
let g:solarized_menu = 0
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
let g:solarized_visibility = "low"
colorscheme solarized
call togglebg#map("<Leader>bg")
