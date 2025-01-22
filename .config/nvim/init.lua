-- Local functions {{{
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function update_hl(group, tbl)
  local old_hl = vim.api.nvim_get_hl_by_name(group, true)
  local new_hl = vim.tbl_extend('force', old_hl, tbl)
  vim.api.nvim_set_hl(0, group, new_hl)
end

local function set_colorscheme(colorscheme)
  vim.cmd.colorscheme(colorscheme)
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
end

-- Define a function to conditionally import a module by absolute path
local function require_module_by_path(module_path)
  local status, module = pcall(dofile, module_path)
  if status then
    return module
  else
    return nil
  end
end
-- }}}

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
vim.g.mapleader = ","

require("lazy").setup(
-- Plugins {{{
  {
    -- Editor & GUI Improvements {{{
    "mhinz/vim-startify",
    "djoshea/vim-autoread",
    "gpanders/editorconfig.nvim", -- supposedly, nvim supports editorconfig natively, but I cannot get it to work _just_ right
    "nvim-tree/nvim-web-devicons",
    {
      "seanbreckenridge/yadm-git.vim",
      dependencies = {
        "tpope/vim-fugitive",
        "mhinz/vim-startify",
      },
      -- If neovim is opened in the home directory OR a file tracked by YADM,
      -- scope all Telescope operations to YADM files, as that's what I probably
      -- want.
      config = function()
        local yadm_files = vim.fn.systemlist(
          "yadm list | awk '!/\\.local\\/share\\/dots/ {print ENVIRON[\"HOME\"] \"/\" $0}'")
        local yadm_telescope_mappings = function()
          local telescope = require("telescope.builtin")
          local yadm_file_search = function()
            return telescope.find_files({
              search_dirs = yadm_files,
            })
          end
          local yadm_live_grep = function()
            return telescope.live_grep({
              search_dirs = yadm_files,
            })
          end

          vim.keymap.set('n', '<c-p>', yadm_file_search, {
            buffer = true,
            desc = "Telescope: yadm scoped fuzzy find files",
          })
          vim.keymap.set('n', '<leader>ff', yadm_file_search, {
            buffer = true,
            desc = "Telescope: yadm scoped fuzzy find files",
          })
          vim.keymap.set('n', '<leader>fg', yadm_live_grep, {
            buffer = true,
            desc = "Telescope: yadm scoped live grep",
          })
        end

        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = yadm_files,
          callback = yadm_telescope_mappings,
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "startify",
          callback = function()
            if vim.loop.cwd() == vim.fn.expand('~') then
              yadm_telescope_mappings()
            end
          end,
        })
      end,
    },
    {
      "RRethy/nvim-base16",
      lazy = false,
      config = function()
        local local_base16_theme = require_module_by_path(vim.fn.expand("~/.local/share/base16-theme.lua"))

        if local_base16_theme then
          set_colorscheme(local_base16_theme.neovim)
        else
          set_colorscheme("base16-default-dark")
        end

        vim.api.nvim_create_autocmd("FocusGained", {
          pattern = "*",
          callback = function()
            local updated_theme = require_module_by_path(vim.fn.expand("~/.local/share/base16-theme.lua"))

            if updated_theme and updated_theme.neovim ~= vim.g.colors_name then
              set_colorscheme(updated_theme.neovim)
            end
          end,
          desc = "base16: Update colorscheme if the terminal's theme has changed"
        })
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      tag = "release",
      config = true,
    },
    {
      "nvim-lualine/lualine.nvim",
      config = true,
      opts = { theme = "base16" },
    },
    {
      "nvim-tree/nvim-tree.lua",
      tag = "nightly",
      cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse" },
      keys = {
        { "<leader>nt", "<cmd>NvimTreeToggle<CR>", mode = "n", desc = "nvim-tree: toggle" },
      },
      config = function(plugin, opts)
        require('nvim-tree').setup(opts)

        update_hl('NvimTreeSpecialFile', { underline = false })
      end,
      opts = {
        view = {
          mappings = {
            list = {
              { key = "u", action = "dir_up" },
              { key = "s", action = "split" },
              { key = "v", action = "vsplit" },
              { key = "t", action = "tabnew" },
              { key = "x", action = "close_node" },
              { key = "r", action = "refresh" },
              { key = "R", action = "rename" },
              { key = "c", action = "cd" },
            },
          },
        },
      },
    },
    {
      "lambdalisue/suda.vim",
      event = "FileChangedRO",
      init = function()
        vim.api.nvim_create_autocmd("FileChangedRO", {
          pattern = "*",
          command = "nnoremap <buffer> <Leader>s :w suda://%<CR>",
          desc = "Use SudoWrite on read only files",
        })
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup()

        -- Make cmp work with nvim-autopairs
        -- https://github.com/windwp/nvim-autopairs/blob/ae5b41ce880a6d850055e262d6dfebd362bb276e/README.md#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo
        local cmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
    {
      "kevinhwang91/nvim-fundo", -- Better persistent undo
      config = function()
        require('fundo').install()
      end,
    },
    -- }}}
    -- Searching {{{
    {
      "bronson/vim-visual-star-search",
      keys = { { "*", mode = "v" }, { "#", mode = "v" } },
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      cmd = { "Telescope" },
      keys = function()
        local builtin = require("telescope.builtin")
        return {
          { "<c-p>",      builtin.find_files,  mode = "n", desc = "telescope: Fuzzy find files" },
          { "<leader>ff", builtin.find_files,  mode = "n", desc = "telescope: Fuzzy find files" },
          { "<leader>fg", builtin.live_grep,   mode = "n", desc = "telescope: Live grep" },
          { "<leader>fb", builtin.buffers,     mode = "n", desc = "telescope: Browse buffers" },
          { "<leader>fh", builtin.help_tags,   mode = "n", desc = "telescope: Browse help" },
          { "<leader>ft", builtin.treesitter,  mode = "n", desc = "telescope: Browse Treesitter" },
          { "<leader>td", builtin.diagnostics, mode = "n", desc = "telescope: Diagnostics (quickfix list)" },
        }
      end,
    },
    {
      "debugloop/telescope-undo.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      keys = {
        { "<leader>ut", "<cmd>Telescope undo<CR>", mode = "n", desc = "telescope: Undotree" },
      },
      config = function()
        require("telescope").load_extension("undo")
      end,
    },
    {
      "piersolenski/telescope-import.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      keys = {
        { "<leader>fi", "<cmd>Telescope import<CR>", mode = "n", desc = "telescope: Find and insert imports" },
      },
      config = function()
        require("telescope").load_extension("import")
      end,
    },
    {
      "nvim-pack/nvim-spectre",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = true,
      cmd = { "Spectre" },
      keys = {
        { "<leader>fs", '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre (find and replace pane)" },
      },
    },
    -- }}}
    -- Treesitter (syntax highlighting and so much more) {{{
    {
      "nvim-treesitter/nvim-treesitter",
      build = function()
        vim.cmd(":TSUpdate")
      end,
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {},
          modules = {},
          ignore_install = {},
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
            disable = { 'lua' },
            additional_vim_regex_highlighting = false,
          },
          disable = {
            "startify",
          },
          indent = {
            enable = true,
          }
        })
      end,
    },
    {
      "windwp/nvim-ts-autotag",
      dependencies = {},
      config = true,
      ft = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "rescript",
        "xml",
        "php",
        -- "markdown",
        "astro",
        "glimmer",
        "handlebars",
        "hbs",
      },
    },
    -- }}}
    -- IDE Features (LSP, autocompletion, formatting & linting) {{{
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        {
          "williamboman/mason.nvim",
          config = true,
          opts = { max_concurrent_installers = 10 },
          build = function()
            local ensure_installed = {
              'astro-language-server',
              'bash-language-server',
              'css-lsp',
              'dockerfile-language-server',
              'efm',
              'eslint-lsp',
              'fixjson',
              'goimports',
              'gopls',
              'html-lsp',
              'intelephense',
              'json-lsp',
              'lua-language-server',
              'prettier',
              'pyright',
              'shellcheck',
              'stylelint',
              'tailwindcss-language-server',
              'taplo',
              'typescript-language-server',
              'vim-language-server',
              'write-good',
              'yaml-language-server',
              'yamllint',
            }

            vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
          end,
        },
        {
          "williamboman/mason-lspconfig.nvim",
          config = true,
          opts = {
            automatic_install = true,
            ensure_installed = {
              "astro",
              "bashls",
              "cssls",
              "efm",
              "gopls",
              "html",
              "intelephense", -- PHP
              "jsonls",
              "lua_ls",
              "taplo", -- TOML
              "ts_ls", -- Typescript / tsserver
              "vimls",
              "yamlls",
            },
          },
        },
        {
          "lukas-reineke/lsp-format.nvim",
          config = true,
        },
        {
          "Fildo7525/pretty_hover",
          event = "LspAttach",
          opts = {}
        },
        {
          "mattn/efm-langserver",
          dependencies = {
            {
              'creativenull/efmls-configs-nvim',
              version = 'v0.2.x',
            },
          },
        },
      },
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        local lsp_format = require("lsp-format")
        local mason_lsp = require("mason-lspconfig")
        local lsp_formatting = function(bufnr, isAsync)
          vim.lsp.buf.format({
            async = isAsync,
            bufnr = bufnr,
          })
        end
        local lsp_formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        local on_attach = function(client, bufnr)
          -- Disables really 💩 syntax highlighting, Treesitter is so much
          -- better
          client.server_capabilities.semanticTokensProvider = nil

          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = lsp_formatting_augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = lsp_formatting_augroup,
              buffer = bufnr,
              callback = function()
                lsp_formatting(bufnr, false)
              end,
            })
          end

          lsp_format.on_attach(client)

          -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
          vim.keymap.set("n", "gd", vim.lsp.buf.type_definition)
          vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action)
          vim.keymap.set("n", "<Leader>d", vim.lsp.buf.definition)
          -- vim.keymap.set('n', '<Leader>p', function() lsp_formatting(_opts.bufnr, true) end, _opts)
          vim.keymap.set("n", "<Leader>RN", vim.lsp.buf.rename)
          vim.keymap.set("n", "K", vim.lsp.buf.hover)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation)
          vim.keymap.set("n", "gR", vim.lsp.buf.references)
        end

        mason_lsp.setup_handlers({
          -- The first entry (without a key) will be the default handler
          -- and will be called for each installed server that doesn't have
          -- a dedicated handler.
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              on_attach = on_attach,
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                  },
                  diagnostics = {
                    globals = { "vim" },
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
            })
          end,
          ["tailwindcss"] = function()
            lspconfig.tailwindcss.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                tailwindCSS = {
                  classAttributes = { "class", "className", "classNames", "ngClass", "class:list" },
                },
              },
            })
          end,
          ["efm"] = function()
            local eslint = require 'efmls-configs.linters.eslint'
            local gofmt = require 'efmls-configs.formatters.gofmt'
            local goimports = require 'efmls-configs.formatters.goimports'
            local prettier = require 'efmls-configs.formatters.prettier'
            local shellcheck = require 'efmls-configs.linters.shellcheck'
            local stylelint = require 'efmls-configs.linters.stylelint'
            local write_good = require 'efmls-configs.linters.write_good'
            local yamllint = require 'efmls-configs.linters.yamllint'

            local efm_filetypes = {}
            local efm_languages = {
              astro = { prettier, eslint },
              css = { prettier, stylelint },
              go = { gofmt, goimports },
              html = { prettier },
              javascript = { prettier, eslint },
              javascriptreact = { prettier, eslint },
              json = { prettier },
              jsonc = { prettier },
              less = { prettier, stylelint },
              -- markdown = { write_good, prettier },
              sass = { prettier, stylelint },
              scss = { prettier, stylelint },
              sh = { shellcheck },
              typescript = { prettier, eslint },
              typescriptreact = { prettier, eslint },
              yaml = { yamllint, prettier },
              zsh = { shellcheck },
            }

            local n = 0
            for k, _ in pairs(efm_languages) do
              n = n + 1
              efm_filetypes[n] = k
            end

            lspconfig.efm.setup({
              init_options = { documentFormatting = true },
              filetypes = efm_filetypes,
              settings = {
                rootMarkers = { ".git/" },
                languages = efm_languages,
              },
            })
          end,
        })
      end,
    },
    {
      "ivanjermakov/troublesum.nvim",
      event = 'DiagnosticChanged',
      config = true,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "onsails/lspkind.nvim",
        {
          "uga-rosa/cmp-dictionary",
          build =
          "mkdir -pf $HOME/.local/share/nvim/dict && aspell -d en dump master | aspell -l en expand > $HOME/.local/share/nvim/dict/en.dict",
          config = true,
          opts = {
            paths = { vim.fn.expand("$HOME/.local/share/nvim/dict/en.dict") }
          },
        },
        {
          "saadparwaiz1/cmp_luasnip",
          dependencies = { "L3MON4D3/LuaSnip" },
        },
        {
          "dcampos/cmp-emmet-vim",
          keys = {
            {
              "<c-y>",
              mode = "i",
              desc = "Emmet expansion in insert mode (you probably need to type `<c-y>,`)",
            },
          },
          dependencies = {
            {
              "mattn/emmet-vim",
              config = function()
                -- expand emmet snippet with <c-y>,
                vim.g.user_emmet_leader_key = "<C-y>"
              end,
            },
          },
        },
        -- Pressing <CR> on a Copilot suggestion will expand it
        {
          "zbirenbaum/copilot-cmp",
          config = true,
          dependencies = {
            {
              "zbirenbaum/copilot.lua",
              config = true,
              opts = {
                suggestion = { enabled = false },
                panel = { enabled = false },
              },
            },
          },
        },
        {
          "roobert/tailwindcss-colorizer-cmp.nvim",
          config = true,
          opts = { color_square_width = 2 },
        }
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- vim setting to make this all work
        vim.opt.completeopt = "menu,menuone,noselect"

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
            ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
            ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<C-s>"] = cmp.mapping.complete({
              config = {
                sources = {
                  { name = "copilot" },
                },
              },
            }),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            }),
          }),
          formatting = {
            format = lspkind.cmp_format({
              mode = "symbol",
              maxwidth = 50,
              ellipsis_char = "…",
              symbol_map = {
                Copilot = "",
                Dictionary = "📗",
              },
            }),
          },
          sources = cmp.config.sources({
            {
              name = "copilot",
              -- group_index = 1,
              priority = 10,
            },
            {
              name = "nvim_lsp",
              -- group_index = 1,
              priority = 9,
            },
            {
              name = "buffer",
              -- group_index = 3,
              priority = 7,
            },
            {
              name = "path",
              -- group_index = 6,
              priority = 2,
            },
            {
              name = "emmet_vim",
              group_index = 5,
              priority = 2,
            },
            {
              name = "dictionary",
              keyword_length = 2,
              max_item_count = 3,
              group_index = 3,
              priority = 3,
            },
            {
              name = "luasnip",
              group_index = 4,
              priority = 4,
            },
          }),
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" },
          },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path",    group_index = 1 },
            { name = "cmdline", group_index = 2 },
          }),
        })

        -- Preview tailwind colors in code completion
        cmp.config.formatting = {
          format = require("tailwindcss-colorizer-cmp").formatter
        }
      end,
    },
    -- }}}
    -- 🤖 AI {{{
    {
      "robitx/gp.nvim",
      config = true,
      opts = function()
        local chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats"
        local image_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_images"

        if vim.fn.isdirectory(vim.fn.expand("~/Dropbox/nvim/gp.nvim")) == 1 then
          chat_dir = vim.fn.expand("~/Dropbox/nvim/gp.nvim/chats")
          image_dir = vim.fn.expand("~/Dropbox/nvim/gp.nvim/images")
        end

        return {
          openai_api_key = { "pass", "Dev/openai.com/gp.nvim-api-key" },
          providers = {
            openai = {
              secret = { "pass", "Dev/openai.com/gp.nvim-api-key" },
            },
            anthropic = {
              secret = { "pass", "Dev/anthropic.com/api-key" }
            },
          },
          chat_dir = chat_dir,
          image = {
            store_dir = image_dir,
          },
          agents = {
            { name = "ChatGPT3-5",     disable = true },
            { name = "ChatGPT4o-mini", disable = true },
          },
        }
      end,
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false,
      opts = {
        provider = "claude",
        behaviour = {
          auto_suggestions = false,
        },
      },
      build = "make",
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick",         -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",              -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",        -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
    -- }}}
    -- Commenting {{{
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        require('ts_context_commentstring').setup()
        vim.g.skip_ts_context_commentstring_module = true
      end,
    },
    {
      "numToStr/Comment.nvim",
      keys = {
        { "gcc", mode = { "n", "v" }, desc = "Comment.nvim: Line-comment toggle" },
        { "gbc", mode = { "n", "v" }, desc = "Comment.nvim: Block-comment toggle keymap" },
        { "gc",  mode = { "n", "v" }, desc = "Comment.nvim: Line-comment keymap" },
        { "gb",  mode = { "n", "v" }, desc = "Comment.nvim: Block-comment keymap" },
        { "gcO", mode = { "n", "v" }, desc = "Comment.nvim: Add comment on the line above" },
        { "gco", mode = { "n", "v" }, desc = "Comment.nvim: Add comment on the line below" },
        { "gcA", mode = { "n", "v" }, desc = "Comment.nvim: Add comment at the end of line" },
      },
      config = true,
      opts = {
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
          ---Line-comment toggle keymap
          line = "gcc",
          ---Block-comment toggle keymap
          block = "gbc",
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap
          line = "gc",
          ---Block-comment keymap
          block = "gb",
        },
        ---LHS of extra mappings
        extra = {
          ---Add comment on the line above
          above = "gcO",
          ---Add comment on the line below
          below = "gco",
          ---Add comment at the end of line
          eol = "gcA",
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
        },
      },
    },
    -- }}}
    -- Vim God Tim Pope {{{
    {
      "tpope/vim-dadbod",
      ft = "sql",
      cmd = "DB",
      config = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "sql",
          callback = function()
            vim.keymap.set("n", "<Leader>e", ":%DB g:auto<CR>", { buffer = true })
            vim.keymap.set("v", "<Leader>e", ":'<,'>DB g:auto<CR>", { buffer = true })
          end,
          desc = "<Leader>e will execute the current sql with vim-dadbod against DB g:auto",
        })
      end,
    },
    "tpope/vim-dispatch",
    "tpope/vim-dotenv",
    {
      "tpope/vim-eunuch",
      cmd = {
        "Rename",
        "Remove",
        "Delete",
        "Move",
        "Chmod",
        "Mkdir",
        "Cfind",
        "Clocate",
        "Lfind",
        "Llocate",
        "SudoWrite",
        "SudoEdit",
      },
    },
    {
      "tpope/vim-fugitive",
      cmd = "Git",
      keys = {
        { "<leader>gs", "<cmd>Git<CR>",       mode = "n", desc = "Git status" },
        { "<leader>gb", "<cmd>Git blame<CR>", mode = "n", desc = "Git blame" },
        { "<leader>gp", "<cmd>Git pushy<CR>", mode = "n", desc = "Git pushy" },
      },
      init = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "gitcommit",
          callback = function()
            vim.keymap.set("n", "<Leader>s", ":wq<CR>", { buffer = true })
          end,
          desc = "My normal save shortcut will write the commit",
        })
      end,
    },
    {
      "tpope/vim-surround",
      dependencies = {
        "tpope/vim-repeat",
      },
      keys = {
        { "cs", desc = "vim-surround: change surrouding delimiter" },
        { "ds", desc = "vim-surround: delete surrouding delimiter" },
        { "ys", desc = "vim-surround: add surrouding delimiter" },
        { "S",  desc = "vim-surround: add delimiter to selection", mode = "v" },
      },
    },
    {
      "tpope/vim-tbone",
      cmd = { "Tmux", "Twrite", "Tattach", "Tynak", "Tput" },
      keys = {
        { "<leader>ty", "<cmd>Tyank<CR>", mode = "n",          desc = "tbone: Yank line into tmux buffer" },
        {
          "<leader>ty",
          "<cmd>'<,'>Tyank<CR>",
          mode = "v",
          desc = "tbone: Yank selection into tmux buffer",
        },
        { "<leader>tp", "<cmd>Tput<CR>",  mode = { "n", "v" }, desc = "tbone: Paste text from tmux buffer" },
      },
    },
    -- }}}
    -- Github {{{
    {
      "mattn/vim-gist",
      dependencies = { "mattn/webapi-vim" },
      cmd = "Gist",
    },
    {
      "tyru/open-browser.vim",
      cmd = { "OpenBrowser", "OpenBrowserSearch" },
      keys = {
        {
          '<leader>os',
          '<Plug>(openbrowser-search)',
          mode = { "n", "v" },
          desc = "open-browser-github.vim: search text in web browser"
        },
        {
          'gx',
          '<Plug>(openbrowser-search)',
          mode = { "n", "v" },
          desc = "open-browser-github.vim: search text in web browser"
        },
      },
    },
    {
      "tyru/open-browser-github.vim",
      dependencies = { "tyru/open-browser.vim" },
      cmd = { "OpenGithubFile", "OpenGithubIssue", "OpenGithubPullReq", "OpenGithubProject" },
    },
    -- }}}
    -- HTTP Client {{{
    {
      "rest-nvim/rest.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      tag = "v1.1.0",
      ft = "http",
      config = function()
        require("rest-nvim").setup({
          result_split_horizontal = true,
          encode_url = true,
          result = {
            show_url = true,
            skip_ssl_verification = true,
            show_http_info = true,
            show_headers = true,
            formatters = {
              json = "jq",
              html = false,
            },
          },
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = "http",
          callback = function()
            vim.keymap.set("n", "<Leader>e", "<Plug>RestNvim", { buffer = true })
          end,
          desc = "<Leader>e will execute the current file with rest.nvim",
        })
      end,
    },
    -- }}}
    -- Syntax Highlighting {{{
    {
      "norcalli/nvim-colorizer.lua",
      ft = {
        "css",
        "less",
        "scss",
        "sass",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      config = function(self)
        require("colorizer").setup(self.ft, {
          css = true,
          css_fn = true,
        })
      end,
    },
    { "fourjay/vim-password-store", ft = "pass" },
    -- }}}
  }
