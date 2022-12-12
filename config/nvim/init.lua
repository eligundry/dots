-- Packer {{{
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- LSP & Autocompletion
  use {
    'neovim/nvim-lspconfig',
    run = 'npm i -g @fsouza/prettierd eslint_d',
    requires = {
      {
        'williamboman/mason.nvim',
        config = function()
          require("mason").setup()
        end,
        run = ':MasonInstall prettierd eslint_d'
      },
      {
        'williamboman/mason-lspconfig.nvim',
        config = function()
          require('mason-lspconfig').setup({
            ensure_installed = {
              'astro',
              'bashls',
              'cssls',
              'dockerls',
              'gopls',
              'html',
              'jsonls',
              'pyright',
              'sqls',
              'sumneko_lua',
              'tailwindcss',
              'tsserver',
              'vimls',
              'yamlls',
            },
          })
        end
      },
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'L3MON4D3/LuaSnip' },
      { 'jose-elias-alvarez/null-ls.nvim' },
      {
        'lukas-reineke/lsp-format.nvim',
        config = function()
          require('lsp-format').setup()
        end,
      },
    }
  }

  -- Treesitter (syntax highlighting)
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = 'all',
        auto_install = true,
        disable = {
          'startify',
        },
        -- rainbow = {
        --   enable = true,
        -- },
      }
    end,
    requires = {
      { 'p00f/nvim-ts-rainbow' }
    }
  }

  -- Telescope (searching)
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<c-p>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
    end,
  }

  -- File tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    tag = 'nightly',
    config = function()
      require("nvim-tree").setup({
        view = {
          mappings = {
            list = {
              { key = 'u', action = 'dir_up' },
              { key = 's', action = 'split' },
              { key = 'v', action = 'vsplit' },
              { key = 't', action = 'tabnew' },
              { key = 'x', action = 'close_node' },
              { key = 'r', action = 'refresh' },
              { key = 'R', action = 'rename' },
              { key = 'c', action = 'cd' },
            }
          }
        }
      })

      vim.keymap.set('n', '<Leader>nt', ':NvimTreeToggle<CR>')
    end,
  }

  -- GUI Improvements
  use 'mhinz/vim-startify'
  use 'RRethy/nvim-base16'
  use {
    'lewis6991/gitsigns.nvim',
    tag = 'release',
    config = function()
      require('gitsigns').setup()
    end,
  }
  use {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<Leader>ut', ':NvimTreeClose<CR>:UndotreeShow<CR>')
    end,
  }
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        theme = 'base16',
      })
    end,
  }

  -- tmux (because I guess you can configure it from vim?)
  use 'edkolev/tmuxline.vim'

  -- Searching
  use 'bronson/vim-visual-star-search'
  use 'mhinz/vim-grepper'
  -- Disabling ctrlp for now as it keeps crashing vim at random times. I think
  -- it may be an issue with treesitter? I am going to try to replace it
  -- completely with telescope.
  -- use {
  --   'ctrlpvim/ctrlp.vim',
  --   config = function()
  --     vim.g.ctrlp_max_files = 0
  --     vim.g.ctrlp_max_depth = 10
  --     vim.g.ctrlp_custom_ignore = {
  --       dir = '(.git|.hg|.svn|.vagrant|node_modules|vendor)$',
  --       file = '.(exe|so|dll|pyo|pyc)$'
  --     }
  --
  --     if vim.fn.executable('rg') then
  --       vim.opt.grepprg = 'rg --color=never'
  --       vim.opt.grepformat = '%f:%l:%c:%m'
  --       vim.g.ackprg = 'rg --vimgrep'
  --       vim.g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  --       vim.g.ctrlp_use_caching = false
  --     elseif vim.fn.executable('ag') then
  --       vim.opt.grepprg = 'ag --vimgrep $*'
  --       vim.opt.grepformat = '%f:%l:%c:%m'
  --       vim.g.ackprg = 'ag --vimgrep'
  --       vim.g.ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  --       vim.g.ctrlp_use_caching = false
  --     end
  --   end,
  -- }

  -- Editor Improvements
  use 'editorconfig/editorconfig-vim'
  use 'djoshea/vim-autoread'
  use {
    'Raimondi/delimitMate',
    config = function()
      vim.g.delimitMateAutoClose = 1
      vim.g.delimitMate_expand_cr = 1
      vim.g.delimitMate_expand_space = 1
      vim.g.delimitMate_smart_quotes = 1

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'vim', 'html', 'xml', 'xhtml', 'javascriptreact', 'typescriptreact' },
        command = 'let b:delimitMate_matchpairs = "(:),[:],{:},<:>"',
      })
    end,
  }
  use {
    'tomtom/tcomment_vim',
    config = function()
      vim.keymap.set('n', '<Leader>cc', ':TComment<CR>')
      vim.keymap.set('v', '<Leader>cc', ':TCommentBlock<CR>')
    end,
  }

  -- Vim God Tim Pope
  -- https://twitter.com/EliGundry/status/874737347568574464
  use 'tpope/vim-afterimage'
  use 'tpope/vim-dadbod'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-dotenv'
  use 'tpope/vim-eunuch'
  use {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<Leader>gs', ':Git<CR>')
      vim.keymap.set('n', '<Leader>gb', ':Git blame<CR>')
      vim.keymap.set('n', '<Leader>gp', ':Git pushy<CR>')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'gitcommit',
        callback = function()
          vim.keymap.set('n', '<Leader>s', ':wq<CR>', { buffer = true })
        end,
      })
    end,
  }
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use {
    'tpope/vim-tbone',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<Leader>ty', ':Tyank<CR>')
      vim.keymap.set({ 'n', 'v' }, '<Leader>tp', ':Tput<CR>')
    end,
  }

  -- Gists
  use 'mattn/gist-vim'
  use 'mattn/webapi-vim'

  -- Syntax Highlighting
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        'css';
        'javascript';
        html = { mode = 'foreground' };
      }
    end,
  }
  use {
    'elzr/vim-json',
    ft = { 'json', 'jsonc' },
    config = function()
      vim.g.vim_json_syntax_conceal = false
    end,
  }
  use {
    'plasticboy/vim-markdown',
    ft = 'markdown',
    config = function()
      vim.g.vim_markdown_folding_disabled = true
      vim.g.markdown_fenced_languages = {
        'coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript',
        'json=javascript', 'ruby', 'sass', 'xml', 'html', 'php',
        'python', 'less', 'vim', 'sh', 'shell=sh', 'bash=sh',
        'go', 'typescript',
      }
    end,
  }
  use 'pantharshit00/vim-prisma'
  use 'saltstack/salt-vim'
  use 'fourjay/vim-password-store'
  use 'wuelnerdotexe/vim-astro'

  -- Edit root files without elevating
  use 'lambdalisue/suda.vim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
