_G.motch = {}

require("motch.plugins")

NVIM = require("nvim")
p = function(thing)
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

vim.notify = require("notify")

_ = require("underscore")

local opt = vim.opt

function RemoveNetrwMap()
  if vim.fn.hasmapto("<Plug>NetrwRefresh") > 0 then vim.cmd([[unmap <buffer> <C-l>]]) end
end

vim.api.nvim_exec(
  [[
function! FzfWrapHelper(opts)
  call fzf#run(fzf#wrap(a:opts))
endfunction
]],
  false
)

FZF = vim.fn["FzfWrapHelper"]

vim.env.WALLABY_DRIVER = "chrome"

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
opt.termguicolors = true
opt.backupdir = vim.fn.expand("~/.tmp/backup")
opt.directory = vim.fn.expand("~/.tmp/swp/"..vim.fn.expand("%:p"))
opt.splitbelow = true
opt.splitright = true
opt.lazyredraw = true
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

vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "cn", ":cnext<cr>")
vim.keymap.set("n", "<leader><space>", ":set hls!<cr>")
vim.keymap.set("n", "<leader>ev", ":vsplit ~/.vimrc<cr>")
vim.keymap.set("n", "<leader>sv", [[:luafile $MYVIMRC<cr>]])
vim.keymap.set("n", "<c-p>", ":Files<cr>")
vim.keymap.set("n", "<space>vp", ":Files ~/.local/share/nvim/site/pack/packer/start<cr>")
vim.keymap.set("n", "<space>df", ":Files ~/src/<cr>")
vim.keymap.set("n", "gl", ":BLines<cr>")
vim.keymap.set("n", "<leader>a", ":LocalProjectSearch<cr>")
vim.keymap.set("n", "<space>a", ":GlobalProjectSearch<cr>")
vim.keymap.set("n", "<leader>gr", ":grep<cr>")
vim.keymap.set("n", "<leader>c", ":botright copen 20<cr>")
vim.keymap.set("n", "<leader>gd", ":silent !tmux popup -K -w '90\\%' -h '90\\%' -R 'git diff'<cr>")
vim.keymap.set("n", "<leader>gs", ":silent !tmux popup -K -w '90\\%' -h '90\\%' -R 'git status'<cr>")

vim.keymap.set("n", "<leader>d", ":lua motch.gdiff()<cr>")
vim.keymap.set("n", "<leader><leader>m", ":Mix<cr>")

vim.cmd([[tnoremap <esc> <C-\><C-n>]])

vim.g.dispatch_handlers = { "job" }

-- ctags
vim.keymap.set("n", "<leader>ct", ":!ctags -R .<cr>")

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

elixirls.setup({
  -- cmd = { vim.fn.expand("~/.local/share/nvim/lsp_servers/elixir/elixir-ls/rel/language_server.sh") },
  repo = "mhanberg/elixir-ls",
  branch = "mh/all-workspace-symbols",
  settings = elixirls.settings({
    dialyzerEnabled = false,
  }),
  log_level = vim.lsp.protocol.MessageType.Log,
  message_level = vim.lsp.protocol.MessageType.Log,
  on_attach = function(client, bufnr)
    LSP.on_attach(client, bufnr)

    vim.keymap.set("n", "<space>r", vim.lsp.codelens.run, { buffer = true, noremap = true })
    vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
    vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
    vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })

    -- dap
    vim.keymap.set("n", "<space>db", require("dap").toggle_breakpoint, { buffer = true, silent = true })
    vim.keymap.set("n", "<space>dc", require("dap").continue, { buffer = true, silent = true })
  end,
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

zk.setup({
  filetypes = { "markdown", "liquid" },
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }

    LSP.on_attach(client, bufnr)
    vim.keymap.set("n", "<C-p>", [[:Notes<cr>]], opts)
    vim.keymap.set("n", "<space>zt", [[:Tags<cr>]], opts)
    vim.keymap.set("n", "<space>zl", [[:Links<cr>]], opts)
    vim.keymap.set("n", "<space>zb", [[:Backlinks<cr>]], opts)
    vim.keymap.set(
      "n",
      "<space>zd",
      [[:lua require("zk").new({group = "daily", dir = "journal/daily"})<cr>]],
      opts
    )
    vim.keymap.set("v", "<leader>zn", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)

    if vim.fn.expand("%:h") == "dnd" then
      vim.keymap.set("n", "<A-j>", [[:lua motch.dnd.move_to("previous")<cr>]], opts)
      vim.keymap.set("n", "<A-k>", [[:lua motch.dnd.move_to("next")<cr>]], opts)
    end
  end,
})

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
    filetypes = { "elixir", "eelixir", "html", "liquid" },
  })
)

-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('motch.code_action').code_action_listener()]])
--

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local random = augroup("random", { clear = true })

autocmd(
  "BufWritePost",
  { group = random, pattern = "config/nvim/lua/motch/plugins.lua", command = "PackerCompile" }
)
-- autocmd "User", FloatermOpen execute "normal G" | wincmd p]]
autocmd("VimResized", { group = random, pattern = "*", command = "wincmd =" })
autocmd("GUIEnter", {
  group = random,
  pattern = "*",
  callback = function() vim.opt.visualbell = "t_vb=" end,
})
autocmd("FileType", { group = random, pattern = "netrw", callback = RemoveNetrwMap })
autocmd("FileType", {
  group = random,
  pattern = "fzf",
  callback = function() vim.keymap.set("t", "<esc>", "<C-c>", { buffer = 0 }) end,
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
autocmd({ "FileType" }, {
  group = random,
  pattern = {"markdown"},
  callback = function()
    file = vim.fs.find({ ".git" }, { upward = true })[1]

    if file then
      vim.notify("starting spell lsp")
      vim.lsp.start({
        name = "spels",
        cmd = { "elixir", "--no-halt", "/Users/mitchell/src/gen_lsp/examples/spell.exs" },
        root_dir = vim.fs.dirname(file),
      })
    end
  end,
})

local clojure = augroup("clojure", { clear = true })
autocmd("BufWritePost", { group = clojure, pattern = "*.clj", command = "silent Require" })

local markdown = augroup("markdown", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, { group = markdown, pattern = "*.md", command = "setlocal spell" })
autocmd({ "BufRead", "BufNewFile" }, { group = markdown, pattern = "*.md", command = "setlocal linebreak" })

vim.cmd([[let g:test#javascript#jest#file_pattern = '\v(.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$']])

if vim.fn.filereadable(".init.local.lua") == 1 then vim.cmd([[source .init.local.lua]]) end
