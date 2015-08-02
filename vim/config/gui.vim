"===============================================================================
" File: gui.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim settings for how it looks
"===============================================================================

if has("cmdline_info")
	set ruler
	set showcmd
	set cmdheight=2
	set laststatus=2
	set noshowmode " Powerline shows mode now
endif

" Remove cursorline and colorcolumn when buffer loses focus
" Put it back in when it gains focus
if has("syntax") && v:version >= 703
	set cursorline colorcolumn=+1
	autocmd WinLeave * set nocursorline colorcolumn=""
	autocmd WinEnter,BufEnter,BufNewFile * set cursorline colorcolumn=+1
endif

" Completely hide concealed text (i.e. snippets)
if has('conceal')
	set conceallevel=2
	set concealcursor=i
endif

set t_Co=256 " 256 color support in terminal
set background=dark " I like a dark background

" When vertically scrolling, pad cursor 5 lines
if !&scrolloff
	set scrolloff=5
endif

" When scrolling horizontally, pad cursor 5 lines
if !&sidescrolloff
	set sidescrolloff=5
endif

" List characters
set nolist
set listchars=tab:▸∙,eol:␤,trail:∘

" Timeout settings
set timeout
set nottimeout
set timeoutlen=3000

" Split Handling
if has("windows") && has("vertsplit")
	set splitbelow
	set splitright
endif

" NO FREAKING BELLS
set noerrorbells
set novisualbell
set t_vb=

" Line Numbers
" Use hybrid lines by setting both
set number
set relativenumber

if v:version >= 730
	set norelativenumber
endif

if has("linebreak")
	set numberwidth=2
endif
