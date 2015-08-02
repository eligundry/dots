"===============================================================================
" File: keyboard-shortcuts.vim
" Author: Eli Gundry <eligundry@gmail.com>
" Description: Vim key mappings
"===============================================================================

" Use commas as leaders
let mapleader = ','
let maplocalleader = ','
let g:mapleader = ','

" Window Navigation
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

" Window Rotation
nnoremap <Leader>rr :wincmd r<CR>

" Window Resizing
nnoremap <silent> <C-Up> :resize +1<CR>
nnoremap <silent> <C-Down> :resize -1<CR>
nnoremap <silent> <C-Left> :vertical resize -1<CR>
nnoremap <silent> <C-Right> :vertical resize +1<CR>
nnoremap <Leader>ee :wincmd =<CR>

" Alternate increment mappings for screen and tmux
nnoremap + <C-a>
nnoremap - <C-x>

" Easier line jumping
noremap H ^
noremap L $

" Toggle search highlighting
nnoremap <Leader><Leader> :nohlsearch<CR>

" Toggle relative line numbering
nnoremap <Leader>rn :call ToggleRelativeNumber()<CR>

" Toggle virtual editing
nnoremap <Leader>ve :call ToggleVirtualEdit()<CR>

" Toggle mouse modes
nnoremap <Leader>mm :call ToggleMouse()<CR>

" Toggle arrow keys
nnoremap <Leader>ak :call ToggleArrowKeys(0)<CR>

" Toggle list chars
nnoremap <Leader>ll :setlocal list!<CR>

" Map <Esc> to my right hand
inoremap <silent> jj <Esc>
inoremap <silent> JJ <Esc>

" Paste toggle for the win
nnoremap <Leader>pt :set paste!<CR>:set paste?<CR>

" Yank should work just like every other Vim verb
noremap Y y$

" D yanks to end of line like every other Vim verb
nnoremap D d$

" Undo/redo now make sense
nnoremap U :redo<CR>

" Don't unindent with hash symbol
inoremap # #

" Yank lines to xclip in visual
vnoremap <Leader>Y :w !xclip<CR>

" Vimrc quick edit
nnoremap <Leader>tv :tabnew $MYVIMRC<CR>
nnoremap <Leader>ev :edit $MYVIMRC<CR>
nnoremap <Leader>pv :split $MYVIMRC<CR>
nnoremap <Leader>vv :vsplit $MYVIMRC<CR>
nnoremap <Leader>rv :source $MYVIMRC<CR>

" Buffer Navigation
nnoremap <Leader>bb :buffers<CR>
nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprevious<CR>

" Jump between bracket pairs easily
" Not using remap so I can use matchit
nmap <Tab> %
vmap <Tab> %

" Keep searches in the middle of the screen
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Faster command mode access
nnoremap <Space> :
nnoremap ; :!

" Toggle line wrapping
nnoremap <Leader>wp :set wrap!<CR>

" Saving & Quiting Shortcuts
nnoremap <Leader>s :update<CR>
nnoremap <Leader>ww :write<CR>
nnoremap <Leader>wq :wq!<CR>
nnoremap <Leader>wa :wall<CR>
nnoremap <Leader>qa :qall<CR>
nnoremap <Leader>qq :quit<CR>
nnoremap <Leader>tt :tabnew<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>to :tabonly<CR>

" Reload all files open
nnoremap <Leader>rr :bufdo e!<CR>:tabdo e!<CR>

" Sane movement
noremap <silent> j gj
noremap <silent> k gk
noremap <silent> gj j
noremap <silent> gk k

" Bubble lines of text with optional repeat count
nnoremap <silent> <S-j> @='ddp'<CR>
vnoremap <silent> <S-j> @='xp`[V`]'<CR>
nnoremap <silent> <S-k> @='ddkP'<CR>
vnoremap <silent> <S-k> @='xkP`[V`]'<CR>

" Shift blocks visually
vnoremap < <gv
vnoremap > >gv
