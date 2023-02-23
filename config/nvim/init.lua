_G.motch = {}

require("motch.lazy")
vim.cmd.colorscheme("everforest")

vim.filetype.add { filename = { Brewfile = "ruby" } }

NVIM = require("nvim")
P = function(thing)
  NVIM.print(thing)

  return thing
end

if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

local opt = vim.opt

function RemoveNetrwMap()
  if vim.fn.hasmapto("<Plug>NetrwRefresh") > 0 then
    vim.cmd([[unmap <buffer> <C-l>]])
  end
end

vim.env.WALLABY_DRIVER = "chrome"
vim.env.BAT_STYLE = "header,grid,numbers"

opt.shortmess:append("C")
opt.shortmess:append("c")

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
opt.backupdir = vim.fn.expand("~/.tmp/backup")
opt.directory = vim.fn.expand("~/.tmp/swp/" .. vim.fn.expand("%:p"))
opt.splitbelow = true
opt.splitright = true
opt.showmode = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.undodir = vim.fn.expand("~/.tmp")
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

vim.keymap.set("n", "cn", ":cnext<cr>", { desc = "Go to next quickfix item" })
vim.keymap.set("n", "<leader><space>", function()
  vim.cmd.set("hls!")
end, { desc = "Toggle search highlight" })
vim.keymap.set("n", "<leader>gr", ":grep<cr>")
vim.keymap.set("n", "<leader>c", ":botright copen 20<cr>")

vim.cmd([[tnoremap <esc> <C-\><C-n>]])

vim.g.dispatch_handlers = { "job" }

opt.completeopt = { "menu", "menuone", "noselect" }

vim.g.blamer_enabled = 1
vim.g.blamer_relative_time = 1

vim.g.zig_fmt_autosave = 0

opt.grepprg = "ag --vimgrep -Q $*"
opt.grepformat = "%f:%l:%c:%m"

vim.g.jsx_ext_required = 0

vim.g.goyo_width = 120
vim.g.goyo_height = 100

vim.g.markdown_syntax_conceal = 0

local LSP = require("motch.lsp")

LSP.setup("lua_ls", {
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
        unusedLocalExclude = { "_*" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

LSP.setup("dartls", {})
LSP.setup("efm", {
  filetypes = {
    "elixir",
    "javascript",
    "typescript",
    "lua",
    "bash",
    "zsh",
    "sh",
    "sql",
  },
})
LSP.setup("rust_analyzer", {})
-- LSP.setup("solargraph", {})
LSP.setup("omnisharp", {})
LSP.setup("tsserver", {})
-- LSP.setup("vimls", {})
LSP.setup("bashls", {})

LSP.setup("zls", {})
LSP.setup("gopls", {})

local default_tw_config = LSP.default_config("tailwindcss")
LSP.setup(
  "tailwindcss",
  vim.tbl_deep_extend("force", default_tw_config, {
    init_options = {
      userLanguages = {
        elixir = "phoenix-heex",
        eruby = "erb",
        heex = "phoenix-heex",
      },
    },
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            [[class: "([^"]*)]],
          },
        },
      },
    },
    filetypes = { "elixir", "eelixir", "html", "liquid", "heex" },
  })
)
LSP.setup("gopls", {
  settings = {
    gopls = {
      codelenses = { test = true },
    },
  },
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- local credo = vim.api.nvim_create_augroup("credo", { clear = true })

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   group = credo,
--   pattern = { "elixir" },
--   callback = function()
--     vim.lsp.start {
--       name = "CredoLS",
--       cmd = { "mix", "credo.lsp" },
--       settings = {},
--       capabilities = LSP.capabilities,
--       root_dir = vim.fs.dirname(vim.fs.find({ "mix.exs", ".git" }, { upward = true })[1]),
--       on_attach = LSP.on_attach,
--     }
--   end,
-- })
--

-- require('hologram').setup {
--   auto_display = true -- WIP automatic markdown image display, may be prone to breaking
-- }

local random = augroup("random", { clear = true })

autocmd("FileType", { pattern = "fzf", group = "random", command = "setlocal winhighlight+=Normal:Normal" })
-- autocmd "User", FloatermOpen execute "normal G" | wincmd p]]
autocmd("VimResized", { group = random, pattern = "*", command = "wincmd =" })
autocmd("GUIEnter", {
  group = random,
  pattern = "*",
  callback = function()
    vim.opt.visualbell = "t_vb="
  end,
})
autocmd("FileType", { group = random, pattern = "netrw", callback = RemoveNetrwMap })
autocmd("FileType", {
  group = random,
  pattern = "fzf",
  callback = function()
    vim.keymap.set("t", "<esc>", "<C-c>", { buffer = 0 })
  end,
})
autocmd(
  { "BufRead", "BufNewFile" },
  { group = random, pattern = "*.livemd", command = "set filetype=markdown" }
)
autocmd(
  { "BufRead", "BufNewFile" },
  { group = random, pattern = "aliases.local", command = "set filetype=zsh" }
)
autocmd({ "BufRead", "BufNewFile" }, { group = random, pattern = "*.lexs", command = "set filetype=elixir" })

local clojure = augroup("clojure", { clear = true })
autocmd("BufWritePost", { group = clojure, pattern = "*.clj", command = "silent Require" })

local markdown = augroup("markdown", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, { group = markdown, pattern = "*.md", command = "setlocal spell" })
autocmd({ "BufRead", "BufNewFile" }, { group = markdown, pattern = "*.md", command = "setlocal linebreak" })

vim.cmd([[let g:test#javascript#jest#file_pattern = '\v(.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$']])

if vim.fn.filereadable(".init.local.lua") == 1 then
  vim.cmd([[source .init.local.lua]])
end
