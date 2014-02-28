"===============================================================================
" File: rainbow-parentheses.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Settings for rainbow parentheses
"===============================================================================

" Name: rainbow_parentheses
" Author: kien
" URL: https://github.com/kien/rainbow_parentheses.vim
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound

" Disable Rainbow Parentheses in Vim help files
autocmd Syntax !help RainbowParenthesesLoadRound
autocmd Syntax !help RainbowParenthesesLoadSquare
autocmd Syntax !help RainbowParenthesesLoadBraces
