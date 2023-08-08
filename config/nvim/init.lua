-- lazy.nvim {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set <Leader> to be comma
vim.g.mapleader = ','

require("lazy").setup(
-- Plugins {{{
  {
    -- Editor & GUI Improvements {{{
    'mhinz/vim-startify',
    'RRethy/nvim-base16',
    'edkolev/tmuxline.vim', -- tmux (because I guess you can configure it from vim?)
    'djoshea/vim-autoread',
    {
      'nvim-tree/nvim-web-devicons',
      lazy = false,
    },
    {
      'lewis6991/gitsigns.nvim',
      tag = 'release',
      config = function()
        require('gitsigns').setup()
      end,
    },
    {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup({
          theme = 'base16',
        })
      end,
    },
    {
      'nvim-tree/nvim-tree.lua',
      tag = 'nightly',
      cmd = { 'NvimTreeToggle', 'NvimTreeFocus', 'NvimTreeFindFile', 'NvimTreeCollapse' },
      keys = {
        { '<leader>nt', '<cmd>NvimTreeToggle<CR>', mode = 'n', desc = 'nvim-tree: toggle' },
      },
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
      end,
    },
    {
      'lambdalisue/suda.vim',
      event = 'FileChangedRO',
      init = function()
        vim.api.nvim_create_autocmd('FileChangedRO', {
          pattern = '*',
          command = 'nnoremap <buffer> <Leader>s :w suda://%<CR>',
          desc = 'Use SudoWrite on read only files'
        })
      end,
    },
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require('nvim-autopairs').setup()

        -- Make cmp work with nvim-autopairs
        -- https://github.com/windwp/nvim-autopairs/blob/ae5b41ce880a6d850055e262d6dfebd362bb276e/README.md#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo
        local cmp = require('cmp')
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      end,
    },
    -- }}}
    -- Searching {{{
    {
      'bronson/vim-visual-star-search',
      keys = { { '*', mode = 'v' }, { '#', mode = 'v' } }
    },
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.2',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'debugloop/telescope-undo.nvim',
      },
      cmd = { 'Telescope' },
      keys = function()
        local builtin = require('telescope.builtin')
        return {
          { '<c-p>',      builtin.find_files,        mode = 'n', desc = 'telescope: Fuzzy find files' },
          { '<leader>ff', builtin.find_files,        mode = 'n', desc = 'telescope: Fuzzy find files' },
          { '<leader>fg', builtin.live_grep,         mode = 'n', desc = 'telescope: Live grep' },
          { '<leader>fb', builtin.buffers,           mode = 'n', desc = 'telescope: Browse buffers' },
          { '<leader>fh', builtin.help_tags,         mode = 'n', desc = 'telescope: Browse help' },
          { '<leader>ft', builtin.treesitter,        mode = 'n', desc = 'telescope: Browse Treesitter' },
          { '<leader>td', builtin.diagnostics,       mode = 'n', desc = 'telescope: Diagnostics' },
          { '<leader>ut', '<cmd>Telescope undo<CR>', mode = 'n', desc = 'telescope: Undotree' }
        }
      end,
      config = function()
        require("telescope").load_extension("undo")
      end,
    },
    -- }}}
    -- Treesitter (syntax highlighting and so much more) {{{
    {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-treesitter.configs').setup({
          sync_install = false,
          auto_install = true,
          disable = {
            'startify',
          },
          context_commentstring = {
            enable = true,
            enable_autocmd = false,
          },
          autotag = {
            enable = true,
          }
        })
      end,
    },
    {
      'windwp/nvim-ts-autotag',
      dependencies = {},
      ft = {
        'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
        'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'xml', 'php', 'markdown',
        'astro', 'glimmer', 'handlebars', 'hbs'
      },
      config = function()
        require('nvim-ts-autotag').setup()
      end,
    },
    -- }}}
    -- LSP & Autocompletion {{{
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        {
          'williamboman/mason.nvim',
          config = function()
            require("mason").setup()
          end,
          build = ':MasonInstall prettierd eslint_d'
        },
        {
          'williamboman/mason-lspconfig.nvim',
          config = function()
            require('mason-lspconfig').setup({
              automatic_install = true,
              ensure_installed = {
                'astro',
                'bashls',
                'cssls',
                'gopls',
                'html',
                'intelephense', -- PHP
                'jsonls',
                'lua_ls',
                'taplo', -- TOML
                'tsserver',
                'vimls',
                'yamlls',
              }
            })
          end
        },
      },
      config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')
        local lspformat = require('lsp-format')
        local mason_lsp = require('mason-lspconfig')
        local lsp_formatting = function(bufnr, isAsync)
          vim.lsp.buf.format {
            async = isAsync,
            bufnr = bufnr,
          }
        end
        local lsp_formatting_augroup = vim.api.nvim_create_augroup('LspFormatting', {})

        local on_attach = function(client, bufnr)
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Disables really 💩 syntax highlighting, Treesitter is so much
          -- better
          client.server_capabilities.semanticTokensProvider = nil

          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = lsp_formatting_augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = lsp_formatting_augroup,
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

        mason_lsp.setup_handlers {
          -- The first entry (without a key) will be the default handler
          -- and will be called for each installed server that doesn't have
          -- a dedicated handler.
          function(server_name)
            lspconfig[server_name].setup {
              on_attach = on_attach,
              capabilities = capabilities,
            }
          end,
          ['lua_ls'] = function()
            lspconfig.lua_ls.setup {
              on_attach = on_attach,
              settings = {
                Lua = {
                  runtime = {
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    globals = { 'vim' },
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              },
            }
          end,
          ['tailwindcss'] = function()
            lspconfig.tailwindcss.setup {
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                tailwindCSS = {
                  classAttributes = { "class", "className", "ngClass", 'class:list' },
                }
              }
            }
          end,
        }
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'onsails/lspkind.nvim',
        {
          'uga-rosa/cmp-dictionary',
          build = 'aspell -d en dump master | aspell -l en expand > $DOTS/config/nvim/dict/en.dict',
          config = function()
            local dict = require('cmp_dictionary')
            dict.switcher({
              spelllang = {
                en = vim.fn.expand('$DOTS/config/nvim/dict/en.dict'),
              },
            })
          end,
        },
        {
          'saadparwaiz1/cmp_luasnip',
          dependencies = { 'L3MON4D3/LuaSnip' },
        },
        {
          'lukas-reineke/lsp-format.nvim',
          config = function()
            require('lsp-format').setup()
          end,
        },
        {
          'dcampos/cmp-emmet-vim',
          keys = {
            {
              '<c-y>',
              mode = 'i',
              desc = 'Emmet expansion in insert mode (you probably need to type `<c-y>,`)'
            }
          },
          dependencies = {
            {
              'mattn/emmet-vim',
              config = function()
                -- expand emmet snippet with <c-y>,
                vim.g.user_emmet_leader_key = '<C-y>'
              end,
            },
          },
        },
        -- Pressing <CR> on a Copilot suggestion will expand it
        {
          'zbirenbaum/copilot-cmp',
          dependencies = {
            {
              'zbirenbaum/copilot.lua',
              config = function()
                require('copilot').setup({
                  suggestion = { enabled = false },
                  panel = { enabled = false },
                })
              end,
            }
          },
          config = function()
            require('copilot_cmp').setup()
          end,
        },
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lspkind = require('lspkind')

        -- vim setting to make this all work
        vim.opt.completeopt = 'menu,menuone,noselect'

        -- cmp setup
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          style = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
          window = {
            completion = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              scrollbar = "║",
              winhighlight = "Normal:Pmenu,FloatBorder:CmpCompletionBorder,CursorLine:PmenuSel,Search:None",
              autocomplete = {
                require("cmp.types").cmp.TriggerEvent.InsertEnter,
                require("cmp.types").cmp.TriggerEvent.TextChanged,
              },
            },
            documentation = {
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
              scrollbar = "║",
            },
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
            ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
            ["<C-s>"] = cmp.mapping.complete({
              config = {
                sources = {
                  { name = 'copilot' },
                }
              }
            }),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            }),
          }),
          formatting = {
            format = lspkind.cmp_format({
              mode = 'symbol',
              maxwidth = 50,
              ellipsis_char = '…',
              symbol_map = {
                Copilot = '',
                Dictionary = '📗',
              },
            })
          },
          sources = cmp.config.sources({
            {
              name = 'copilot',
              group_index = 1,
              priority = 1,
            },
            {
              name = 'nvim_lsp',
              group_index = 1,
              priority = 2,
            },
            {
              name = 'path',
              group_index = 2,
              priority = 2,
            },
            {
              name = 'emmet_vim',
              group_index = 2,
              priority = 2,
            },
            {
              name = 'buffer',
              group_index = 3,
              priority = 3,
            },
            {
              name = 'dictionary',
              keyword_length = 2,
              max_item_count = 3,
              group_index = 3,
              priority = 3,
            },
            {
              name = 'luasnip',
              group_index = 4,
              priority = 4,
            },
          })
        })

        -- Make the cursorline visible when selecting
        vim.api.nvim_set_hl(0, 'CmpSelection', {
          bg = 'red',
          ctermbg = 'red',
          fg = 'red',
          ctermfg = 'red',
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
            {
              name = 'path',
              group_index = 1,
            },
            {
              name = 'cmdline',
              group_index = 2,
            }
          })
        })
      end,
    },
    {
      'mhartington/formatter.nvim',
      event = 'BufWritePre',
      config = function()
        local javascript = require("formatter.filetypes.javascript")
        local typescript = require("formatter.filetypes.typescript")
        local go = require("formatter.filetypes.go")

        require("formatter").setup({
          logging = true,
          log_level = vim.log.levels.WARN,
          filetype = {
            ['*'] = {
              require("formatter.filetypes.any").remove_trailing_whitespace,
            },
            css = {
              require("formatter.filetypes.css").prettierd,
            },
            go = {
              go.gofmt,
              go.goimports,
            },
            javascript = {
              javascript.prettierd,
              javascript.eslint_d,
            },
            javascriptreact = {
              javascript.prettierd,
              javascript.eslint_d,
            },
            json = {
              require("formatter.filetypes.json").prettierd,
            },
            typescript = {
              typescript.prettierd,
              typescript.eslint_d,
            },
            typescriptreact = {
              typescript.prettierd,
              typescript.eslint_d,
            },
          }
        })

        vim.api.nvim_create_autocmd('BufWritePost', {
          pattern = '*',
          command = 'FormatWrite',
        })
      end,
    },
    -- }}}
    -- Commenting {{{
    'JoosepAlviste/nvim-ts-context-commentstring',
    {
      'numToStr/Comment.nvim',
      keys = {
        { 'gcc', mode = { 'n', 'v' }, desc = 'Comment.nvim: Line-comment toggle' },
        { 'gbc', mode = { 'n', 'v' }, desc = 'Comment.nvim: Block-comment toggle keymap' },
        { 'gc',  mode = { 'n', 'v' }, desc = 'Comment.nvim: Line-comment keymap' },
        { 'gb',  mode = { 'n', 'v' }, desc = 'Comment.nvim: Block-comment keymap' },
        { 'gcO', mode = { 'n', 'v' }, desc = 'Comment.nvim: Add comment on the line above' },
        { 'gco', mode = { 'n', 'v' }, desc = 'Comment.nvim: Add comment on the line below' },
        { 'gcA', mode = { 'n', 'v' }, desc = 'Comment.nvim: Add comment at the end of line' },
      },
      config = function()
        require('Comment').setup({
          ---LHS of toggle mappings in NORMAL mode
          toggler = {
            ---Line-comment toggle keymap
            line = 'gcc',
            ---Block-comment toggle keymap
            block = 'gbc',
          },
          ---LHS of operator-pending mappings in NORMAL and VISUAL mode
          opleader = {
            ---Line-comment keymap
            line = 'gc',
            ---Block-comment keymap
            block = 'gb',
          },
          ---LHS of extra mappings
          extra = {
            ---Add comment on the line above
            above = 'gcO',
            ---Add comment on the line below
            below = 'gco',
            ---Add comment at the end of line
            eol = 'gcA',
          },
          ---Enable keybindings
          ---NOTE: If given `false` then the plugin won't create any mappings
          mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
          },
        })
      end,
    },
    -- }}}
    -- Vim God Tim Pope {{{
    {
      'tpope/vim-dadbod',
      ft = 'sql',
      cmd = 'DB',
      config = function()
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'sql',
          callback = function()
            vim.keymap.set('n', '<Leader>e', ':%DB g:auto<CR>', { buffer = true })
            vim.keymap.set('v', '<Leader>e', ":'<,'>DB g:auto<CR>", { buffer = true })
          end,
          desc = '<Leader>e will execute the current sql with vim-dadbod against DB g:auto',
        })
      end,
    },
    'tpope/vim-dispatch',
    'tpope/vim-dotenv',
    {
      'tpope/vim-eunuch',
      cmd = { 'Remove', 'Delete', 'Move', 'Chmod', 'Mkdir', 'Cfind', 'Clocate', 'Lfind', 'Llocate', 'SudoWrite',
        'SudoEdit' }
    },
    {
      'tpope/vim-fugitive',
      cmd = 'Git',
      keys = {
        { '<leader>gs', '<cmd>Git<CR>',       mode = 'n', desc = 'Git status' },
        { '<leader>gb', '<cmd>Git blame<CR>', mode = 'n', desc = 'Git blame' },
        { '<leader>gp', '<cmd>Git pushy<CR>', mode = 'n', desc = 'Git pushy' }
      },
      init = function()
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'gitcommit',
          callback = function()
            vim.keymap.set('n', '<Leader>s', ':wq<CR>', { buffer = true })
          end,
          desc = 'My normal save shortcut will write the commit',
        })
      end,
    },
    {
      'tpope/vim-surround',
      dependencies = {
        'tpope/vim-repeat',
      },
      keys = {
        { 'cs', desc = 'vim-surround: change surrouding delimiter' },
        { 'ds', desc = 'vim-surround: delete surrouding delimiter' },
        { 'ys', desc = 'vim-surround: add surrouding delimiter' },
        { 'S',  desc = 'vim-surround: add delimiter to selection', mode = 'v' },
      },
    },
    {
      'tpope/vim-tbone',
      cmd = { 'Tmux', 'Twrite', 'Tattach', 'Tynak', 'Tput' },
      keys = {
        { '<leader>ty', '<cmd>Tyank<CR>', mode = 'n',          desc = 'tbone: Yank line into tmux buffer' },
        {
          '<leader>ty',
          "<cmd>'<,'>Tyank<CR>",
          mode = 'v',
          desc =
          'tbone: Yank selection into tmux buffer'
        },
        { '<leader>tp', '<cmd>Tput<CR>',  mode = { 'n', 'v' }, desc = 'tbone: Paste text from tmux buffer' }
      },
    },
    -- }}}
    -- Github {{{
    {
      'mattn/vim-gist',
      dependencies = { 'mattn/webapi-vim' },
      cmd = 'Gist',
    },
    {
      'tyru/open-browser-github.vim',
      dependencies = { 'tyru/open-browser.vim' },
      cmd = { 'OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq', 'OpenGithubProject' }
    },
    -- }}}
    -- HTTP Client {{{
    {
      'rest-nvim/rest.nvim',
      dependencies = { "nvim-lua/plenary.nvim" },
      ft = 'http',
      config = function()
        require('rest-nvim').setup({
          result_split_horizontal = true,
          encode_url = true,
          result = {
            show_url = true,
            show_http_info = true,
            show_headers = true,
            formatters = {
              json = 'jq',
              html = false,
            },
          },
        })

        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'http',
          callback = function()
            vim.keymap.set('n', '<Leader>e', '<Plug>RestNvim', { buffer = true })
          end,
          desc = '<Leader>e will execute the current file with rest.nvim',
        })
      end,
    },
    -- }}}
    -- Syntax Highlighting {{{
    {
      'norcalli/nvim-colorizer.lua',
      ft = { 'css', 'less', 'scss', 'sass', 'html', 'javascript', 'javascriptreact', 'typescript',
        'typescriptreact' },
      config = function()
        require('colorizer').setup(
          {
            'css', 'less', 'scss', 'sass', 'html', 'javascript', 'javascriptreact', 'typescript',
            'typescriptreact'
          },
          {
            css = true,
            css_fn = true,
          }
        )
      end,
    },
    {
      'elzr/vim-json',
      ft = { 'json', 'jsonc' },
      config = function()
        vim.g.vim_json_syntax_conceal = false
      end,
    },
    {
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
    },
    {
      'fourjay/vim-password-store',
      ft = 'pass',
    },
    {
      'wuelnerdotexe/vim-astro',
      ft = 'astro',
    },
    -- }}}
  }
