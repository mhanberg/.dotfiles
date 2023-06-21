local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
    :wait()
end
vim.opt.rtp:prepend(lazypath)

local fzf = function(func)
  return function(...)
    return require("fzf-lua")[func](...)
  end
end

require("lazy").setup({
  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    config = function()
      require("output_panel").setup()
    end,
    keys = {
      {
        "<leader>o",
        vim.cmd.OutputPanel,
        mode = "n",
        desc = "Toggle the output panel",
      },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevelstart = 99
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldmethod = "expr"
      vim.opt.mousemodel = "extend"
      vim.opt.fillchars:append {
        foldopen = "",
        foldsep = " ",
        foldclose = "",
      }
    end,
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup {
        setopt = true,
        foldfunc = "builtin",
        segments = {
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          { text = { builtin.foldfunc, " " }, condition = { true, builtin.not_empty }, click = "v:lua.ScFa" },
        },
      }
    end,
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
  },
  {
    "mhanberg/zk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "markdown", "liquid" },
      on_attach = function(_client, bufnr)
        local opts = function(tbl)
          return vim.tbl_extend("keep", { buffer = bufnr, silent = true }, tbl)
        end

        vim.keymap.set("n", "<space>zf", vim.cmd.Notes, opts { desc = "Find notes" })
        vim.keymap.set("n", "<space>zt", vim.cmd.Tags, opts { desc = "Find tags" })
        vim.keymap.set("n", "<space>zl", vim.cmd.Links, opts { desc = "Find links in note" })
        vim.keymap.set("n", "<space>zb", vim.cmd.Backlinks, opts { desc = "Find backlinks in note" })
        vim.keymap.set(
          "n",
          "<space>zd",
          [[:lua require("zk").new({group = "daily", dir = "journal/daily"})<cr>]],
          opts { desc = "New Journal Entry" }
        )
        vim.keymap.set("v", "<space>zn", function()
          vim.lsp.buf.code_action {
            apply = true,
            filter = function(ca)
              return ca.title == [[New note in top directory]]
            end,
          }
        end, opts { desc = "Create and link note from selection" })

        if vim.fn.expand("%:h") == "dnd" then
          require("motch.dnd")
          vim.keymap.set("n", "<A-j>", [[:lua motch.dnd.move_to("previous")<cr>]], opts {})
          vim.keymap.set("n", "<A-k>", [[:lua motch.dnd.move_to("next")<cr>]], opts {})
        end
      end,
    },
    dependencies = {

      "junegunn/fzf",
      "junegunn/fzf.vim",

      "neovim/nvim-lspconfig",
    },
    dev = true,
  },
  { "ruanyl/vim-gh-line", event = { "BufReadPost", "BufNewFile" } },
  { "alvan/vim-closetag", ft = { "html", "liquid", "javascriptreact", "typescriptreact" } },
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" },
  { "christoomey/vim-tmux-runner", event = { "BufReadPost", "BufNewFile" } },
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter",
    init = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
    end,
    config = function()
      local cmp = require("cmp")

      cmp.setup {
        snippet = {
          expand = function(args)
            -- For `vsnip` user.
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<C-y>"] = cmp.mapping.confirm { select = true },
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "vim-dadbod-completion" },
          { name = "spell", keyword_length = 5 },
          -- { name = "rg", keyword_length = 3 },
          -- { name = "buffer", keyword_length = 5 },
          -- { name = "emoji" },
          { name = "path" },
          { name = "git" },
        },
        formatting = {
          format = require("lspkind").cmp_format {
            with_text = true,
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              -- emoji = "[Emoji]",
              spell = "[Spell]",
              path = "[Path]",
              cmdline = "[Cmd]",
            },
          },
        },
      }

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", keyword_length = 2 } }),
      })
    end,
    dependencies = {
      { "hrsh7th/cmp-cmdline", event = { "CmdlineEnter" } },
      "f3fora/cmp-spell",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",

      "onsails/lspkind-nvim",
      {
        "petertriho/cmp-git",
        config = function()
          require("cmp_git").setup()
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
  },
  { "farmergreg/vim-lastplace", event = "VeryLazy" },

  { "edluffy/hologram.nvim", ft = "markdown" },

  -- Lua
  {
    "0oAstro/silicon.lua",
    opts = {
      font = "Hack",
      lineNumber = false,
      padHoriz = 120, -- Horizontal padding
      padVert = 140, -- vertical padding
      bgColor = "#56716F",
      -- bgImage = "/Users/mitchell/Downloads/robert-anasch-u6AQYn1tMSE-unsplash.jpg",
      -- bgImage = "/Users/mitchell/Downloads/engin-akyurt-HEMIBJ8QQuA-unsplash.jpg",
      -- bgImage = "/Users/mitchell/Downloads/sincerely-media-K5OLjMlPe4U-unsplash.jpg",
      -- bgImage = "/Users/mitchell/Downloads/sincerely-media-yHWvPxLadRE-unsplash.jpg",
      shadowBlurRadius = 0,
      theme = "/Users/mitchell/.config/silicon/themes/Everforest Dark.tmTheme",
    },
    keys = {
      {
        "<space>ss",
        function()
          require("silicon").visualise_api {}
        end,
        mode = "v",
        desc = "Take a silicon code snippet",
      },
      {
        "<space>sc",
        function()
          require("silicon").visualise_api { to_clip = true }
        end,
        mode = "v",
        desc = "Take a silicon code snippet into the clipboard",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "folke/noice.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true, -- disable if you use native command line UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = {
          buf_options = { filetype = "vim" },
          border = {
            style = { " ", " ", " ", " ", " ", " ", " ", " " },
          },
        }, -- enable syntax highlighting in the cmdline
        icons = {
          ["/"] = { icon = " " },
          ["?"] = { icon = " " },
          [":"] = { icon = ":", firstc = false },
        },
      },
      messages = {
        backend = "mini",
      },
      notify = {
        backend = "mini",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        message = {
          view = "mini",
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 1,
            col = "50%",
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          filter = { find = "Scanning" },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local actions = require("fzf-lua.actions")
      require("fzf-lua").setup {
        winopts = {
          height = 0.6, -- window height
          width = 0.9,
          row = 0, -- window row position (0=top, 1=bottom)
        },
        actions = {
          files = {
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-x"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-l"] = actions.file_sel_to_ll,
          },
        },
        lsp = {
          symbols = {
            symbol_icons = {
              File = "󰈙",
              Module = "",
              Namespace = "󰦮",
              Package = "",
              Class = "󰆧",
              Method = "󰊕",
              Property = "",
              Field = "",
              Constructor = "",
              Enum = "",
              Interface = "",
              Function = "󰊕",
              Variable = "󰀫",
              Constant = "󰏿",
              String = "",
              Number = "󰎠",
              Boolean = "󰨙",
              Array = "󱡠",
              Object = "",
              Key = "󰌋",
              Null = "󰟢",
              EnumMember = "",
              Struct = "󰆼",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰗴",
            },
          },
        },
      }
    end,
    keys = {
      { "<c-p>", fzf("files"), desc = "Find files" },
      { "<space>p", fzf("git_status"), desc = "Find of changes files" },
      {
        "<space>vp",
        function()
          fzf("files") { cwd = vim.fn.expand("~/.local/share/nvim/lazy") }
        end,
        desc = "Find files of vim plugins",
      },
      -- { "<space>df", "<cmd>Files ~/src/<cr>", desc = "Find files in all projects" },
      { "gl", fzf("blines"), desc = "FZF Buffer Lines" },
      { "<leader>a", fzf("live_grep"), desc = "Search in project" },
      -- { "<space>a", ":GlobalProjectSearch<cr>", desc = "Search in all projects" },
    },
  },

  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup {
        select = {
          backend = {
            -- "telescope",
            "fzf-lua",
          },
        },
      }
    end,
  },
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI" },
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      {
        "kristijanhusak/vim-dadbod-ui",
        init = function()
          vim.g.db_ui_auto_execute_table_helpers = 1
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
  },
  { "nvim-telescope/telescope.nvim", cmd = { "Telescope" } },
  { "tpope/vim-commentary", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-dispatch", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "tpope/vim-projectionist" },
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-vinegar" },
  {
    "vim-test/vim-test",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.keymap.set("n", "<leader>n", vim.cmd.TestNearest, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>f", vim.cmd.TestFile, { desc = "Run test file" })
      vim.keymap.set("n", "<leader>s", vim.cmd.TestSuite, { desc = "Run test suite" })
      vim.keymap.set("n", "<leader>l", vim.cmd.TestLast, { desc = "Run last test" })

      local vim_notify_notfier = function(cmd, exit)
        if exit == 0 then
          vim.notify("Success: " .. cmd, vim.log.levels.INFO)
        else
          vim.notify("Fail: " .. cmd, vim.log.levels.ERROR)
        end
      end
      -- local terminal_notifier_notfier = function(cmd, exit)
      --   local system = vim.fn.system
      --   if exit == 0 then
      --     print("Success!")
      --     system(string.format([[terminal-notifier -title "Neovim" -subtitle "%s" -message "Success!"]], cmd))
      --   else
      --     print("Failure!")
      --     system(string.format([[terminal-notifier -title "Neovim" -subtitle "%s" -message "Fail!"]], cmd))
      --   end
      -- end

      -- vim.g["test#javascript#jest#executable"] = "bin/test"
      vim.g.motch_term_auto_close = true

      vim.g["test#custom_strategies"] = {
        motch = function(cmd)
          local winnr = vim.fn.winnr()
          require("motch.term").open(cmd, winnr, vim_notify_notfier)
        end,
      }
      vim.g["test#strategy"] = "motch"
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      _inline2 = true,
      current_line_blame = true,
      current_line_blame_formatter = "   <author>, <committer_time:%R> • <summary>",
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
        -- map("n", "<leader>hS", gs.stage_buffer)
        -- map("n", "<leader>hu", gs.undo_stage_hunk)
        -- map("n", "<leader>hR", gs.reset_buffer)
        map("n", "<leader>hp", gs.preview_hunk)
        -- map("n", "<leader>hb", function()
        --   gs.blame_line { full = true }
        -- end)
        -- map("n", "<leader>tb", gs.toggle_current_line_blame)
        -- map("n", "<leader>hd", gs.diffthis)
        -- map("n", "<leader>hD", function()
        --   gs.diffthis("~")
        -- end)
        -- map("n", "<leader>td", gs.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.diagnostics.zsh,
          null_ls.builtins.formatting.eslint,
          null_ls.builtins.formatting.pg_format,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.trim_whitespace,
          null_ls.builtins.formatting.trim_newlines,
          {
            name = "redocly",
            method = require("null-ls.methods").internal.DIAGNOSTICS,
            filetypes = { "raml" },
            generator = null_ls.generator {
              command = "redocly",
              args = { "lint", "$FILENAME", "--format", "codeclimate" },
              format = "json",
              to_stdin = false,
              ignore_stderr = true,
              to_temp_file = true,
              on_output = function(params)
                local h = require("null-ls.helpers")
                local severities = {
                  blocker = h.diagnostics.severities.error,
                  critical = h.diagnostics.severities.error,
                  major = h.diagnostics.severities.error,
                  minor = h.diagnostics.severities.warning,
                  info = h.diagnostics.severities.information,
                }
                params.messages = {}
                for _, message in ipairs(params.output) do
                  local col = nil
                  local row = message.location.lines.begin
                  if type(row) == "table" then
                    row = row.line
                    col = row.column
                  end
                  table.insert(params.messages, {
                    row = row,
                    col = col,
                    message = message.description,
                    severity = severities[message.severity],
                    filename = params.bufname,
                  })
                end
                return params.messages
              end,
            },
          },

          {
            name = "asyncapi",
            method = require("null-ls.methods").internal.DIAGNOSTICS,
            filetypes = { "yaml" },
            generator = null_ls.generator {
              command = "asyncapi",
              args = { "validate", "$FILENAME", "--diagnostics-format", "json" },
              format = "json_raw",
              to_stdin = false,
              ignore_stderr = true,
              to_temp_file = true,
              on_output = function(params)
                local h = require("null-ls.helpers")
                local severities = {
                  h.diagnostics.severities.error,
                  h.diagnostics.severities.warning,
                  h.diagnostics.severities.info,
                }
                params.messages = {}
                local output = vim.split(params.output, "\n", { trimempty = true })
                local json = vim.fn.join { unpack(output, 2) }
                for _, message in ipairs(vim.json.decode(json)) do
                  table.insert(params.messages, {
                    row = message.range.start.line + 1,
                    col = message.range.start.character + 1,
                    end_row = message.range["end"].line + 1,
                    end_col = message.range["end"].character + 1,
                    message = message.message,
                    severity = severities[message.severity],
                    filename = params.bufname,
                  })
                end
                return params.messages
              end,
            },
          },
        },
        on_attach = require("motch.lsp").on_attach,
      }
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    name = "indent_blankline",
    init = function()
      vim.opt.list = true
    end,
    opts = {
      viewport_buffer = 100,
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
      use_treesitter = true,
      char = "▎",
      context_char = "▎",
      filetype_exclude = {
        "markdown",
        "terminal",
        "json",
        "lspinfo",
        "packer",
        "checkhealth",
        "help",
        "lazy",
        "",
      },
    },
  },
  { "mg979/vim-visual-multi", branch = "master", event = { "BufReadPost", "BufNewFile" } },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      background = {
        dark = vim.fn.readfile(vim.fn.expand("~/.local/share/mitch/kanagawa.txt"))[1],
        light = "lotus",
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          NoiceCmdlinePopup = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          NoiceCmdlinePopupBorder = { bg = theme.ui.bg_m3, fg = theme.diag.info },
          NoiceCmdlinePopupTitle = { bg = theme.ui.bg_m3, fg = theme.diag.info },
          NoiceCmdlinePopupPrompt = { bg = theme.ui.bg_m3, fg = theme.diag.info },
          NoiceCmdlinePopupBorderSearch = { bg = theme.ui.bg_m3, fg = theme.diag.warning },

          NoiceCmdlineIcon = { bg = theme.ui.bg_m3, fg = theme.diag.info },
          NoiceCmdlineIconSearch = { bg = theme.ui.bg_m3, fg = theme.diag.warning },

          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          NavicIconsFile = { link = "Directory" },
          NavicIconsModule = { link = "TSInclude" },
          NavicIconsNamespace = { link = "TSInclude" },
          NavicIconsPackage = { link = "TSInclude" },
          NavicIconsClass = { link = "Structure" },
          NavicIconsMethod = { link = "Function" },
          NavicIconsProperty = { link = "TSProperty" },
          NavicIconsField = { link = "TSField" },
          NavicIconsConstructor = { link = "@constructor" },
          NavicIconsEnum = { link = "Identifier" },
          NavicIconsInterface = { link = "Type" },
          NavicIconsFunction = { link = "Function" },
          NavicIconsVariable = { link = "@variable" },
          NavicIconsConstant = { link = "Constant" },
          NavicIconsString = { link = "String" },
          NavicIconsNumber = { link = "Number" },
          NavicIconsBoolean = { link = "Boolean" },
          NavicIconsArray = { link = "Type" },
          NavicIconsObject = { link = "Type" },
          NavicIconsKey = { link = "Keyword" },
          NavicIconsNull = { link = "Type" },
          NavicIconsEnumMember = { link = "TSField" },
          NavicIconsStruct = { link = "Structure" },
          NavicIconsEvent = { link = "Structure" },
          NavicIconsOperator = { link = "Operator" },
          NavicIconsTypeParameter = { link = "Identifier" },
          NavicText = { fg = theme.ui.fg },
          NavicSeparator = { fg = theme.ui.fg },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
    end,
  },

  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup {
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1000,
    init = function()
      vim.opt.termguicolors = true

      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_enable_italic = true
      vim.g.everforest_colors_override = {
        -- bg8 = { "#000000", 235 },
        bg0 = { "#273433", "235" },
        bg1 = { "#394C4A", "236" },
        bg2 = { "#425755", "237" },
        bg3 = { "#4B6361", "238" },
        bg4 = { "#56716F", "239" },
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { globalstatus = true, theme = "kanagawa" },
      extensions = { "fzf" },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "selectioncount", "searchcount", "encoding", "fileformat", "filetype" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = "all",
      ignore_install = { "haskell", "phpdoc" },
      highlight = { enable = true },
      indent = { enable = true },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["if"] = "@function.inner",
            ["af"] = "@function.outer",
          },
        },
        lsp_interop = {
          enable = true,
          floating_preview_opts = { border = "none" },
          peek_definition_code = {
            ["<leader>df"] = "@function.outer",
            ["<leader>dF"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.iex = {
        install_info = {
          url = "/Users/mitchell/src/tree-sitter-iex", -- local path or git repo
          files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
          branch = "main",
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
      }
      require("nvim-treesitter.configs").setup(opts)
    end,

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/playground",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("treesitter-context").setup()
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    cmd = {
      "PlenaryBustedDirectory",
      "PlenaryBustedFile",
    },
  },

  { "folke/neodev.nvim", opts = {} },

  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    -- dir = "~/src/elixir-tools.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")

      elixir.setup {
        credo = {enable = false},
        nextls = {enable = true},
        elixirls = {
          -- cmd = { vim.fn.expand("~/.local/share/nvim/lsp_servers/elixir/elixir-ls/rel/language_server.sh") },
          -- repo = "elixir-lsp/elixir-ls",
          -- branch = "master",
          settings = elixir.elixirls.settings {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
          log_level = vim.lsp.protocol.MessageType.Log,
          message_level = vim.lsp.protocol.MessageType.Log,
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
          on_attach = function()
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          end,
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },

  {
    "SmiteshP/nvim-navic",
    -- dir = "~/src/nvim-navic",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local navic = require("nvim-navic")

      navic.setup {
        highlight = true,
        safe_output = true,
        click = true,
      }
    end,
  },

  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup {
        picker = "fzf-lua",
      }
    end,
  },

  { "junegunn/vim-easy-align", event = "VeryLazy" },
}, {
  concurrency = 30,
  dev = { path = "~/src" },
  install = {
    missing = true,
    colorscheme = { "kanagawa" },
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
