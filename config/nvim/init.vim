"===============================================================================
" => # Deoplete Setup
"
" This is needed do deoplete can compile
"===============================================================================

function! DoRemote(arg)
	UpdateRemotePlugins
endfunction

"===============================================================================
" => # Plug
"===============================================================================

let g:plug_timeout = 5

call plug#begin('~/.config/nvim/plugged')

if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
	Plug 'neomake/neomake'
	Plug 'zchee/deoplete-jedi', { 'for': 'python' }
else
	Plug 'Shougo/neocomplete.vim'
endif

Plug 'IN3D/vim-raml'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeClose'] }
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bronson/vim-visual-star-search'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi', { 'for': 'python' }
Plug 'editorconfig/editorconfig-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'flazz/vim-colorschemes'
Plug 'luochen1990/rainbow'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim', { 'for': ['html', 'xml', 'htmldjango', 'xsl', 'haml', 'css', 'less', 'jinja', 'html.twig', 'html.handlebars', 'html.mustache'] }
Plug 'mbbill/undotree', { 'on': ['UndotreeHide', 'UndotreeShow'] }
Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeClose'] }
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'sjl/clam.vim'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install', 'for': ['javascript'] }
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" polyglot overriding
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'elzr/vim-json'
Plug 'saltstack/salt-vim'

call plug#end()

"===============================================================================
" => # File handling
"===============================================================================

" Gotta have these
filetype plugin indent on
syntax enable

" Set default line endings as Unix
setglobal fileformat=unix
set fileformats=unix,dos,mac

" I love UTF-8
if has("multi_byte")
	scriptencoding utf-8
	let &termencoding = &encoding
	setglobal encoding=utf-8
	setglobal fileencoding=utf-8
	setglobal nobomb
endif

" Indenting
set tabstop=4 " I like my tabs to seem like four spaces
set shiftwidth=4 " I'd also like to shift lines the same amount of spaces
set softtabstop=4 " If using expandtab for some reason, use four spaces
set autoindent " Copy indenting from original block of text when yanked/pulled
set noexpandtab " Tabs are '\t', not four spaces
set smarttab " Make expandtab more tolerable
set shiftround " Round indents to multiples of shiftwidth
set copyindent
set nosmartindent " Disabling this because it messes up pasting with indents

" NeoVim History
set history=700

" I hate backups. There's no point anymore!
set nobackup
set nowritebackup
set backupdir=~/.neovim/backup

" I'm done using swaps. They are annoying.
set noswapfile
set directory=~/.neovim/swap

" Persistent undo is pretty awesome. It basically builds all sorts
" of version control straight into your editor. It commits when ever
" you leave insert/replace/change/etc. to normal. Gundo allows you to
" see all of your edits in diff style so you can revert back to certain
" parts in time.
if has("persistent_undo")
	set undofile
	set undolevels=3000
	set undodir=~/.neovim/undo
else
	" If persistent undo isn't available, let's enable backups.
	set backup
	set writebackup
	set swapfile
endif

"===============================================================================
" => # Behavior
"===============================================================================

" Set the title properly
set t_ts=k
set t_fs=\
set title
set titlestring="%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)"

" Fancy (quick) search highlighting
if has("extra_search")
	set hlsearch
	set incsearch
endif

set ignorecase infercase " When I search, I don't need to capitalize...
set smartcase " ...but when I do, it'll pair down the search.
set shellslash " When in Windows, you can use / instead of \
set magic " Do You Believe In (Perl) Magic?
set gdefault " Use global by default when replacing

set wildmenu " Really helpful tab command completion
set wildmode=longest,full
set wildignorecase

" I have these wildignores commented out because they prevent NERDTree from
" showing these files and will break Fugitive. Uncomment these if you want to
" make Vim's autocomplete more relevant.
if has("wildignore")
	" set wildignore+=.git,.svn,.hg " Version control files
	" set wildignore+=*.jpg,*.jpeg,*.png,*.psd,*.ai,*.bmp,*.gif " Images
	set wildignore+=*.psd,*.ai " Images
	set wildignore+=*.o,*.obj,*.bak,*.exe
	set wildignore+=*.mp4,*.ogg,*.m4v,*.ogv,*.mp3 " Mulitmedia files
	set wildignore+=*.pyc,*.pyo " Python bullshit
	set wildignore+=.DS_Store " OSX bullshit
	set wildignore+=*.hist
endif

" Stay in the same column when jumping around
set nostartofline

" Backspace all the things!
set backspace=indent,eol,start

