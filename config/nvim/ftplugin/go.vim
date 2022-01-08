"===============================================================================
" File: go.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: go specific vim settings
"===============================================================================

setlocal noexpandtab ts=4 sts=4 shiftwidth=4

"===============================================================================
" => coc.nvim
"===============================================================================

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
