_G.motch = {}

require("motch.deps")

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

_ = require("underscore")

local opt = vim.opt

function RemoveNetrwMap()
  if vim.fn.hasmapto("<Plug>NetrwRefresh") > 0 then
    vim.cmd([[unmap <buffer> <C-l>]])
  end
end

vim.api.nvim_exec(
  [[
function! FzfWrapHelper(opts)
  call fzf#run(fzf#wrap(a:opts))
endfunction
]] ,
  false
)

FZF = vim.fn["FzfWrapHelper"]

vim.env.WALLABY_DRIVER = "chrome"
vim.env.BAT_STYLE = "header,grid,numbers"

opt.timeoutlen = 500

opt.scrolloff = 4
opt.laststatus = 3
opt.winbar = [[%f %m %{v:lua.require("nvim-navic").get_location()}]]

opt.fillchars = {
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
opt.foldmethod = "syntax"
opt.foldlevelstart = 99
opt.smartindent = true
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

vim.g.forest_night_enable_italic = 1
vim.g.forest_night_diagnostic_text_highlight = 1

-- vim.cmd([[color thicc_forest]])

vim.g.projectionist_heuristics = vim.json.decode([[
{
  "mix.exs": {
    "lib/**/views/*_view.ex": {
      "type": "view",
      "alternate": "test/{dirname}/views/{basename}_view_test.exs",
      "template": [
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View do",
        "  use {dirname|camelcase|capitalize}, :view",
        "end"
      ]
    },
    "test/**/views/*_view_test.exs": {
      "alternate": "lib/{dirname}/views/{basename}_view.ex",
      "type": "test",
      "template": [
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ViewTest do",
        "  use ExUnit.Case, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View",
        "end"
      ]
    },
    "lib/**/controllers/*_controller.ex": {
      "type": "controller",
      "alternate": "test/{dirname}/controllers/{basename}_controller_test.exs",
      "template": [
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Controller do",
        "  use {dirname|camelcase|capitalize}, :controller",
        "end"
      ]
    },
    "test/**/controllers/*_controller_test.exs": {
      "alternate": "lib/{dirname}/controllers/{basename}_controller.ex",
      "type": "test",
      "template": [
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do",
        "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
        "end"
      ]
    },
    "lib/**/channels/*_channel.ex": {
      "type": "channel",
      "alternate": "test/{dirname}/channels/{basename}_channel_test.exs",
      "template": [
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel do",
        "  use {dirname|camelcase|capitalize}, :channel",
        "end"
      ]
    },
    "test/**/channels/*_channel_test.exs": {
      "alternate": "lib/{dirname}/channels/{basename}_channel.ex",
      "type": "test",
      "template": [
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ChannelTest do",
        "  use {dirname|camelcase|capitalize}.ChannelCase, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel",
        "end"
      ]
    },
    "test/**/features/*_test.exs": {
      "type": "feature",
      "template": [
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Test do",
        "  use {dirname|camelcase|capitalize}.FeatureCase, async: true",
        "end"
      ]
    },
    "lib/*.ex": {
      "alternate": "test/{}_test.exs",
      "type": "source",
      "template": [
        "defmodule {camelcase|capitalize|dot} do",
        "end"
      ]
    },
    "test/*_test.exs": {
      "alternate": "lib/{}.ex",
      "type": "test",
      "template": [
        "defmodule {camelcase|capitalize|dot}Test do",
        "  use ExUnit.Case, async: true",
        "",
        "  alias {camelcase|capitalize|dot}",
        "end"
      ]
    }
  }
}
]])

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
vim.keymap.set("n", "<leader>sv", [[:luafile $MYVIMRC<cr>]])
vim.keymap.set("n", "<c-p>", vim.cmd.Files, { desc = "Find files" })
vim.keymap.set(
  "n",
  "<space>vp",
  ":Files ~/.local/share/nvim/site/pack/packer/start<cr>",
  { desc = "Find files of vim plugins" }
)
vim.keymap.set("n", "<space>df", ":Files ~/src/<cr>", { desc = "Find files in all projects" })
vim.keymap.set("n", "gl", vim.cmd.BLines, { desc = "FZF Buffer Lines" })
vim.keymap.set("n", "<leader>a", vim.cmd.LocalProjectSearch, { desc = "Search in project" })
vim.keymap.set("n", "<space>a", ":GlobalProjectSearch<cr>", { desc = "Search in all projects" })
vim.keymap.set("n", "<leader>gr", ":grep<cr>")
vim.keymap.set("n", "<leader>c", ":botright copen 20<cr>")

vim.cmd([[tnoremap <esc> <C-\><C-n>]])

vim.g.dispatch_handlers = { "job" }

opt.completeopt = { "menu", "menuone", "noselect" }

vim.g.blamer_enabled = 1
vim.g.blamer_relative_time = 1

vim.g.zig_fmt_autosave = 0

require("motch.treesitter")

opt.grepprg = "ag --vimgrep -Q $*"
opt.grepformat = "%f:%l:%c:%m"

vim.g.jsx_ext_required = 0

vim.keymap.set("n", "<leader>gy", ":TZAtaraxis<cr>")
vim.g.goyo_width = 120
vim.g.goyo_height = 100

vim.g.markdown_syntax_conceal = 0

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

    -- dap
    vim.keymap.set("n", "<space>db", require("dap").toggle_breakpoint, { buffer = true, silent = true })
    vim.keymap.set("n", "<space>dc", require("dap").continue, { buffer = true, silent = true })
  end,
}

LSP.setup("sumneko_lua", {
  settings = {
    Lua = {
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

local zk = require("zk")

zk.setup {
  filetypes = { "markdown", "liquid" },
  on_attach = function(client, bufnr)
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
      vim.keymap.set("n", "<A-j>", [[:lua motch.dnd.move_to("previous")<cr>]], opts)
      vim.keymap.set("n", "<A-k>", [[:lua motch.dnd.move_to("next")<cr>]], opts)
    end
  end,
}

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
      codelenses = { test = true, }
    }
  }
})

-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('motch.code_action').code_action_listener()]])
--

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local random = augroup("random", { clear = true })

autocmd("FileType", { pattern = "fzf", group = "random", command = "setlocal winhighlight+=Normal:Normal" })
autocmd(
  "BufWritePost",
  { group = random, pattern = "config/nvim/lua/motch/deps.lua", command = "PackerCompile" }
)
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