" I don't want other people's files messing up my settings
set nomodeline
set modelines=0

" Don't use more than one space after punctuation
set nojoinspaces

if has("folding")
	set nofoldenable " I hate folds...
	set foldmethod=manual " ...but if there are folds, let me control them
endif

" I don't need Vim telling me where I can't go!
if has("virtualedit")
	set virtualedit=all
endif

" Change current directory to whatever file I'm editing
if exists("+autochdir")
	set autochdir
endif

" Disable mouse is all modes in terminal Vim
set mouse=

" Hide mouse when typing
set mousehide

"===============================================================================
" => # Word Wrap
"===============================================================================

set nowrap " I like scrolling off the screen
set textwidth=80 " Standard width for terminals
set formatoptions=oqn1 " Check out 'fo-table' to see what this does.

"===============================================================================
" => # Look & Feel
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
" set norelativenumber

if has("linebreak")
	set numberwidth=2
endif

" Make all comments italic
highlight Comment cterm=italic

"===============================================================================
" => # Custom Functions
"===============================================================================

" Toggle relative line numbering
function! ToggleRelativeNumber()
	if &relativenumber
		set number
	elseif !&number
		set relativenumber
	else
		set nonumber norelativenumber
	endif
endfunction

" Toggle virtualedit settings
function! ToggleVirtualEdit()
	if &virtualedit == "all"
		set virtualedit=onemore
	else
		set virtualedit=all
	endif
endfunction

" Toggle mouse modes
function! ToggleMouse()
	if &mouse == "a"
		set mouse=
	else
		set mouse=a
	endif
endfunction

" Toggle arrow keys for weaklings trying to use my vim
let g:ArrowKeysEnabled = 1
function! ToggleArrowKeys(silent)
	let g:ArrowKeysEnabled = !g:ArrowKeysEnabled

	if g:ArrowKeysEnabled == 1
		nnoremap <silent> <Up> k
		nnoremap <silent> <Down> j
		nnoremap <silent> <Left> h
		nnoremap <silent> <Right> l
		inoremap <Left> <Left>
		inoremap <Right> <Right>
		inoremap <Up> <Up>
		inoremap <Down> <Down>

		if a:silent == 0
			echo "Arrow Keys enabled"
		endif
	else
		nnoremap <silent> <Up> :resize +5<cr>
		nnoremap <silent> <Down> :resize -5<cr>
		nnoremap <silent> <Left> :vertical resize -5<cr>
		nnoremap <silent> <Right> :vertical resize +5<cr>
		inoremap <Left> <Nop>
		inoremap <Right> <Nop>
		inoremap <Up> <Nop>
		inoremap <Down> <Nop>

		if a:silent == 0
			echo "Arrow Keys disabled"
		endif
	endif
endfunction

" Disable the arrow keys by default
call ToggleArrowKeys(1)

" Return to current line when reopening file
augroup line_return
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\     execute 'normal! g`"zvzz' |
		\ endif
augroup END

" Remove trailing whitespace when saving files
autocmd BufWritePre * :%s/\s\+$//e

" Exit paste mode upon leaving insert
autocmd InsertLeave * set nopaste paste?

" Use SudoWrite on read only files
autocmd FileChangedRO * nnoremap <buffer> <Leader>s :SudoWrite<CR>

" Resize splits as vim is resized
autocmd! VimResized * exe "normal! \<C-w>="

" Always spellcheck cause typos are dumb
autocmd BufEnter * set spell

"===============================================================================
" => # Keyboard Shortcuts
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
nnoremap <Leader>pt :set paste! paste?<CR>

" Yank should work just like every other Vim verb
noremap Y y$

" D yanks to end of line like every other Vim verb
nnoremap D d$

" Undo/redo now make sense
nnoremap U :redo<CR>

" Don't unindent with hash symbol
inoremap # #

" Disable Ex mode because it is garbage
nnoremap Q <Nop>

" Yank lines to system clipboard in visual
if has("unix")
	if system('uname -s') =~ 'Darwin'
		vnoremap <Leader>Y :w !pbcopy<CR><CR>
	else
		vnoremap <Leader>Y :w !xclip -i<CR><CR>
	endif
endif

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

" Open tag in new tab
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

"===============================================================================
" => # Solarized
"===============================================================================

" let g:solarized_bold = 1
" let g:solarized_italic = 1
" let g:solarized_menu = 0
" let g:solarized_termcolors = 256
" let g:solarized_termtrans = 1
" let g:solarized_visibility = "low"
" call togglebg#map("<Leader>bg")
" colorscheme solarized