-- }}}
)
-- }}}

-- File handling {{{
-- Gotta have these
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Set default line endings as Unix
vim.g.fileformat = "unix"
vim.opt.fileformats = "unix,dos,mac"

-- 😍 ❤️ UTF-8
vim.g.encoding = "utf-8"
vim.g.fileencoding = "utf-8"
vim.g.bomb = false

-- Read files if they change outside of Vim
vim.opt.autoread = true

-- Indenting
-- Most of these should be overridden by Editorconfig
vim.opt.tabstop = 2         -- I like my tabs to seem like two spaces
vim.opt.shiftwidth = 2      -- I'd also like to shift lines the same amount of spaces
vim.opt.softtabstop = 2     -- If using expandtab for some reason, use two spaces
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
vim.opt.undolevels = 10000
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
vim.opt.magic = true     -- Do You Believe In (Perl) Magic?
vim.opt.gdefault = true  -- Use global by default when replacing

if vim.fn.exists('shellslash') == 1 then
  vim.opt.shellslash = true -- When in Windows, you can use / instead of \
end

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
vim.opt.backspace = "indent,eol,start"

-- Don't use more than one space after punctuation
vim.opt.joinspaces = false

-- Folding
vim.opt.foldenable = false
vim.opt.foldmethod = "manual"

-- I don't need Vim telling me where I can't go!
vim.opt.virtualedit = "all"

-- Enable the mouse in the default modes
-- I'm done being an anti-mouse zealot
vim.opt.mouse = "nvi"

-- Hide mouse when typing
vim.opt.mousehide = true

-- Make searching blazing fast
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --color=never"
  vim.opt.grepformat = "%f:%l:%c:%m"
  vim.g.ackprg = "rg --vimgrep"
elseif vim.fn.executable("ag") then
  vim.opt.grepprg = "ag --vimgrep $*"
  vim.opt.grepformat = "%f:%l:%c:%m"
  vim.g.ackprg = "ag --vimgrep"
end
-- }}}

