local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      setopt = true,
      separator = false,
      foldfunc = "builtin",
      order = "NSFs",
    },
    init = function()
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevelstart = 99
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldmethod = "expr"
      vim.opt.mousemodel = "extend"
      vim.opt.fillchars:append {
        foldopen = "",
        foldsep = " ",
        foldclose = "",
      }
    end,
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
  },
  {
    "mhanberg/zk.nvim",
    ft = "markdown",
    opts = {
      filetypes = { "markdown", "liquid" },
      on_attach = function(client, bufnr)
        local LSP = require("motch.lsp")
        local opts = function(tbl)
          return vim.tbl_extend("keep", { buffer = bufnr, silent = true }, tbl)
        end

        LSP.on_attach(client, bufnr)
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
          vim.keymap.set("n", "<A-j>", [[:lua motch.dnd.move_to("previous")<cr>]], opts)
          vim.keymap.set("n", "<A-k>", [[:lua motch.dnd.move_to("next")<cr>]], opts)
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
      { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
    },
  },
  "farmergreg/vim-lastplace",

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
      theme = "/Users/mitchell/.config/bat/themes/Everforest Dark.tmTheme",
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
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true, -- disable if you use native command line UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = { buf_options = { filetype = "vim" } }, -- enable syntax highlighting in the cmdline
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
    "junegunn/fzf",
    init = function()
      vim.env.FZF_DEFAULT_OPTS = "--reverse"
      vim.g.fzf_commands_expect = "enter"
      vim.g.fzf_layout = {
        window = {
          width = 0.9,
          height = 0.6,
          yoffset = 0,
          highlight = "Normal",
        },
      }
      vim.g.fzf_buffers_jump = 1

      vim.g.fzf_lsp_width = 70
      vim.g.fzf_lsp_layout = {
        window = {
          width = 0.95,
          height = 0.95,
          yoffset = 0,
          highlight = "Normal",
        },
      }
      vim.g.fzf_lsp_preview_window = { "right:50%" }
      vim.g.fzf_lsp_pretty = true
    end,
    config = function()
      vim.api.nvim_exec(
        [[
function! FzfWrapHelper(opts)
  call fzf#run(fzf#wrap(a:opts))
endfunction
]],
        false
      )

      local FZF = vim.fn["FzfWrapHelper"]
      local fzf_grep = vim.fn["fzf#vim#grep"]

      _G.motch.files = function()
        vim.fn["fzf#vim#files"](
          ".",
          { window = { width = 119, height = 0.6, yoffset = 1, highlight = "Normal" } }
        )
      end

      local live_grep = function(query, fullscreen, dir)
        local command_format =
          "rg --glob '!yarn.lock' --glob '!package-lock.json' --glob '!.git' --hidden --column --line-number --no-heading --color=always --smart-case %s || true"
        local initial_command = vim.fn.printf(command_format, vim.fn.shellescape(query))
        local reload_command = vim.fn.printf(command_format, "{q}")
        local spec = {
          options = { "--disabled", "--query", query, "--bind", "change:reload:" .. reload_command },
          window = { width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal" },
          dir = dir,
        }

        fzf_grep(initial_command, 1, vim.fn["fzf#vim#with_preview"](spec, "right"), fullscreen)
      end

      _G.motch.local_project_search = function(query, fullscreen)
        live_grep(query, fullscreen)
      end

      vim.cmd(
        [[command! -nargs=* -bang LocalProjectSearch lua motch.local_project_search(<q-args>, <bang>0)]]
      )

      _G.motch.global_project_search = function(query, fullscreen)
        live_grep(query, fullscreen, "~/src")
      end

      _G.motch.projects = function()
        FZF {
          source = [[fd --type d --hidden --glob ".git" /Users/mitchellhanberg/src --exec echo {} | rev | cut -c 6- - | rev]],
          sink = function(selection)
            vim.api.nvim_set_current_dir(selection)
            vim.cmd([[Files]])
          end,
        }
      end

      _G.motch.todos = function()
        FZF {
          source = [[rg --vimgrep '^\s+# TODO:']],
          options = {
            "--delimiter",
            ":",
          },
          sink = function(selection)
            vim.api.nvim_set_current_dir(selection)
            vim.cmd([[Files]])
          end,
        }
      end
    end,
    keys = {
      { "<c-p>", vim.cmd.Files, desc = "Find files" },
      { "<space>p", "<cmd>GitFiles?<cr>", desc = "Find of changes files" },
      {
        "<space>vp",
        "<cmd>Files ~/.local/share/nvim/lazy<cr>",
        desc = "Find files of vim plugins",
      },
      { "<space>df", "<cmd>Files ~/src/<cr>", desc = "Find files in all projects" },
      { "gl", vim.cmd.BLines, desc = "FZF Buffer Lines" },
      { "<leader>a", vim.cmd.LocalProjectSearch, desc = "Search in project" },
      { "<space>a", ":GlobalProjectSearch<cr>", desc = "Search in all projects" },
    },

    dependencies = {
      "junegunn/fzf.vim",
      "gfanto/fzf-lsp.nvim",
    },
    build = function()
      vim.fn["fzf#install"]()
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
    dependencies = { "SmiteshP/nvim-navic" },
  },
  "norcalli/nvim.lua",
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-lua/telescope.nvim", lazy = true },
  { "tpope/vim-commentary", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-dispatch", event = "VeryLazy" },
  { "tpope/vim-eunuch", event = "VeryLazy" },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  "tpope/vim-projectionist",
  "tpope/vim-repeat",
  { "tpope/vim-rsi", event = "VeryLazy" },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
  "tpope/vim-vinegar",
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
      current_line_blame = true,
      current_line_blame_formatter = "   <author>, <committer_time:%R> • <summary>",
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    name = "indent_blankline",
    init = function()
      vim.opt.list = true
      vim.opt.listchars:append("eol:↴")
    end,
    opts = {
      space_char_blankline = " ",
      char = "│",
      filetype_exclude = {
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
    "sainnhe/everforest",
    init = function()
      vim.opt.termguicolors = true

      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_enable_italic = true
      vim.g.everforest_colors_override = {
        bg0 = { "#273433", "235" },
        bg1 = { "#394C4A", "236" },
        bg2 = { "#425755", "237" },
        bg3 = { "#4B6361", "238" },
        bg4 = { "#56716F", "239" },
      }
    end,
    config = function()
      vim.api.nvim_create_autocmd("User LazyColorscheme", {
        group = vim.api.nvim_create_augroup("lazy_colorscheme", { clear = true }),
        once = true,
        callback = function()
          vim.cmd([[highlight! link @symbol Blue]])
          vim.cmd([[highlight! link @constant PurpleItalic]])

          local palette = vim.fn["everforest#get_palette"]("medium", vim.g.everforest_colors_override)
          local hl = function(...)
            vim.api.nvim_set_hl(0, ...)
          end

          hl("NavicIconsFile", { default = true, fg = palette.fg[1], bg = nil })
          hl("NavicIconsModule", { default = true, fg = palette.yellow[1], bg = nil })
          hl("NavicIconsNamespace", { default = true, fg = palette.fg[1], bg = nil })
          hl("NavicIconsPackage", { default = true, fg = palette.fg[1], bg = nil })
          hl("NavicIconsClass", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsMethod", { default = true, fg = palette.blue[1], bg = nil })
          hl("NavicIconsProperty", { default = true, fg = palette.green[1], bg = nil })
          hl("NavicIconsField", { default = true, fg = palette.green[1], bg = nil })
          hl("NavicIconsConstructor", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsEnum", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsInterface", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsFunction", { default = true, fg = palette.blue[1], bg = nil })
          hl("NavicIconsVariable", { default = true, fg = palette.purple[1], bg = nil })
          hl("NavicIconsConstant", { default = true, fg = palette.purple[1], bg = nil })
          hl("NavicIconsString", { default = true, fg = palette.green[1], bg = nil })
          hl("NavicIconsNumber", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsBoolean", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsArray", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsObject", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsKey", { default = true, fg = palette.purple[1], bg = nil })
          hl("NavicIconsKeyword", { default = true, fg = palette.purple[1], bg = nil })
          hl("NavicIconsNull", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsEnumMember", { default = true, fg = palette.green[1], bg = nil })
          hl("NavicIconsStruct", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsEvent", { default = true, fg = palette.orange[1], bg = nil })
          hl("NavicIconsOperator", { default = true, fg = palette.fg[1], bg = nil })
          hl("NavicIconsTypeParameter", { default = true, fg = palette.green[1], bg = nil })
          hl("NavicText", { default = true, fg = palette.fg[1], bg = nil })
          hl("NavicSeparator", { default = true, fg = palette.fg[1], bg = nil })
        end,

        vim.api.nvim_exec_autocmds("User LazyColorscheme", {}),
      })
    end,
    priority = 1000,
    lazy = true,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { globalstatus = true, theme = "everforest" },
      extensions = { "fzf" },
      sections = {
        lualine_c = { { "filename", path = 1 } },
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
            ["if"] = "@function.inner",
            ["af"] = "@function.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/playground",
    },
  },

  {
    "mhanberg/elixir.nvim",
    ft = { "elixir", "eex", "heex", "surface" },
    config = function()
      local LSP = require("motch.lsp")
      local elixirls = require("elixir")

      elixirls.setup {
        -- cmd = { vim.fn.expand("~/.local/share/nvim/lsp_servers/elixir/elixir-ls/rel/language_server.sh") },
        repo = "elixir-lsp/elixir-ls",
        branch = "master",
        settings = elixirls.settings {
          dialyzerEnabled = false,
          enableTestLenses = false,
        },
        log_level = vim.lsp.protocol.MessageType.Log,
        message_level = vim.lsp.protocol.MessageType.Log,
        on_attach = function(client, bufnr)
          LSP.on_attach(client, bufnr)

          vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end,
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
    event = { "BufReadPost", "BufNewFile" },
  },

  { "prichrd/netrw.nvim" },
}, {
  concurrency = 30,
  dev = { path = "~/src" },
  install = {
    missing = true,
    colorscheme = { "everforest" },
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