"===============================================================================
" => # Base16
"===============================================================================

if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
else
	colorscheme base16-default-dark
endif

" On Linux terminals with transparent backgrounds, Base16 is overriding the
" background color making the Vim background solid. This will get around that.
if system('uname -s') =~ 'Linux'
	hi Normal ctermbg=None
endif

"===============================================================================
" => # Airline
"===============================================================================

let g:airline_powerline_fonts = 1

" CSV Stuff
let g:airline#extensions#csv#enabled = 1

" Version Contols Stuff
let g:airline#extensions#hunks#enabled = 1

" Virtualenv
let g:airline#extensions#virtualenv#enabled = 1

" Fancy Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

" Fancy Powerline symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Windows Section
if has("win32") || has("win64")
	let g:airline_powerline_fonts = 0
	let g:airline#extensions#tabline#left_sep = '>'
	let g:airline#extensions#tabline#left_alt_sep = '>'
	let g:airline#extensions#tabline#right_sep = '<'
	let g:airline#extensions#tabline#right_alt_sep = '<'
	let g:airline#extensions#tabline#left_sep = '>'
	let g:airline#extensions#tabline#left_alt_sep = '>'
	let g:airline#extensions#tabline#right_sep = '<'
	let g:airline#extensions#tabline#right_alt_sep = '<'
endif

" Fix Symbol issue in GUI
if has('gui')
	let g:airline_symbols.space = "\u3000"
endif

"===============================================================================
" => # Clam
"===============================================================================

function! ClamSettings()
	nnoremap ! :Clam<Space>
	vnoremap ! :ClamVisual<Space>
endfunction

autocmd VimEnter * if exists("loaded_clam") | call ClamSettings() | endif

" Setup colors for manpages
autocmd BufEnter man\ * setlocal filetype=man

"===============================================================================
" => Change Tmux cursor
"===============================================================================

if empty($TMUX)
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
	let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
	let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

"===============================================================================
" => Tmuxline
"===============================================================================

let g:tmuxline_powerline_separators = 1
let g:tmuxline_preset = 'powerline'

"===============================================================================
" => Syntastic
"===============================================================================

let g:syntastic_auto_loc_list = 1
let g:syntastic_auto_jump = 0
let g:syntastic_check_on_open = 0
let g:syntastic_enable_balloons = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_mode_map = { 'mode': 'active',
						   \ 'active_filetypes': ['html', 'xml', 'c', 'cpp', 'php', 'css', 'ruby', 'eruby', 'python', 'javascript'],
						   \ 'passive_filetypes': ['less'] }
let g:syntastic_javascript_checkers = ['eslint']

"===============================================================================
" => Neomake
"===============================================================================

let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
let g:neomake_open_list = 2

" https://robots.thoughtbot.com/my-life-with-neovim
function! NeomakeSettings()
	" Run NeoMake on read and write operations
	autocmd BufReadPost,BufWritePost * Neomake

	" Auto open the warning/error list when finished, but don't focus on it
	autocmd User NeomakeCountsChanged :lopen | wincmd k

	" Disable inherited syntastic
	let g:syntastic_mode_map = {
	\ "mode": "passive",
	\ "active_filetypes": [],
	\ "passive_filetypes": [] }
endfunction

autocmd VimEnter * if exists(":Neomake") | call NeomakeSettings() | endif

"===============================================================================
" => NERDTree
"===============================================================================

let g:NERDChristmasTree = 1
let g:NERDTreeCasadeOpenSingleChildDir = 1
let g:NERDTreeChDirMode = 1
let g:NERDTreeDirArrows = 0
let g:NERDTreeDirArrows = 0
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeIgnore = ['\.swp$', '\~$', '\.pyc', '__pycache__', '.DS_Store']
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowFiles = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeWinSize = 22

function! NERDTreeSettings()
	nnoremap <silent> <Leader>nt :UndotreeHide<CR>:NERDTreeToggle<CR>
	autocmd FileType nerdtree setlocal colorcolumn=""
endfunction

autocmd VimEnter * if exists(":NERDTree") | call NERDTreeSettings() | endif

"===============================================================================
" => Undotree
"===============================================================================

function! UndotreeSettings()
	nnoremap <silent> <Leader>ut :NERDTreeClose<CR>:UndotreeShow<CR>:UndotreeFocus<CR>
endfunction

autocmd VimEnter * if exists(":UndotreeShow") | call UndotreeSettings() | endif