-- autocmds {{{
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = ':%s/\\s\\+$//e',
  desc = 'Remove trailing whitespace when saving files'
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste paste?",
  desc = "Exit paste mode upon leaving insert",
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    vim.cmd(t("normal! <C-w>="))
  end,
  desc = "Resize splits as vim is resized",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "text" },
  command = "setlocal spell",
  desc = "Only enable spell checking in some files",
})

local crosshairAugroup = vim.api.nvim_create_augroup("BufferCrosshair", {})
vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  group = crosshairAugroup,
  callback = function()
    vim.opt.cursorline = false
    vim.opt.colorcolumn = ""
  end,
  desc = "Window crosshair: Remove cursorline and colorcolumn when buffer loses focus",
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "BufNewFile" }, {
  pattern = "*",
  group = crosshairAugroup,
  callback = function()
    vim.opt.cursorline = true
    vim.opt.colorcolumn = "+1"
  end,
  desc = "Window crosshair: Restore cursorline and colorcolumn when buffer gains focus",
})
-- }}}

-- Theme {{{
-- I Think It's Beautiful That Your Are 256 Colors Too
-- https://www.youtube.com/watch?v=bZ6b5ghZZN0
vim.cmd("set t_Co=256")     -- 256 color support in terminal
vim.opt.termguicolors = true
vim.opt.background = "dark" -- I like a dark background

-- Don't make my terminal less transparent
-- NormalNC targets unfocused splits
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
  end,
  desc = "Maintain terminal transparency",
})

-- Make most comments italic
update_hl("Comment", { italic = true })

-- Override some treesitter/default styles
-- Use `:Inspect` to see the group under the cursor is
update_hl('TSVariable', { link = 'TSText' })
update_hl('TSTypeBuiltin', { link = 'TSType' })
update_hl('TSVariableBuiltin', { italic = false })
update_hl('TSFuncBuiltin', { italic = false })
update_hl('PreProc', { italic = false })
update_hl('@comment.gitcommit', { italic = false })
update_hl('@property.tsx', { link = 'TSLabel' })
-- }}}