-- }}}
)
-- }}}

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

-- Read files if they change outside of Vim
vim.opt.autoread = true

-- Indenting
-- Most of these should be overridden by Editorconfig
vim.opt.tabstop = 4         -- I like my tabs to seem like four spaces
vim.opt.shiftwidth = 4      -- I'd also like to shift lines the same amount of spaces
vim.opt.softtabstop = 4     -- If using expandtab for some reason, use four spaces
vim.opt.autoindent = true   -- Copy indenting from original block of text when yanked/pulled
vim.opt.expandtab = true    -- Hard tabs are fun in theory, but don't work with other people
vim.opt.smarttab = true     -- Make expandtab more tolerable
vim.opt.shiftround = true   -- Round indents to multiples of shiftwidth
vim.opt.copyindent = true
vim.opt.smartindent = false -- Disabling this because it messes up pasting with indents

-- nvim history
vim.opt.history = 10000

-- I hate backups. There's no point anymore!
vim.opt.backup = false
vim.opt.writebackup = false

-- I'm done using swaps. They are annoying.
vim.opt.swapfile = false

-- Persistent undo is pretty awesome. It basically builds all sorts
-- of version control straight into your editor. It commits when ever
-- you leave insert/replace/change/etc. to normal. Gundo allows you to
-- see all of your edits in diff style so you can revert back to certain
-- parts in time.
vim.opt.undofile = true
vim.opt.undolevels = 3000
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
vim.opt.smartcase = true  -- …but when I do, it'll pair down the search.
vim.opt.shellslash = true -- When in Windows, you can use / instead of \
vim.opt.magic = true      -- Do You Believe In (Perl) Magic?
vim.opt.gdefault = true   -- Use global by default when replacing

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
vim.opt.foldmethod = 'manual'