"===============================================================================
" => Tern
"===============================================================================

if exists('g:plugs["tern_for_vim"]')
	let g:tern_show_argument_hints = 'on_hold'
	let g:tern_show_signature_in_pum = 1
	autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

"===============================================================================
" => Neocomplete, Deoplete, & Neosnippet
" These are shared because they share the same API.
""===============================================================================

let g:deoplete#enable_at_startup = 1
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 0


if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.java = '\k\.\k*'

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

"===============================================================================
" => Deoplete-Jedi
"===============================================================================

let deoplete#sources#jedi#show_docstring = 1
let g:python_host_prog = expand('~/.virtualenvs/neovim2/bin/python')
let g:python3_host_prog = expand('~/.virtualenvs/neovim3/bin/python')

"===============================================================================
" => Vim Plug
"===============================================================================

autocmd FileType vim-plug :vertical resize 40

"===============================================================================
" => CtrlP
"===============================================================================

let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 10
let g:ctrlp_custom_ignore = {
\	'dir': '\v[\/](node_modules|vendor)|\.(git|hg|svn|env|vagrant)$',
\	'file': '\v\.(exe|so|dll|pyo|pyc)$'
\ }

if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

function! CtrlPSettings()
	nnoremap <leader>ct :CtrlPTag<CR>
endfunction

autocmd VimEnter * if exists(':CtrlP') | call CtrlPSettings() | endif

"===============================================================================
" => delimitMate
"===============================================================================

let delimitMateAutoClose = 1
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_smart_quotes = 1
autocmd FileType vim,html,xml,xhtml let b:delimitMate_matchpairs = "(:),[:],{:},<:>"

"===============================================================================
" => Fugitive
"===============================================================================

function! FugitiveSettings()
	nnoremap <silent> <Leader>gs :Gstatus<CR>
	nnoremap <silent> <Leader>gb :Gblame<CR>
	nnoremap <silent> <Leader>gd :Gdiff<CR>
	nnoremap <silent> <Leader>gp :Git push<CR>
	nnoremap <silent> <Leader>gl :Glog<CR>
	autocmd FileType gitcommit nnoremap <buffer> <Leader>s :wq<CR>
endfunction

autocmd VimEnter * if exists("g:loaded_fugitive") | call FugitiveSettings() | endif

"===============================================================================
" => TagBar
"===============================================================================

function! TagBarSettings()
	nnoremap <silent> <Leader>tb :Tagbar<CR>
endfunction

autocmd VimEnter * if exists(":Tagbar") | call TagBarSettings() | endif

"===============================================================================
" => TComment
"===============================================================================

let g:tcommentBlankLines = 1

function! TCommentSettings()
	nnoremap <Leader>cc :TComment<CR>
	vnoremap <Leader>cc :TCommentBlock<CR>
endfunction

autocmd VimEnter * if exists(":TComment") | call TCommentSettings() | endif

"===============================================================================
" => TBone
"===============================================================================

function! TboneSettings()
	vnoremap <Leader>y :Tyank<CR>
	nnoremap <Leader>p :Tput<CR>
endfunction

autocmd VimEnter * if exists(":Tmux") | call TboneSettings() | endif

"===============================================================================
" => vim-json
"===============================================================================

let g:vim_json_syntax_conceal = 0

"===============================================================================
" => The Silver Searcher
"===============================================================================

" Use ag over grep
if executable('ag')
	set grepprg=ag\ --vimgrep\ $*
	set grepformat=%f:%l:%c:%m
endif

"===============================================================================
" => Rainbow Parentheses
"===============================================================================

let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['blue', 'yellow', 'red', 'cyan', 'magenta'],
\	'ctermfgs': ['blue', 'yellow', 'red', 'cyan', 'magenta'],
\	'operators': '_,_',
\	'parentheses': [
\		'start=/(/ end=/)/ fold',
\		'start=/\[/ end=/\]/ fold',
\		'start=/{/ end=/}/ fold'
\	],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'vim': {
\			'parentheses': [
\				'start=/(/ end=/)/',
\				'start=/\[/ end=/\]/',
\				'start=/{/ end=/}/ fold',
\				'start=/(/ end=/)/ containedin=vimFuncBody',
\				'start=/\[/ end=/\]/ containedin=vimFuncBody',
\				'start=/{/ end=/}/ fold containedin=vimFuncBody'
\			],
\		},
\		'html': {
\			'parentheses': [
\				'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'
\			],
\		},
\		'css': 0,
\   }
\}