-- Look & Feel {{{
-- Word Wrap
vim.opt.wrap = false             -- I like scrolling off the screen
vim.opt.textwidth = 80           -- Standard width for terminals
vim.opt.formatoptions = "oqn1tc" -- Check out 'fo-table' to see what this does.

-- Status bar
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.showmode = false -- Powerline shows mode now


-- Avante likes the status bar to clear out lualine
vim.opt.cmdheight = 2
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Avante*" },
  callback = function()
    vim.opt_local.laststatus = 3
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
vim.opt.listchars = "tab:▸∙,eol:␤,trail:∘"
vim.keymap.set("n", "<Leader>ll", ":setlocal list!<CR>", {
  desc = "Toggle list chars",
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

-- Default cursor to block, but change to bar in insert mode
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

local _numberingMode = 0
local function numberingCycle(silent)
  if _numberingMode == 0 then
    vim.opt.number = true
    vim.opt.relativenumber = true
    _numberingMode = _numberingMode + 1
    if not silent then
      print("Hybrid number line!")
    end
    return
  elseif _numberingMode == 1 then
    vim.opt.number = true
    vim.opt.relativenumber = false
    _numberingMode = _numberingMode + 1
    if not silent then
      print("Normal number line!")
    end
    return
  else
    vim.opt.number = false
    vim.opt.relativenumber = false
    _numberingMode = 0
    if not silent then
      print("No number line!")
    end
    return
  end
end

numberingCycle(true)

vim.keymap.set("n", "<Leader>rn", numberingCycle, {
  desc = "Cycle through relative and number, just number, no numbers",
})
--}}}

-- Keyboard shortcuts {{{
-- Window Navigation
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", {
  desc = "Navigate to window left",
  silent = true,
})
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", {
  desc = "Navigate to window below",
  silent = true,
})
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", {
  desc = "Navigate to window above",
  silent = true,
})
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", {
  desc = "Navigate to window right",
  silent = true,
})