--- }}}

-- Local functions {{{
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- }}}

-- File handling {{{
-- Gotta have these
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

-- Set default line endings as Unix
vim.g.fileformat = 'unix'
vim.opt.fileformats = 'unix,dos,mac'

-- 😍 ❤️ UTF-8
vim.g.encoding = 'utf-8'
vim.g.fileencoding = 'utf-8'
vim.g.bomb = false

-- Indenting
-- Most of these should be overridden by Editorconfig
vim.opt.tabstop = 4 -- I like my tabs to seem like four spaces
vim.opt.shiftwidth = 4 -- I'd also like to shift lines the same amount of spaces
vim.opt.softtabstop = 4 -- If using expandtab for some reason, use four spaces
vim.opt.autoindent = true -- Copy indenting from original block of text when yanked/pulled
vim.opt.expandtab = true -- Hard tabs are fun in theory, but don't work with other people
vim.opt.smarttab = true -- Make expandtab more tolerable
vim.opt.shiftround = true -- Round indents to multiples of shiftwidth
vim.opt.copyindent = true
vim.opt.smartindent = false -- Disabling this because it messes up pasting with indents

-- nvim history
vim.opt.history = 10000

-- I hate backups. There's no point anymore!
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupdir = '~/.neovim/backup'

-- I'm done using swaps. They are annoying.
vim.opt.swapfile = false
vim.opt.directory = '~/.neovim/swap'

-- Persistent undo is pretty awesome. It basically builds all sorts
-- of version control straight into your editor. It commits when ever
-- you leave insert/replace/change/etc. to normal. Gundo allows you to
-- see all of your edits in diff style so you can revert back to certain
-- parts in time.
vim.opt.undofile = true
vim.opt.undolevels = 3000
-- vim.opt.undodir = '~/.config/nvim/undo'
-- }}}

