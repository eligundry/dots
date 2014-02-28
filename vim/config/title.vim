"===============================================================================
" File: title.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for setting the window title
"===============================================================================

set t_ts=k
set t_fs=\
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
