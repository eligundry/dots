"===============================================================================
" File: tmux.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Detect Tmux config files
"===============================================================================

autocmd BufRead,BufNewFile .tmux.conf,tmux.conf,tmuxline.conf setfiletype tmux