-- Behavior {{{
-- Set the title properly
vim.opt.title = true

-- Fancy (quick) search highlighting
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- CMD mode
-- When I search, I don't need to capitalize…
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true -- …but when I do, it'll pair down the search.
vim.opt.shellslash = true -- When in Windows, you can use / instead of \
vim.opt.magic = true -- Do You Believe In (Perl) Magic?
vim.opt.gdefault = true -- Use global by default when replacing

-- I have these wildignores commented out because they prevent NERDTree from
-- showing these files and will break Fugitive. Uncomment these if you want to
-- make Vim's autocomplete more relevant.
vim.cmd([[
  " set wildignore+=.git,.svn,.hg " Version control files
  " set wildignore+=*.jpg,*.jpeg,*.png,*.psd,*.ai,*.bmp,*.gif " Images
  set wildignore+=*.psd,*.ai " Images
  set wildignore+=*.o,*.obj,*.bak,*.exe
  set wildignore+=*.mp4,*.ogg,*.m4v,*.ogv,*.mp3 " Mulitmedia files
  set wildignore+=*.pyc,*.pyo,*.egg-info,.ropeproject,.tox " Python bullshit
  set wildignore+=.DS_Store " OSX bullshit
  set wildignore+=*.hist
]])

-- Stay in the same column when jumping around
vim.opt.startofline = false

-- Backspace all the things!
vim.opt.backspace = 'indent,eol,start'

-- Don't use more than one space after punctuation
vim.opt.joinspaces = false

-- Folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'marker'

-- I don't need Vim telling me where I can't go!
vim.opt.virtualedit = 'all'

-- Disable mouse is all modes in terminal Vim
vim.opt.mouse = ''

-- Hide mouse when typing
vim.opt.mousehide = true

-- Set <Leader> to be comma
vim.g.mapleader = ','

-- Remove trailing whitespace when saving files
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = ':%s/\\s\\+$//e'
})

-- Exit paste mode upon leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste paste?'
})

-- Use SudoWrite on read only files
vim.api.nvim_create_autocmd('FileChangedRO', {
  pattern = '*',
  command = 'nnoremap <buffer> <Leader>s :w suda://%<CR>'
})

-- Resize splits as vim is resized
vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  callback = function()
    vim.cmd(t('normal! <C-w>='))
  end
})

-- Only enable spell checking in some files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'text' },
  command = 'setlocal spell',
})
-- }}}

--- Theme (Base16) {{{
-- I Think It's Beautiful That Your Are 256 Colors Too
-- https://www.youtube.com/watch?v=bZ6b5ghZZN0
vim.cmd('set t_Co=256') -- 256 color support in terminal
vim.opt.termguicolors = true
vim.opt.background = 'dark' -- I like a dark background

if vim.env.BASE16_THEME then
  vim.cmd.colorscheme(string.format('base16-%s', vim.env.BASE16_THEME))
elseif vim.fn.filereadable(vim.fn.expand('~/.vimrc_background')) then
  vim.cmd('source ~/.vimrc_background')
else
  vim.cmd.colorscheme('base16-default-dark')
end

-- Don't make my terminal less transparent
-- NormalNC targets unfocused splits
vim.cmd([[
  hi Normal ctermbg=NONE guibg=NONE
  hi NormalNC ctermbg=NONE guibg=NONE
]])

-- Make all comments italic
vim.cmd('highlight Comment cterm=italic gui=italic')
-- }}}

-- Look & Feel {{{
-- Word Wrap
vim.opt.wrap = false -- I like scrolling off the screen
vim.opt.textwidth = 80 -- Standard width for terminals
vim.opt.formatoptions = 'oqn1tc' -- Check out 'fo-table' to see what this does.

-- Status bar
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 2
vim.opt.showmode = false -- Powerline shows mode now

-- Remove cursorline and colorcolumn when buffer loses focus
-- Put it back in when it gains focus
vim.opt.cursorline = true
vim.opt.colorcolumn = '+1'
vim.api.nvim_create_autocmd('WinLeave', {
  pattern = '*',
  callback = function()
    vim.opt.cursorline = false
    vim.opt.colorcolumn = ''
  end,
})
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'BufNewFile' }, {
  pattern = '*',
  callback = function()
    vim.opt.cursorline = true
    vim.opt.colorcolumn = '+1'
  end,
})

-- Completely hide concealed text (i.e. snippets)
-- vim.opt.conceallevel = 2
-- vim.opt.concealcursor = 'i'

-- When vertically scrolling, pad cursor 5 lines
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- List characters
vim.opt.list = false
vim.opt.listchars = 'tab:▸∙,eol:␤,trail:∘'
vim.keymap.set('n', '<Leader>ll', ':setlocal list!<CR>', {
  desc = 'Toggle list chars'
})

-- Timeout settings
vim.opt.timeout = true
vim.opt.ttimeout = false
vim.opt.timeoutlen = 1000

-- Split handling
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Editors should be seen and not heard
vim.opt.errorbells = false
vim.opt.visualbell = false
-- set t_vb=

-- Line Numbers
-- Use hybrid lines by setting both
vim.opt.numberwidth = 2

local _numberingMode = 0
local function numberingCycle(silent)
  if _numberingMode == 0 then
    vim.opt.number = true
    vim.opt.relativenumber = true
    _numberingMode = _numberingMode + 1
    if not silent then
      print('Hybrid number line!')
    end
    return
  elseif _numberingMode == 1 then
    vim.opt.number = true
    vim.opt.relativenumber = false
    _numberingMode = _numberingMode + 1
    if not silent then
      print('Normal number line!')
    end
    return
  else
    vim.opt.number = false
    vim.opt.relativenumber = false
    _numberingMode = 0
    if not silent then
      print('No number line!')
    end
    return
  end
end

numberingCycle(true)

vim.keymap.set('n', '<Leader>rn', numberingCycle, { desc = 'Cycle through relative and number, just number, no numbers' })

-- Change Tmux cursor in insert mode
vim.cmd('let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1')
--}}}

