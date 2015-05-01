"===============================================================================
" File: syntastic.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for Syntastic
"===============================================================================

" Name: Syntastic
" Author: Martin Grenfell
" URL: https://github.com/scrooloose/syntastic
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_enable_balloons = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_mode_map = { 'mode': 'active',
						   \ 'active_filetypes': ['html', 'xml', 'c', 'cpp', 'php', 'css', 'ruby', 'eruby', 'python'],
						   \ 'passive_filetypes': ['javascript', 'less'] }