-- Window Resizing
vim.keymap.set("n", "<C-Up>", ":resize +1<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -1<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>")
vim.keymap.set("n", "<Leader>ee", ":wincmd =<CR>")

-- Alternate increment mappings for screen and tmux
vim.keymap.set("n", "+", "<C-a>", {
  desc = "Increment number under cursor",
})
vim.keymap.set("n", "-", "<C-x>", {
  desc = "Decrement number under cursor",
})

-- Easier line jumping
vim.keymap.set({ "n", "v" }, "H", "^", {
  desc = "Move to beginning of line",
})
vim.keymap.set({ "n", "v" }, "L", "$", {
  desc = "Move to end of line",
})

vim.keymap.set("n", "<Leader><Leader>", ":nohlsearch<CR>", {
  desc = "Toggle search highlighting",
})

vim.keymap.set("n", "<Leader>ve", function()
  if vim.opt.virtualedit == "all" then
    vim.opt.virtualedit = "onemore"
  else
    vim.opt.virtualedit = "all"
  end
end, { desc = "Toggle virtual editing" })

-- Toggle arrow keys
local _arrowKeysEnabled = true

local function toggleArrowKeys(silent)
  _arrowKeysEnabled = not _arrowKeysEnabled
  vim.keymap.set("n", "<Up>", _arrowKeysEnabled and "k" or ":resize +5<cr>")
  vim.keymap.set("n", "<Down>", _arrowKeysEnabled and "j" or ":resize -5<cr>")
  vim.keymap.set("n", "<Left>", _arrowKeysEnabled and "h" or ":vertical resize +5<cr>")
  vim.keymap.set("n", "<Right>", _arrowKeysEnabled and "l" or ":vertical resize -5<cr>")
  vim.keymap.set("i", "<Up>", _arrowKeysEnabled and "<Up>" or "<Nop>")
  vim.keymap.set("i", "<Down>", _arrowKeysEnabled and "<Down>" or "<Nop>")
  vim.keymap.set("i", "<Left>", _arrowKeysEnabled and "<Left>" or "<Nop>")
  vim.keymap.set("i", "<Right>", _arrowKeysEnabled and "<Right>" or "<Nop>")

  if not silent then
    print(_arrowKeysEnabled and "Arrow Keys Enabled" or "Arrow Keys Disabled")
  end
