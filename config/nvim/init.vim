"===============================================================================
" => # Deoplete Setup
"
" This is needed do deoplete can compile
"===============================================================================

let g:loaded_python_provider = 1
let g:python_host_prog = expand('~/.pyenv/versions/neovim2/bin/python')
let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')

"===============================================================================
" => # Plug
"===============================================================================

let g:plug_timeout = 5
let g:plug_path = '~/.vim/plugged'

if has('nvim')
    let g:plug_path = '~/.config/nvim/plugged'
endif

call plug#begin(g:plug_path)

" IDE Features
Plug 'majutsushi/tagbar'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/vimproc.vim', { 'do' : 'make' }
Plug 'autozimu/LanguageClient-neovim', { 'do': 'bash install.sh' }

if has('nvim')
    Plug 'neomake/neomake'
    Plug 'Shougo/denite.nvim'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
    Plug 'roxma/LanguageServer-php-neovim',  { 'do': 'composer install && composer run-script parse-stubs' }
else
    Plug 'Shougo/neocomplete.vim'
    Plug 'scrooloose/syntastic'
endif

" GUI Improvements
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'flazz/vim-colorschemes'
Plug 'luochen1990/rainbow'
Plug 'mbbill/undotree', { 'on': ['UndotreeHide', 'UndotreeShow'] }
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeClose'] }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeClose'] }

if has('macunix')
    Plug 'ryanoasis/vim-devicons'
endif

" Searching
Plug 'bronson/vim-visual-star-search'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mhinz/vim-grepper'

" Editor Improvements
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/emmet-vim', { 'for': ['html', 'xml', 'htmldjango', 'xsl', 'haml', 'css', 'less', 'jinja', 'html.twig', 'html.handlebars', 'html.mustache', 'html.markdown', 'php', 'javascript.jsx', 'javascript'] }
Plug 'Raimondi/delimitMate'
Plug 'tomtom/tcomment_vim'

" Vim God Tim Pope
" https://twitter.com/EliGundry/status/874737347568574464
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-dotenv'

" Gists
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

" Python
Plug 'davidhalter/jedi', { 'for': 'python' }
Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
Plug 'klen/python-mode', { 'for': 'python' }

" Ansible
Plug 'pearofducks/ansible-vim'
Plug 'b4b4r07/vim-ansible-vault'

" Go
Plug 'fatih/vim-go', { 'for': 'go' }

if has('nvim')
    Plug 'zchee/deoplete-go', { 'for': 'go' }
endif

" Syntax Highlighting
Plug 'sheerun/vim-polyglot' " This must come first so it can be overridden
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'IN3D/vim-raml'
Plug 'Quramy/vim-js-pretty-template', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'ap/vim-css-color'
Plug 'davidoc/taskpaper.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
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
set expandtab " Hard tabs are fun in theory, but don't work with other people
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
    set undodir=~/.vim/undo

    if has('nvim')
        set undodir=~/.config/nvim/undo
    endif
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
    set wildignore+=*.pyc,*.pyo,*.egg-info,.ropeproject,.tox " Python bullshit
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
set timeoutlen=500

" Split Handling
if has("windows") && has("vertsplit")
    set splitbelow
    set splitright
endif

" Editors should be seen and not heard
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
        \if line("'\"") > 0 && line("'\"") <= line("$") |
        \   execute 'normal! g`"zvzz' |
        \endif
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
" autocmd BufEnter * set spell
" Except when in Vim builtins, cause they are distracting
" autocmd FileType nerdtree,startify set nospell

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
    if has('macunix')
        vnoremap <Leader>Y :w !pbcopy<CR><CR>
    else
        vnoremap <Leader>Y :w !xclip -i<CR><CR>
    endif
endif

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

" Open tag is vertical split
nnoremap <A-]> :vsplit<CR>:exec("tag ".expand("<cword>"))<CR>

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
" => Change Tmux cursor
"===============================================================================

if has('nvim')
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
else
    if empty($TMUX)
        let &t_SI = "\<Esc>]50;CursorShape=1\x7"
        let &t_EI = "\<Esc>]50;CursorShape=0\x7"
        let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    else
        let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
        let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    endif
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
let g:syntastic_mode_map = {
    \ 'mode': 'active',
    \ 'active_filetypes': ['html', 'xml', 'c', 'cpp', 'php', 'css', 'ruby', 'eruby', 'python', 'javascript'],
    \ 'passive_filetypes': ['less'] }
let g:syntastic_javascript_checkers = ['eslint']

"===============================================================================
" => Neomake
"===============================================================================

let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
let g:neomake_open_list = 2
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_php_enabled_makers = ['php', 'phpstan']
let g:neomake_typescript_enabled_makers = ['tslint']

" https://robots.thoughtbot.com/my-life-with-neovim
function! NeomakeSettings()
    " Run NeoMake on read and write operations
    autocmd BufReadPost,BufWritePost * Neomake

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
let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowFiles = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeWinSize = 22
let g:NERDTreeIgnore = ['\.swp$', '\~$', '\.pyc', '__pycache__', '.DS_Store',
                        \'\.egg-info', '.ropeproject', '.tox', '.cache',
                        \'htmlcov']

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
" => LanguageClient
"===============================================================================

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