-- I don't need Vim telling me where I can't go!
vim.opt.virtualedit = 'all'

-- Disable mouse is all modes in terminal Vim
vim.opt.mouse = ''

-- Hide mouse when typing
vim.opt.mousehide = true

-- Make searching blazing fast
if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --color=never'
  vim.opt.grepformat = '%f:%l:%c:%m'
  vim.g.ackprg = 'rg --vimgrep'
elseif vim.fn.executable('ag') then
  vim.opt.grepprg = 'ag --vimgrep $*'
  vim.opt.grepformat = '%f:%l:%c:%m'
  vim.g.ackprg = 'ag --vimgrep'
end
-- }}}

-- autocmds {{{
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*',
--   command = ':%s/\\s\\+$//e',
--   desc = 'Remove trailing whitespace when saving files'
-- })

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste paste?',
  desc = 'Exit paste mode upon leaving insert',
})

vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  callback = function()
    vim.cmd(t('normal! <C-w>='))
  end,
  desc = 'Resize splits as vim is resized'
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown', 'text' },
  command = 'setlocal spell',
  desc = 'Only enable spell checking in some files'
})

local crosshairAugroup = vim.api.nvim_create_augroup('BufferCrosshair', {})
vim.api.nvim_create_autocmd('WinLeave', {
  pattern = '*',
  group = crosshairAugroup,
  callback = function()
    vim.opt.cursorline = false
    vim.opt.colorcolumn = ''
  end,
  desc = 'Window crosshair: Remove cursorline and colorcolumn when buffer loses focus'
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'BufNewFile' }, {
  pattern = '*',
  group = crosshairAugroup,
  callback = function()
    vim.opt.cursorline = true
    vim.opt.colorcolumn = '+1'
  end,
  desc = 'Window crosshair: Restore cursorline and colorcolumn when buffer gains focus'
})
-- }}}