end

toggleArrowKeys(true)

vim.keymap.set("n", "<Leader>ak", toggleArrowKeys, {
  desc = "Toggle arrow keys for weaklings trying to use my vim",
})

-- Map <Esc> to my right hand
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "JJ", "<Esc>")

-- Easy paste toggling
vim.keymap.set("n", "<Leader>pt", ":set paste! paste?<CR>")

-- Yank should work just like every other Vim verb
vim.keymap.set("n", "Y", "y$", {
  desc = "Yank to end of line",
})

-- D yanks to end of line like every other Vim verb
vim.keymap.set("n", "D", "d$", {
  desc = "Delete to end of line",
})

-- Undo/redo now make sense
vim.keymap.set("n", "U", ":redo<CR>")

-- Don't unindent with hash symbol
vim.keymap.set("n", "#", "#")

-- Yank lines to system clipboard in visual
vim.keymap.set("v", "<Leader>Y", '"+y', {
  desc = "Yank lines to system clipboard",
})

-- Jump between bracket pairs easily
-- Not using remap so I can use matchit
vim.keymap.set({ "n", "v" }, "<Tab>", "%", {
  remap = true,
  desc = "Jump between matching pairs",
})

-- Faster and more satisfying command mode access
vim.keymap.set({ "n", "v" }, "<Space>", ":", {
  desc = "Smack the space bar as hard as you can to enter command mode",
})

