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

require('packer').startup(function ()
  use 'wbthomason/packer.nvim'

  -- LSP & Autocompletion
  use {
    'neovim/nvim-lspconfig',
    requires = {
      {
        'williamboman/mason.nvim',
        config = function ()
          require("mason").setup()
        end,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        config = function ()
          require('mason-lspconfig').setup({
            automatic_install = true,
            ensure_installed = {
              'astro',
              'bashls',
              'cssls',
              'dockerls',
              'eslint',
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
      {
        'hrsh7th/nvim-cmp',
        config = function ()
          vim.opt.completeopt = 'menu,preview,noselect'
          local cmp = require'cmp'
          cmp.setup({
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
              ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
            })
          })
        end,
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'L3MON4D3/LuaSnip' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        config = function ()
          local null_ls = require("null-ls")

          null_ls.setup({
            sources = {
              null_ls.builtins.formatting.stylua,
              null_ls.builtins.diagnostics.eslint,
              null_ls.builtins.completion.spell,
            },
          })
        end
      }
    }
  }
  --

  -- Treesitter (syntax highlighting)
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function ()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = 'all',
      }
    end,
  }

  -- Telescope (searching)
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function ()
      local builtin = require('telescope.builtin')
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
    config = function ()
      require("nvim-tree").setup({
        view = {
          mappings = {
            list = {
              { key = 'u', action = 'dir_up' },
              { key = 's', action = 'split' },
              { key = 'v', action = 'vsplit' },
              { key = 't', action = 'tabnew' },
              { key = 'x', action = 'close_node' },
            }
          }
        }
      })

      vim.keymap.set('n', '<Leader>nt', ':NvimTreeToggle<CR>')
    end,
  }

  -- GUI Improvements
  use {
    'lewis6991/gitsigns.nvim',
    tag = 'release',
    config = function ()
      require('gitsigns').setup()
    end,
  }
  use {
    'norcalli/nvim-base16.lua',
    config = function ()
      local base16 = require 'base16'
      base16(base16.themes['default-dark'], true)

      -- Don't make my terminal less transparent
      vim.api.nvim_set_hl(0, 'Normal', {})
    end,
  }
  use 'luochen1990/rainbow'
  use {
    'mbbill/undotree',
    config = function ()
      vim.keymap.set('n', '<Leader>ut', ':UndotreeShow<CR>')
    end,
  }
  use 'mhinz/vim-startify'
  use 'vim-airline/vim-airline'
  -- This is pinned because the new versions break base16_google_light, even
  -- though I'm not even setting them
  use {
    'vim-airline/vim-airline-themes',
    commit = '27e7dc5bf186c1d0977a594b398847fcc84f7e24',
    config = function ()
      vim.g.airline_powerline_fonts = 1

      -- CSV Stuff
      -- vim.g.airline#extensions#csv#enabled = 1

      -- Version Contols Stuff
      -- vim.g.airline#extensions#hunks#enabled = 1

      -- Virtualenv
      -- vim.g.airline#extensions#virtualenv#enabled = 1

      -- Coc
      vim.g['airline#extensions#coc#enabled'] = 1

      -- Fancy Tabline
      vim.g['airline#extensions#tabline#enabled'] = 1
      vim.g['airline#extensions#tabline#left_sep'] = ''
      vim.g['airline#extensions#tabline#left_alt_sep'] = ''
      vim.g['airline#extensions#tabline#right_sep'] = ''
      vim.g['airline#extensions#tabline#right_alt_sep'] = ''

      -- Fancy Powerline symbols
      vim.g.airline_left_sep = ''
      vim.g.airline_left_alt_sep = ''
      vim.g.airline_right_sep = ''
      vim.g.airline_right_alt_sep = ''
      vim.g['airline_symbols.branch'] = ''
      vim.g['airline_symbols.readonly'] = ''
      vim.g['airline_symbols.linenr'] = ''
      -- }}}

      -- Tmuxline {{{
      vim.g.tmuxline_powerline_separators = 1
      vim.g.tmuxline_preset = {
        a = '#S',
        win = { '#I', '#W' },
        cwin = { '#I', '#W' },
        x = '#(~/.tmux/scripts/now-playing.sh)',
        y = { '%Y-%m-%d', '%R' },
        z = '#H',
        options = { ['status-justify'] = 'left' }
      }
    end,
  }

  -- tmux (because I guess you can configure it from vim?)
  use 'edkolev/tmuxline.vim'

  -- Searching
  use 'bronson/vim-visual-star-search'
  use 'ctrlpvim/ctrlp.vim'

  -- Editor Improvements
  use 'editorconfig/editorconfig-vim'
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
    config = function ()
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
    config = function ()
      vim.keymap.set('n', '<Leader>gs', ':Git<CR>')
      vim.keymap.set('n', '<Leader>gb', ':Git blame<CR>')
      vim.keymap.set('n', '<Leader>gp', ':Git pushy<CR>')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'gitcommit',
        callback = function ()
          vim.keymap.set('n', '<Leader>s', ':wq<CR>')
        end,
      })
    end,
  }
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use {
    'tpope/vim-tbone',
    config = function ()
      vim.keymap.set({'n', 'v'}, '<Leader>ty', ':Tyank<CR>')
      vim.keymap.set({'n', 'v'}, '<Leader>tp', ':Tput<CR>')
    end,
  }

  -- Gists
  -- use 'mattn/gist-vim'
  -- use 'mattn/webapi-vim'

  -- Ansible
  use 'b4b4r07/vim-ansible-vault'

  -- Syntax Highlighting
  use 'sheerun/vim-polyglot' -- This must come first so it can be overridden
  --  use 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  use 'Glench/Vim-Jinja2-Syntax'
  use 'norcalli/nvim-colorizer.lua'
  use 'davidoc/taskpaper.vim'
  use 'elzr/vim-json'
  use 'plasticboy/vim-markdown'
  use 'saltstack/salt-vim'
  use 'pantharshit00/vim-prisma'
  use 'fourjay/vim-password-store'
  use 'wuelnerdotexe/vim-astro'

  -- Edit root files without elevating
  use 'lambdalisue/suda.vim'
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
vim.opt.undodir = '~/.config/nvim/undo'
-- }}}

