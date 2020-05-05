"===============================================================================
" File: go.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: go specific vim settings
"===============================================================================

"===============================================================================
" => ale
"===============================================================================

" call ale#linter#Define('go', {
" \   'name': 'revive',
" \   'output_stream': 'both',
" \   'executable': 'revive',
" \   'read_buffer': 0,
" \   'command': 'revive %t',
" \   'callback': 'ale#handlers#unix#HandleAsWarning',
" \})
"
" let b:ale_fixers = ['gofmt', 'goimports']
" let b:ale_fix_on_save = 1

"===============================================================================
" => coc.nvim
"===============================================================================

autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