-- Theme (Base16) {{{
-- I Think It's Beautiful That Your Are 256 Colors Too
-- https://www.youtube.com/watch?v=bZ6b5ghZZN0
vim.cmd('set t_Co=256')     -- 256 color support in terminal
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
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', ctermbg = 'NONE' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE', ctermbg = 'NONE' })

-- Make all comments italic
vim.cmd('highlight Comment cterm=italic gui=italic')
-- }}}

-- Look & Feel {{{
-- Word Wrap
vim.opt.wrap = false             -- I like scrolling off the screen
vim.opt.textwidth = 80           -- Standard width for terminals
vim.opt.formatoptions = 'oqn1tc' -- Check out 'fo-table' to see what this does.

-- Status bar
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 2
vim.opt.showmode = false -- Powerline shows mode now

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

vim.keymap.set('n', '<Leader>rn', numberingCycle, {
  desc = 'Cycle through relative and number, just number, no numbers',
})

-- Change Tmux cursor in insert mode
vim.cmd('let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1')
--}}}

-- Keyboard shortcuts {{{
-- Window Navigation
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', {
  desc = 'Navigate to window left',
})
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', {
  desc = 'Navigate to window below',
})
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', {
  desc = 'Navigate to window above',
})
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', {
  desc = 'Navigate to window right',
})