-- Keyboard shortcuts {{{
-- Window Navigation
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')

-- Window Resizing
vim.keymap.set('n', '<C-Up>', ':resize +1<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -1<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -1<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +1<CR>')
vim.keymap.set('n', '<Leader>ee', ':wincmd =<CR>')

-- Alternate increment mappings for screen and tmux
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- Easier line jumping
vim.keymap.set({ 'n', 'v' }, 'H', '^')
vim.keymap.set({ 'n', 'v' }, 'L', '$')

vim.keymap.set('n', '<Leader><Leader>', ':nohlsearch<CR>', {
  desc = 'Toggle search highlighting'
})

vim.keymap.set('n', '<Leader>ve', function()
  if vim.opt.virtualedit == 'all' then
    vim.opt.virtualedit = 'onemore'
  else
    vim.opt.virtualedit = 'all'
  end
end, { desc = 'Toggle virtual editing' })

-- Toggle arrow keys
local _arrowKeysEnabled = true

local function toggleArrowKeys(silent)
  _arrowKeysEnabled = not _arrowKeysEnabled
  vim.keymap.set('n', '<Up>', _arrowKeysEnabled and 'k' or ':resize +5<cr>')
  vim.keymap.set('n', '<Down>', _arrowKeysEnabled and 'j' or ':resize -5<cr>')
  vim.keymap.set('n', '<Left>', _arrowKeysEnabled and 'h' or ':vertical resize +5<cr>')
  vim.keymap.set('n', '<Right>', _arrowKeysEnabled and 'l' or ':vertical resize -5<cr>')
  vim.keymap.set('i', '<Up>', _arrowKeysEnabled and '<Up>' or '<Nop>')
  vim.keymap.set('i', '<Down>', _arrowKeysEnabled and '<Down>' or '<Nop>')
  vim.keymap.set('i', '<Left>', _arrowKeysEnabled and '<Left>' or '<Nop>')
  vim.keymap.set('i', '<Right>', _arrowKeysEnabled and '<Right>' or '<Nop>')

  if not silent then
    print(_arrowKeysEnabled and 'Arrow Keys Enabled' or 'Arrow Keys Disabled')
  end
end

toggleArrowKeys(true)

vim.keymap.set('n', '<Leader>ak', toggleArrowKeys, { desc = 'Toggle arrow keys for weaklings trying to use my vim' })

-- Map <Esc> to my right hand
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'JJ', '<Esc>')

-- Easy paste toggling
vim.keymap.set('n', '<Leader>pt', ':set paste! paste?<CR>')

-- Yank should work just like every other Vim verb
vim.keymap.set('n', 'Y', 'y$')

-- D yanks to end of line like every other Vim verb
vim.keymap.set('n', 'D', 'd$')

-- Undo/redo now make sense
vim.keymap.set('n', 'U', ':redo<CR>')

-- Don't unindent with hash symbol
vim.keymap.set('n', '#', '#')

-- Yank lines to system clipboard in visual
vim.keymap.set('v', '<Leader>Y', '"+y')

-- Jump between bracket pairs easily
-- Not using remap so I can use matchit
vim.keymap.set({ 'n', 'v' }, '<Tab>', '%', { remap = true })

-- Faster and more satisfying command mode access
vim.keymap.set({ 'n', 'v' }, '<Space>', ':')

-- Toggle line wrapping
vim.keymap.set('n', '<Leader>wp', ':set wrap!<CR>')

-- Saving & Quiting Shortcuts
vim.keymap.set('n', '<Leader>s', ':write<CR>')
vim.keymap.set('n', '<Leader>qa', ':qall<CR>')
vim.keymap.set('n', '<Leader>qq', ':quit<CR>')
vim.keymap.set('n', '<Leader>tt', ':tabnew<CR>')
vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>')

-- Sane movement
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'gk', 'k')

-- Shift blocks visually in visual mode and retain the selection
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Insert horizontal ellipsis in insert mode
vim.keymap.set('i', '\\...', '…')

-- My ideal state of using vim is to have it always in autochdir. This means,
-- whenever I open a new a file in a different directory, all vim commands for
-- file operations become scoped to that directory. As I navigate splits, it
-- will continuously change directories at the speed I move.
--
-- Unfortunately, almost no vim plugins work just right with that setup. ctrl-p
-- will always be relative to the root of the git repo, which feels right.
-- Grepper and telescope will be relative to the local file, which feels wrong.
-- nerdtree will be relative to the focused file upon opening, but nvim-tree is
-- gonna do whatever it likes. There is literally no way to win here.
--
-- Rather then fight these tools, I've switched up how autochdir can work for
-- me.
--
-- <Leader>acd will toggle autochdir on and off, restoring the directory vim was
-- opened with when it's off and setting it to the current file's directory when
-- it turns on (just for that buffer tho, might want to get frisky and mess with
-- some neighboring files in another split as I go)
--
-- <Leader>cd will set the working directory to the directory of the focused
-- buffer for all of vim. This can be useful when I want vim's plugins to start
-- operating relatively.
--
-- https://vimways.org/2019/vim-and-the-working-directory/
local _workingDirectoryVimWasOpenedFrom = vim.fn.getcwd()
local _acd = false
vim.opt.autochdir = _acd

vim.keymap.set('n', '<Leader>acd', function()
  _acd = not _acd

  if _acd then
    vim.opt.autochdir = _acd
    local _targetPath = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    vim.api.nvim_set_current_dir(_targetPath)
    print(string.format('turned on autochdir and set cwd to %s', _targetPath))
  else
    vim.opt.autochdir = _acd
    vim.api.nvim_set_current_dir(_workingDirectoryVimWasOpenedFrom)
    print(string.format('turned off autochdir and set cwd to %s', _workingDirectoryVimWasOpenedFrom))
  end
end)

vim.keymap.set('n', '<Leader>cd', function()
  local _targetPath = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  _workingDirectoryVimWasOpenedFrom = _targetPath
  vim.cmd(string.format('cd! %s', _targetPath))
  print(string.format('set cwd to %s', _targetPath))
end)

-- Insert a long-ish paragraph of hipster ipsum
vim.keymap.set('n', '<Leader>hi', function()
  local ipsum = vim.fn.system('curl -s "https://hipsum.co/api/?type=hipster-centric&sentences=5" | jq -r ".[]"')
  vim.fn.execute(string.format('normal! i%s', ipsum))
  vim.fn.execute('normal! kgqqj')
end)
-- }}}

