"===============================================================================
" File: ssh.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Detect ssh config files
"===============================================================================

autocmd BufRead,BufNewFile *ssh/config* setfiletype sshconfig