-- Window Resizing
vim.keymap.set('n', '<C-Up>', ':resize +1<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -1<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -1<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +1<CR>')
vim.keymap.set('n', '<Leader>ee', ':wincmd =<CR>')

-- Alternate increment mappings for screen and tmux
vim.keymap.set('n', '+', '<C-a>', {
  desc = 'Increment number under cursor',
})
vim.keymap.set('n', '-', '<C-x>', {
  desc = 'Decrement number under cursor',
})

-- Easier line jumping
vim.keymap.set({ 'n', 'v' }, 'H', '^', {
  desc = 'Move to beginning of line',
})
vim.keymap.set({ 'n', 'v' }, 'L', '$', {
  desc = 'Move to end of line',
})

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

vim.keymap.set('n', '<Leader>ak', toggleArrowKeys, {
  desc = 'Toggle arrow keys for weaklings trying to use my vim',
})

-- Map <Esc> to my right hand
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'JJ', '<Esc>')

-- Easy paste toggling
vim.keymap.set('n', '<Leader>pt', ':set paste! paste?<CR>')

-- Yank should work just like every other Vim verb
vim.keymap.set('n', 'Y', 'y$', {
  desc = 'Yank to end of line',
})

-- D yanks to end of line like every other Vim verb
vim.keymap.set('n', 'D', 'd$', {
  desc = 'Delete to end of line',
})

