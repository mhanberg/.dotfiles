_G.motch = {}

vim.filetype.add { filename = { Brewfile = "ruby", ["GRAPHITE_PR_DESCRIPTION.md"] = "octo" } }

require("motch.lazy")
vim.cmd.colorscheme("kanagawa-dragon")
require("motch.autocmds")

local opt = vim.opt

vim.env.WALLABY_DRIVER = "chrome"
vim.env.BAT_STYLE = "header,grid,numbers"

vim.cmd([[set shortmess+="C,c"]])

opt.timeoutlen = 500

opt.scrolloff = 4
opt.laststatus = 3
opt.winbar = [[%m %t %{%v:lua.require'motch.lsp'.navic()%}]]

opt.fillchars:append {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

opt.colorcolumn = "999"
opt.guifont = "JetBrains Mono"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.number = true
opt.backupdir = { vim.fn.expand("~/.tmp/backup") }
opt.directory = { vim.fn.expand("~/.tmp/swp/" .. vim.fn.expand("%:p")) }
opt.splitbelow = true
opt.splitright = true
opt.showmode = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.undodir = { vim.fn.expand("~/.tmp") }
opt.mouse = "a"
opt.errorbells = false
opt.visualbell = true
-- opt.t_vb = ""
opt.cursorline = true
opt.inccommand = "nosplit"
opt.background = "dark"
opt.autoread = true

opt.title = true

vim.cmd([[command! Q q]])
vim.cmd([[command! Qall qall]])
vim.cmd([[command! QA qall]])
vim.cmd([[command! E e]])
vim.cmd([[command! W w]])
vim.cmd([[command! Wq wq]])

vim.api.nvim_create_user_command("LspLogDelete", function()
  vim.fn.delete(vim.lsp.get_log_path())
end, { desc = "Deletes the LSP log file. Useful for when it gets too big" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Go to the previous item in the quickfix list." })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Go to the next item in the quickfix list." })
vim.keymap.set("n", "<leader><space>", function()
  vim.cmd.set("hls!")
end, { desc = "Toggle search highlight" })
vim.keymap.set("n", "<leader>gr", ":grep<cr>", { desc = ":grep" })
-- vim.keymap.set("n", "<leader>c", ":botright copen 20<cr>", { desc = "Open quickfix" })

vim.cmd([[tnoremap <esc> <C-\><C-n>]])

vim.g.dispatch_handlers = { "job" }

vim.g.zig_fmt_autosave = 0

opt.grepprg = "ag --vimgrep -Q $*"
opt.grepformat = "%f:%l:%c:%m"

vim.g.markdown_syntax_conceal = 0

local LSP = require("motch.lsp")

LSP.setup("lua_ls", {
  settings = {
    Lua = {
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      format = {
        enable = false,
      },
      workspace = {
        library = {
          "nvim-test/lua",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
        },
      },
    },
  },
})
LSP.setup("rust_analyzer", {})
LSP.setup("clangd", {})
-- LSP.setup("solargraph", {})
LSP.setup("omnisharp", {})
LSP.setup("tsserver", {})
-- LSP.setup("vimls", {})
LSP.setup("bashls", {})
-- LSP.setup("sourcekit", {})

LSP.setup("zls", {})
LSP.setup("nil_ls", {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "alejandra" },
      },
    },
  },
})
LSP.setup("gopls", {})
LSP.setup("jsonls", {})
LSP.setup("cssls", {
  settings = {
    css = {
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

local default_tw_config = LSP.default_config("tailwindcss")
LSP.setup(
  "tailwindcss",
  vim.tbl_deep_extend("force", default_tw_config, {
    -- cmd = vim.lsp.rpc.connect("127.0.0.1", 9000),

    init_options = {
      userLanguages = {
        elixir = "phoenix-heex",
        eruby = "erb",
        heex = "phoenix-heex",
        surface = "phoenix-heex",
      },
    },
    settings = {
      tailwindCSS = {
        validate = true,
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidScreen = "error",
          invalidVariant = "error",
          invalidConfigPath = "error",
          invalidTailwindDirective = "error",
          recommendedVariantOrder = "warning",
        },
        classAttributes = {
          "class",
          "className",
          "class:list",
          "classList",
          "ngClass",
        },

        experimental = {
          classRegex = {
            [[class: "([^"]*)]],
          },
        },
      },
    },
    filetypes = { "elixir", "eelixir", "html", "liquid", "heex", "surface", "css" },
  })
)
LSP.setup("gopls", {
  settings = {
    gopls = {
      codelenses = { test = true },
    },
  },
})