let g:LanguageClient_serverCommands = {
\ 'css': ['css-languageserver', '--stdio'],
\ 'less': ['css-languageserver', '--stdio'],
\ 'scss': ['css-languageserver', '--stdio'],
\ 'javascript': ['javascript-typescript-stdio'],
\ 'javascript.jsx': ['javascript-typescript-stdio'],
\ 'typescript': ['javascript-typescript-stdio'],
\ 'typescript.jsx': ['javascript-typescript-stdio'],
\ }

autocmd FileType php LanguageClientStart

"===============================================================================
" => Neocomplete, Deoplete, & Neosnippet
" These are shared because they share the same API.
""===============================================================================

let g:deoplete#enable_at_startup = 1
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 0
" This will allow neosnippet to load snippets automatically from plugins.
" Why this isn't a default, I'll never know.
let g:neosnippet#enable_snipmate_compatibility = 1

if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif

if !exists('g:neocomplete#force_omni_input_patterns.python')
    let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.java = '\k\.\k*'

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

"===============================================================================
" => Jedi
"===============================================================================

let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

"===============================================================================
" => Deoplete-Jedi
"===============================================================================

let deoplete#sources#jedi#show_docstring = 1
let g:python_host_prog = expand('~/.pyenv/versions/neovim2/bin/python')
let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')

"===============================================================================
" => Python Mode
"===============================================================================

let g:pymode_virtualenv = 1
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>bp'
" I'm using neomake because it's async
let g:pymode_lint = 0
" Not the biggest fan of rope, because it seems like other plugins do it's job,
" but leaving it enabled because it allows for pretty highlighting.
let g:pymode_rope = 1
" This here be the worst setting ever with neocomplete
let g:pymode_rope_complete_on_dot = 0
" Love the new highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
" It can highlight code blocks but it's slow. Okay, I'll take that hit.
let g:pymode_syntax_slow_sync = 1

"===============================================================================
" => vim-pydocstring
"===============================================================================

nnoremap <silent> <C-_> <Plug>(pydocstring)

"===============================================================================
" => Vim Go
"===============================================================================

" let g:deoplete#sources#go#gocode_binary = '/usr/lib/go-1.9/bin/go'

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
\   'dir': '\v[\/](.git|.hg|.svn|.env|.vagrant|node_modules|vendor)$',
\   'file': '\v\.(exe|so|dll|pyo|pyc)$'
\ }

function! CtrlPSettings()
    nnoremap <leader>ct :CtrlPTag<CR>
    nnoremap <leader>cl :CtrlPLine<CR>

    if executable('ag')
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    endif
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

let g:tcomment#blank_lines = 1

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
" => vim-devicons
"===============================================================================

let g:webdevicons_enable_ctrlp = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

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
    let g:ackprg = 'ag --vimgrep'
endif

"===============================================================================
" => vim-gitgutter
"===============================================================================

set updatetime=100
let g:gitgutter_async = 1

"===============================================================================
" => Rainbow Parentheses
"===============================================================================

let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['blue', 'yellow', 'red', 'cyan', 'magenta'],
\   'ctermfgs': ['blue', 'yellow', 'red', 'cyan', 'magenta'],
\   'operators': '_,_',
\   'parentheses': [
\       'start=/(/ end=/)/ fold',
\       'start=/\[/ end=/\]/ fold',
\       'start=/{/ end=/}/ fold'
\   ],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'vim': {
\           'parentheses': [
\               'start=/(/ end=/)/',
\               'start=/\[/ end=/\]/',
\               'start=/{/ end=/}/ fold',
\               'start=/(/ end=/)/ containedin=vimFuncBody',
\               'start=/\[/ end=/\]/ containedin=vimFuncBody',
\               'start=/{/ end=/}/ fold containedin=vimFuncBody'
\           ],
\       },
\       'html': {
\           'parentheses': [
\               'start=/\v\<((|html|title|body|h1|h2|h3|h4|h5|h6|p|br|hr|acronym|abbr|address|b|bdi|bdo|big|blockquote|center|cite|code|del|dfn|em|font|i|ins|kbd|mark|meter|pre|progress|q|rp|rt|ruby|s|samp|small|strike|strong|sub|sup|time|tt|u|var|wbr|form|input|textarea|button|select|optgroup|option|label|fieldset|legend|datalist|keygen|output|frame|frameset|noframes|iframe|img|map|area|canvas|figcaption|figure|audio|source|track|video|a|link|nav|ul|ol|li|dir|dl|dt|dd|menu|menuitem|table|caption|th|tr|td|thead|tbody|tfoot|col|colgroup|style|div|span|header|footer|main|section|article|aside|details|dialog|summary|head|meta|base|basefont|script|noscript|applet|embed|object|param)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'
\           ],
\       },
\       'css': 0,
\   }
\}