-- Undo/redo now make sense
vim.keymap.set('n', 'U', ':redo<CR>')

-- Don't unindent with hash symbol
vim.keymap.set('n', '#', '#')

-- Yank lines to system clipboard in visual
vim.keymap.set('v', '<Leader>Y', '"+y', {
  desc = 'Yank lines to system clipboard',
})

-- Jump between bracket pairs easily
-- Not using remap so I can use matchit
vim.keymap.set({ 'n', 'v' }, '<Tab>', '%', {
  remap = true,
  desc = 'Jump between matching pairs',
})

-- Faster and more satisfying command mode access
vim.keymap.set({ 'n', 'v' }, '<Space>', ':', {
  desc = 'Smack the space bar as hard as you can to enter command mode',
})

-- Toggle local line wrapping
vim.keymap.set('n', '<Leader>wp', ':setlocal wrap!<CR>', {
  desc = 'Toggle line wrapping',
})

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
vim.keymap.set('v', '<', '<gv', {
  desc = 'Shift block left while retaining selection',
})
vim.keymap.set('v', '>', '>gv', {
  desc = 'Shift block right while retaining selection',
})

-- Insert horizontal ellipsis in insert mode
vim.keymap.set('i', '\\...', '…')

-- Toggle local spelling
vim.keymap.set('n', '<Leader>pl', 'setlocal spell!')

-- Open the quickfix window for the buffer
vim.keymap.set('n', '<Leader>fl', vim.diagnostic.setqflist, {
  desc = 'Open the quickfix list for the buffer',
})

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

vim.keymap.set('n', '<Leader>acd',
  function()
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
  end,
  { desc = 'Toggle autochdir automagically' }
)

vim.keymap.set('n', '<Leader>cd',
  function()
    local _targetPath = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    _workingDirectoryVimWasOpenedFrom = _targetPath
    vim.cmd(string.format('cd! %s', _targetPath))
    print(string.format('set cwd to %s', _targetPath))
  end,
  { desc = 'Set working directory to the directory of the focused buffer' }
)

-- Insert a long-ish paragraph of hipster ipsum
vim.keymap.set('n', '<Leader>hi',
  function()
    local ipsum = vim.fn.system('curl -s "https://hipsum.co/api/?type=hipster-centric&sentences=5" | jq -r ".[]"')
    vim.fn.execute(string.format('normal! i%s', ipsum))
    vim.fn.execute('normal! kgqqj')
  end,
  { desc = 'Insert a paragraph of hipster ipsum' }
)
-- }}}
