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
    dir = "~/src/control-panel.nvim",
    config = function()
      -- local cp = require("control_panel")
      -- cp.register {
      --   id = "output-panel",
      --   title = "Output Panel",
      -- }

      -- local handler = vim.lsp.handlers["window/logMessage"]

      -- vim.lsp.handlers["window/logMessage"] = function(err, result, context)
      --   handler(err, result, context)
      --   if not err then
      --     local client_id = context.client_id
      --     local client = vim.lsp.get_client_by_id(client_id)

      --     if not cp.panel("output-panel"):has_tab(client.name) then
      --       cp.panel("output-panel")
      --         :tab { name = client.name, key = tostring(#cp.panel("output-panel"):tabs() + 1) }
      --     end

      --     cp.panel("output-panel"):append {
      --       tab = client.name,
      --       text = "[" .. vim.lsp.protocol.MessageType[result.type] .. "] " .. result.message,
      --     }
      --   end
      -- end
    end,
  },
  {
    "mhanberg/output-panel.nvim",
    event = "VeryLazy",
    -- dev = true,
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
      vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
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
    config = function(_, opts)
      require("zk").setup(opts)
    end,
    opts = {
      filetypes = { "markdown", "liquid" },
      on_attach = function(_, bufnr)
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
          vim.keymap.set(
            "n",
            "<A-j>",
            [[:lua motch.dnd.move_to("previous")<cr>]],
            opts { desc = "Previous D&D note" }
          )
          vim.keymap.set(
            "n",
            "<A-k>",
            [[:lua motch.dnd.move_to("next")<cr>]],
            opts { desc = "Next D&D note" }
          )
        end
      end,
    },
    dependencies = {

      "junegunn/fzf",
      "junegunn/fzf.vim",

      "neovim/nvim-lspconfig",
    },
  },
  { "ruanyl/vim-gh-line", event = { "BufReadPost", "BufNewFile" } },
  { "alvan/vim-closetag", ft = { "html", "liquid", "javascriptreact", "typescriptreact" } },
  { "christoomey/vim-tmux-navigator", event = "VeryLazy" },

  { "christoomey/vim-tmux-runner", event = { "BufReadPost", "BufNewFile" } },
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          javascript = { "prettier", "eslint" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          nix = { "nixpkgs_fmt" },
          -- Conform will run multiple formatters sequentially
          swift = { "swift_format" },
        },
      }
    end,
  },
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
          { name = "buffer", keyword_length = 3 },
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
  { "farmergreg/vim-lastplace", event = { "BufReadPre", "BufNewFile" } },

  { "edluffy/hologram.nvim", ft = "markdown" },

  -- Lua
  {
    "0oAstro/silicon.lua",
    opts = {
      font = "Hack",
      lineNumber = false,
      padHoriz = 60, -- Horizontal padding
      padVert = 40, -- vertical padding
      -- bgColor = "#56716F",
      -- bgImage = vim.fs.joinpath(vim.env.ICLOUD, "/code-snippet-background.png"),
      -- bgImage = "/Users/mitchell/Downloads/robert-anasch-u6AQYn1tMSE-unsplash.jpg",
      -- bgImage = "/Users/mitchell/Downloads/engin-akyurt-HEMIBJ8QQuA-unsplash.jpg",
      -- bgImage = "/Users/mitchell/Downloads/sincerely-media-K5OLjMlPe4U-unsplash.jpg",
      bgImage = "/Users/mitchell/Downloads/luke-chesser-pJadQetzTkI-unsplash.jpg",
      shadowBlurRadius = 0,
      -- theme = "/Users/mitchell/.config/silicon/themes/Everforest Dark.tmTheme",
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
          enabled = false,
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
    ft = "starter",
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
    event = "VeryLazy",
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
  { "tpope/vim-eunuch", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "tpope/vim-projectionist", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
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
        end, { expr = true, desc = "Next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev. hunk" })

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk under cursor" })
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk under cursor" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk under cursor" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk under cursor" })
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    name = "indent_blankline",
    init = function()
      vim.opt.list = true
    end,
    opts = {
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = {
          "markdown",
          "help",
          "man",
          "gitcommit",
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

    config = function(_, opts)
      require("ibl").setup(opts)
    end,
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
          ["@string.regexp"] = { link = "@string.regex" },
          ["@variable.parameter"] = { link = "@parameter" },
          ["@exception"] = { link = "@exception" },
          ["@string.special.symbol"] = { link = "@symbol" },
          ["@markup.strong"] = { link = "@text.strong" },
          ["@markup.italic"] = { link = "@text.emphasis" },
          ["@markup.heading"] = { link = "@text.title" },
          ["@markup.raw"] = { link = "@text.literal" },
          ["@markup.quote"] = { link = "@text.quote" },
          ["@markup.math"] = { link = "@text.math" },
          ["@markup.environment"] = { link = "@text.environment" },
          ["@markup.environment.name"] = { link = "@text.environment.name" },
          ["@markup.link.url"] = { link = "Special" },
          ["@markup.link.label"] = { link = "Identifier" },
          ["@comment.note"] = { link = "@text.note" },
          ["@comment.warning"] = { link = "@text.warning" },
          ["@comment.danger"] = { link = "@text.danger" },
          ["@diff.plus"] = { link = "@text.diff.add" },
          ["@diff.minus"] = { link = "@text.diff.delete" },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
    end,
  },

  {
    "echasnovski/mini.clue",
    version = false,
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup {
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "n", keys = "<space>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      }
    end,
  },

  {
    "echasnovski/mini.nvim",
    event = { "VimEnter", "BufReadPost", "BufNewFile" },
    version = "*",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup {
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }

      -- require("mini.base16").setup {
      --   palette = {
      --     base00 = "#000000",
      --     base01 = "#6928FF",
      --     base02 = "#FFFFFF",
      --     base03 = "#8691a7",
      --     base04 = "#150044",
      --     base05 = "#e2e98f",
      --     base06 = "#eff69c",
      --     base07 = "#fcffaa",
      --     base08 = "#ffcfa0",
      --     base09 = "#cc7e46",
      --     base0A = "#46a436",
      --     base0B = "#9ff895",
      --     base0C = "#ca6ecf",
      --     base0D = "#42f7ff",
      --     base0E = "#ffc4ff",
      --     base0F = "#00a5c5",
      --   },
      --   use_cterm = true,
      -- }

      local fzflua = function()
        return function()
          return {
            { action = "FzfLua files", name = "Find File", section = "Files" },
            { action = "Neotree", name = "Neotree", section = "Files" },
          }
        end
      end

      local header = {
        [[@@@@@@@@@@    @@@@@@   @@@@@@@   @@@@@@@  @@@  @@@  @@@  @@@  @@@  @@@@@@@@@@ ]],
        [[@@@@@@@@@@@  @@@@@@@@  @@@@@@@  @@@@@@@@  @@@  @@@  @@@  @@@  @@@  @@@@@@@@@@@]],
        [[@@! @@! @@!  @@!  @@@    @@!    !@@       @@!  @@@  @@!  @@@  @@!  @@! @@! @@!]],
        [[!@! !@! !@!  !@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@  !@!  !@! !@! !@!]],
        [[@!! !!@ @!@  @!@  !@!    @!!    !@!       @!@!@!@!  @!@  !@!  !!@  @!! !!@ @!@]],
        [[!@!   ! !@!  !@!  !!!    !!!    !!!       !!!@!!!!  !@!  !!!  !!!  !@!   ! !@!]],
        [[!!:     !!:  !!:  !!!    !!:    :!!       !!:  !!!  :!:  !!:  !!:  !!:     !!:]],
        [[:!:     :!:  :!:  !:!    :!:    :!:       :!:  !:!   ::!!:!   :!:  :!:     :!:]],
        [[:::     ::   ::::: ::     ::     ::: :::  ::   :::    ::::     ::  :::     :: ]],
        [[ :      :     : :  :      :      :: :: :   :   : :     :      :     :      :  ]],
      }

      local header2 = vim.split(
        [[
@@@@@@@@  @@@       @@@  @@@  @@@  @@@  @@@@@@@              @@@@@@@   @@@@@@    @@@@@@   @@@        @@@@@@
@@@@@@@@  @@@       @@@  @@@  @@@  @@@  @@@@@@@@             @@@@@@@  @@@@@@@@  @@@@@@@@  @@@       @@@@@@@
@@!       @@!       @@!  @@!  !@@  @@!  @@!  @@@               @@!    @@!  @@@  @@!  @@@  @@!       !@@
!@!       !@!       !@!  !@!  @!!  !@!  !@!  @!@               !@!    !@!  @!@  !@!  @!@  !@!       !@!
@!!!:!    @!!       !!@   !@@!@!   !!@  @!@!!@!   @!@!@!@!@    @!!    @!@  !@!  @!@  !@!  @!!       !!@@!!
!!!!!:    !!!       !!!    @!!!    !!!  !!@!@!    !!!@!@!!!    !!!    !@!  !!!  !@!  !!!  !!!        !!@!!!
!!:       !!:       !!:   !: :!!   !!:  !!: :!!                !!:    !!:  !!!  !!:  !!!  !!:            !:!
:!:        :!:      :!:  :!:  !:!  :!:  :!:  !:!               :!:    :!:  !:!  :!:  !:!   :!:          !:!
 :: ::::   :: ::::   ::   ::  :::   ::  ::   :::                ::    ::::: ::  ::::: ::   :: ::::  :::: ::
: :: ::   : :: : :  :     :   ::   :     :   : :                :      : :  :    : :  :   : :: : :  :: : :
      ]],
        "\n"
      )

      local starter = require("mini.starter")
      starter.setup {
        header = table.concat(header, "\n"),
        items = { fzflua },
        content_hooks = {
          starter.gen_hook.aligning("center", "center"),
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
        lualine_x = {
          {
            "macro-recording",
            fmt = function()
              local recording_register = vim.fn.reg_recording()
              if recording_register == "" then
                return ""
              else
                return "recording @" .. recording_register
              end
            end,
            color = { fg = "orange" },
          },
          "selectioncount",
          "searchcount",
          "encoding",
          "fileformat",
          "filetype",
        },
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
      ignore_install = { "haskell", "phpdoc", "d" },
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
      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.iex = {
      --   install_info = {
      --     url = "/Users/mitchell/src/tree-sitter-iex", -- local path or git repo
      --     files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
      --     branch = "main",
      --     generate_requires_npm = false,
      --     requires_generate_from_grammar = false,
      --   },
      -- }
      --
      -- vim.treesitter.language.register("liquid", "liquid")
      -- parser_config.liquid_html = parser_config.html
      -- parser_config.liquid = {
      --   install_info = {
      --     url = "https://github.com/adamazing/tree-sitter-liquid.git", -- local path or git repo
      --     files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
      --     branch = "main",
      --     generate_requires_npm = false,
      --     requires_generate_from_grammar = true,
      --   },
      -- }
      require("nvim-treesitter.configs").setup(opts)
    end,

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/playground",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
    enabled = false,
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
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup {
        symbols = {
          File = { icon = "󰈔", hl = "@text.uri" },
          Module = { icon = "󰆧", hl = "@namespace" },
          Namespace = { icon = "󰅪", hl = "@namespace" },
          Package = { icon = "󰏗", hl = "@namespace" },
          Class = { icon = "𝓒", hl = "@type" },
          Method = { icon = "ƒ", hl = "@method" },
          Property = { icon = "", hl = "@method" },
          Field = { icon = "󰆨", hl = "@field" },
          Constructor = { icon = "", hl = "@constructor" },
          Enum = { icon = "ℰ", hl = "@type" },
          Interface = { icon = "󰜰", hl = "@type" },
          Function = { icon = "", hl = "@function" },
          Variable = { icon = "", hl = "@constant" },
          Constant = { icon = "", hl = "@constant" },
          String = { icon = "𝓐", hl = "@string" },
          Number = { icon = "#", hl = "@number" },
          Boolean = { icon = "⊨", hl = "@boolean" },
          Array = { icon = "󰅪", hl = "@constant" },
          Object = { icon = "⦿", hl = "@type" },
          Key = { icon = "🔐", hl = "@type" },
          Null = { icon = "NULL", hl = "@type" },
          EnumMember = { icon = "", hl = "@field" },
          Struct = { icon = "𝓢", hl = "@type" },
          Event = { icon = "🗲", hl = "@type" },
          Operator = { icon = "+", hl = "@operator" },
          TypeParameter = { icon = "𝙏", hl = "@parameter" },
          Component = { icon = "󰅴", hl = "@function" },
          Fragment = { icon = "󰅴", hl = "@constant" },
        },
      }
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = function()
      require("flutter-tools").setup {} -- use defaults
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup {
        languages = {
          surface = [[<!--\ %s\ -->]],
        },
      }
    end,
  },

  {
    "mhanberg/workspace-folder.nvim",
    dir = "~/src/workspace-folders.nvim",
    lazy = false,
  },

  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    -- dev = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local nextls_opts
      if vim.env.NEXTLS_LOCAL == "1" then
        nextls_opts = {
          enable = true,
          port = 9000,
          init_options = {
            experimental = {
              completions = {
                enable = true,
              },
              parser = { enable = true },
            },
          },
        }
      else
        nextls_opts = {
          enable = true,
          init_options = {
            experimental = {
              completions = {
                enable = true,
              },
            },
          },
        }
      end

      elixir.setup {
        nextls = nextls_opts,
        credo = { enable = false },
        elixirls = { enable = false },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mhanberg/workspace-folders.nvim",
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

  { "junegunn/vim-easy-align", event = { "BufReadPost", "BufNewFile" } },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            vim.cmd.Neotree("close")
          end,
          id = "close-on-enter",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "Neotree",
    },
    keys = {
      {
        "-",
        function()
          vim.cmd.Neotree("reveal", "toggle=true", "position=current")
        end,
        mode = "n",
        desc = "Toggle Neotree",
      },
    },
  },
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
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