-- Behavior {{{
-- Set the title properly
vim.opt.title = true
-- vim.opt.titlestring = "%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)"
-- vim.cmd([[
--   set t_ts=k
--   set t_fs=\
-- ]])

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

-- I don't want other people's files messing up my settings
vim.opt.modeline = false
vim.opt.modelines = 0

-- Don't use more than one space after punctuation
vim.opt.joinspaces = false

-- Folds
vim.opt.foldenable = false -- I hate folds…
vim.opt.foldmethod = 'manual' -- …but if there are folds, let me control them

-- I don't need Vim telling me where I can't go!
vim.opt.virtualedit = 'all'

-- Change current directory to whatever file I'm editing
vim.opt.autochdir = true

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
  callback = function ()
    vim.cmd(t('normal! <C-w>='))
  end
})

-- Only enable spell checking in some files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'text' },
  command = 'setlocal spell'
})
-- }}}

-- Look & Feel {{{
-- Word Wrap
vim.opt.wrap = false -- I like scrolling off the screen
vim.opt.textwidth = 80 -- Standard width for terminals
vim.opt.formatoptions = 'oqn1' -- Check out 'fo-table' to see what this does.

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
  callback = (function ()
    vim.opt.cursorline = false
    vim.opt.colorcolumn = ''
  end)
})
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'BufNewFile' }, {
  pattern = '*',
  callback = (function()
    vim.opt.cursorline = true
    vim.opt.colorcolumn = '+1'
  end)
})

-- Completely hide concealed text (i.e. snippets)
-- vim.opt.conceallevel = 2
-- vim.opt.concealcursor = 'i'

-- I Think It's Beautiful That Your Are 256 Colors Too
-- https://www.youtube.com/watch?v=bZ6b5ghZZN0
-- vim.opt.t_Co = 256 -- 256 color support in terminal
vim.opt.termguicolors = true
vim.opt.background = 'dark' -- I like a dark background

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
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

local _numberingMode = 0
vim.keymap.set('n', '<Leader>rn', function()
  if _numberingMode == 0 then
    vim.opt.number = true
    _numberingMode = _numberingMode + 1
    return
  elseif _numberingMode == 1 then
    vim.opt.relativenumber = true
    _numberingMode = _numberingMode + 1
    return
  else
    vim.opt.number = false
    vim.opt.relativenumber = false
    _numberingMode = 0
    return
  end
end, { desc = 'Cycle through relative and number, just number, no numbers' })

-- Change Tmux cursor in insert mode
vim.cmd('let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1')

-- Make all comments italic
vim.api.nvim_set_hl(0, 'Comment', { cterm = { italic = true }, italic = true })
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
vim.keymap.set({'n', 'v'}, 'H', '^')
vim.keymap.set({'n', 'v'}, 'L', '$')

vim.keymap.set('n', '<Leader><Leader>', ':nohlsearch<CR>', {
  desc = 'Toggle search highlighting'
})

vim.keymap.set('n', '<Leader>ve', function ()
  if vim.opt.virtualedit == 'all' then
    vim.opt.virtualedit = 'onemore'
  else
    vim.opt.virtualedit = 'all'
  end
end, { desc = 'Toggle virtual editing' })

-- Toggle arrow keys
local _arrowKeysEnabled = true

function toggleArrowKeys(silent)
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
vim.keymap.set({'n', 'v'}, '<Tab>', '%', { remap = true })

-- Faster and more satisfying command mode access
vim.keymap.set({'n', 'v'}, '<Space>', ':')

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

-- Bubble lines of text with optional repeat count in visual mode
-- vim.keymap.set('n', '<S-j>', ":@='xp`[V`]'<CR>")
-- vim.keymap.set('n', '<S-k>', ":@='xkP`[V`]'<CR>")

-- Shift blocks visually in visual mode and retain the selection
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Insert horizontal ellipsis in insert mode
vim.keymap.set('i', '\\...', '…')

-- Insert a long-ish paragraph of hipster ipsum
vim.keymap.set('n', '<Leader>hi', function()
  local ipsum = vim.fn.system('curl -s "https://hipsum.co/api/?type=hipster-centric&sentences=5" | jq -r ".[]"')
  vim.fn.execute(string.format('normal! i%s', ipsum))
  vim.fn.execute('normal! kgqqj')
end)
-- }}}

-- LSP {{{
local lspconfig = require('lspconfig')
local masonLSP = require('mason-lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_formatting = function(bufnr, isAsync)
  vim.lsp.buf.format {
    async = isAsync,
    filter = function(client) return client.name == 'null-ls' end,
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
      callback = function() lsp_formatting(bufnr, false) end,
    })
  end

  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition)
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action)
  vim.keymap.set('n', '<Leader>d', vim.lsp.buf.definition)
  -- vim.keymap.set('n', '<Leader>p', function() lsp_formatting(_opts.bufnr, true) end, _opts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename)
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
  ['tsserver'] = function()
    lspconfig.tsserver.setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- keymaps.tsserver(bufopts)
      end,
    }
  end,
  ['sumneko_lua'] = function()
    lspconfig.sumneko_lua.setup {
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    }
  end,
}
-- }}}