-- LSP {{{
local lspconfig = require('lspconfig')
local lspformat = require('lsp-format')
local masonLSP = require('mason-lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_formatting = function(bufnr, isAsync)
  vim.lsp.buf.format {
    async = isAsync,
    filter = function(client)
      return client.name == 'null-ls'
    end,
    bufnr = bufnr,
  }
end

local lspFormattingAugroup = vim.api.nvim_create_augroup('LspFormatting', {})

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_clear_autocmds { group = lspFormattingAugroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lspFormattingAugroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr, false)
      end,
    })
  end

  lspformat.on_attach(client)

  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
  vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action)
  vim.keymap.set('n', '<Leader>d', vim.lsp.buf.definition)
  -- vim.keymap.set('n', '<Leader>p', function() lsp_formatting(_opts.bufnr, true) end, _opts)
  vim.keymap.set('n', '<Leader>RN', vim.lsp.buf.rename)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references)
end

masonLSP.setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name)
    lspconfig[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ['sumneko_lua'] = function(server_name)
    lspconfig.sumneko_lua.setup {
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    }
  end,
}

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.prettierd,
  },
})
-- }}}

-- Code completion (cmp) {{{
local cmp = require('cmp')
vim.opt.completeopt = 'menu,menuone,noselect'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
-- }}}