-- Toggle local line wrapping
vim.keymap.set("n", "<Leader>wp", ":setlocal wrap!<CR>", {
  desc = "Toggle line wrapping",
})

-- Saving & Quiting Shortcuts
vim.keymap.set("n", "<Leader>s", ":write<CR>")
vim.keymap.set("n", "<Leader>qa", ":qall<CR>")
vim.keymap.set("n", "<Leader>qq", ":quit<CR>")
vim.keymap.set("n", "<Leader>tt", ":tabnew<CR>")
vim.keymap.set("n", "<Leader>tc", ":tabclose<CR>")

-- Sane movement
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "gj", "j")
vim.keymap.set("n", "gk", "k")

-- Shift blocks visually in visual mode and retain the selection
vim.keymap.set("v", "<", "<gv", {
  desc = "Shift block left while retaining selection",
})
vim.keymap.set("v", ">", ">gv", {
  desc = "Shift block right while retaining selection",
})

-- Insert horizontal ellipsis in insert mode
vim.keymap.set("i", "\\...", "…")

-- Insert plus-minus in insert mode
vim.keymap.set("i", "\\+-", "±")

-- Toggle local spelling
vim.keymap.set("n", "<Leader>pl", "setlocal spell!")

-- Open the quickfix window for the buffer
vim.keymap.set("n", "<Leader>fl", vim.diagnostic.setqflist, {
  desc = "Open the quickfix list for the buffer",
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

vim.keymap.set("n", "<Leader>acd", function()
  _acd = not _acd

  if _acd then
    vim.opt.autochdir = _acd
    local _targetPath = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    vim.api.nvim_set_current_dir(_targetPath)
    print(string.format("turned on autochdir and set cwd to %s", _targetPath))
  else
    vim.opt.autochdir = _acd
    vim.api.nvim_set_current_dir(_workingDirectoryVimWasOpenedFrom)
    print(string.format("turned off autochdir and set cwd to %s", _workingDirectoryVimWasOpenedFrom))
  end
end, { desc = "Toggle autochdir automagically" })

vim.keymap.set("n", "<Leader>cd", function()
  local _targetPath = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  _workingDirectoryVimWasOpenedFrom = _targetPath
  vim.cmd(string.format("cd! %s", _targetPath))
  print(string.format("set cwd to %s", _targetPath))
end, { desc = "Set working directory to the directory of the focused buffer" })

-- Insert a long-ish paragraph of hipster ipsum
vim.keymap.set("n", "<Leader>hi", function()
  local ipsum = vim.fn.system('curl -s "https://hipsum.co/api/?type=hipster-centric&sentences=5" | jq -r ".[]"')
  vim.fn.execute(string.format("normal! i%s", ipsum))
  vim.fn.execute("normal! kgqqj")
end, { desc = "Insert a paragraph of hipster ipsum" })
-- }}}
