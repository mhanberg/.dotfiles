_G.motch = {}

require("motch.plugins")

NVIM = require("nvim")
p = NVIM.print

vim.notify = require("notify")

-- export namespace MessageType {
-- 	/**
-- 	 * An error message.
-- 	 */
-- 	export const Error = 1;
-- 	/**
-- 	 * A warning message.
-- 	 */
-- 	export const Warning = 2;
-- 	/**
-- 	 * An information message.
-- 	 */
-- 	export const Info = 3;
-- 	/**
-- 	 * A log message.
-- 	 */
-- 	export const Log = 4;
-- }

-- export type MessageType = 1 | 2 | 3 | 4;
--

local convert_lsp_log_level_to_neovim_log_level = function(lsp_log_level)
  if lsp_log_level == 1 then
    return 4
  elseif lsp_log_level == 2 then
    return 3
  elseif lsp_log_level == 3 then
    return 2
  elseif lsp_log_level == 4 then
    return 1
  end
end

local levels = {
  "ERROR",
  "WARN",
  "INFO",
  "DEBUG",
  [0] = "TRACE",
}

vim.lsp.handlers["window/showMessage"] = function(_, result, ...)
  if require("vim.lsp.log").should_log(convert_lsp_log_level_to_neovim_log_level(result.type)) then
    vim.notify(result.message, levels[result.type])
  end
end
-- vim.lsp.handlers["window/logMessage"] = n

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
]],
  false
)

FZF = vim.fn["FzfWrapHelper"]

vim.env.WALLABY_DRIVER = "chrome"

opt.laststatus = 3

opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

opt.colorcolumn = "99999"
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
opt.directory = vim.fn.expand("~/.tmp/swp")
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

vim.g.indentLine_fileTypeExclude = { "json" }
vim.g.indentLine_char = "│"

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
vim.keymap.set("n", "<c-p>", ":lua motch.files()<cr>")
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

vim.keymap.set("n", "<leader>gy", ":Goyo<cr>")
vim.g.goyo_width = 120
vim.g.goyo_height = 100

vim.g.markdown_syntax_conceal = 0

vim.g.Hexokinase_optInPatterns = { "full_hex", "triple_hex", "rgb", "rgba", "hsl", "hsla" }

local LSP = require("motch.lsp")

local uv = vim.loop

LSP.setup("elixirls", {
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = false,
      enableTestLenses = true,
      -- projectDir = ".",
    },
  },
  -- cmd = { vim.fn.expand("~/.local/share/nvim/lsp_servers/elixir/elixir-ls/language_server.sh") },
  cmd = { "/Users/mitchell/src/elixir-ls/release/language_server.sh" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    local path = util.path

    -- get the first mix project. this could either be a normal mix project, or a child project within an umbrella project
    local child_or_root_path = util.root_pattern({ "mix.exs", ".git" })(fname)

    -- maybe get the parent umbrella project to the maybe child project above. we search upwards starting at the directory above the one we found 👆.
    local maybe_umbrella_path = util.root_pattern({ "mix.exs" })(
      uv.fs_realpath(path.join({ child_or_root_path, ".." }))
    )

    -- if we have a path, is the path (joined with "apps") _NOT_ the prefix to the maybe child project? if correct (not a prefix), then it means we are in a normal project 
    -- if it _IS_ a prefix (joined with "apps"), then that means the file we have opened is inside an umbrella app
    -- technically the "apps_path" is configurable, so they could be wrong, but unlikely
    if maybe_umbrella_path and not vim.startswith(child_or_root_path, path.join({ maybe_umbrella_path, "apps" })) then
      maybe_umbrella_path = nil
    end

    local path = maybe_umbrella_path or child_or_root_path or vim.loop.os_homedir()

    return path
  end,

  on_attach = function(client, bufnr)
    LSP.on_attach(client, bufnr)

    vim.keymap.set(
      "n",
      "<space>fp",
      require("motch.elixir").from_pipe(client),
      { buffer = true, silent = true, noremap = true }
    )

    vim.keymap.set(
      "n",
      "<space>tp",
      require("motch.elixir").to_pipe(client),
      { buffer = true, silent = true, noremap = true }
    )
  end,
})
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
LSP.setup("vimls", {})
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
    vim.keymap.set("n", "<space>zd", [[:lua require("zk").new({group = "daily", dir = "journal/daily"})<cr>]], opts)
    vim.keymap.set("v", "<leader>zn", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)

    if vim.fn.expand("%:h") == "dnd" then
      vim.keymap.set("n", "<A-j>", [[:lua motch.dnd.move_to("previous")<cr>]], opts)
      vim.keymap.set("n", "<A-k>", [[:lua motch.dnd.move_to("next")<cr>]], opts)
    end
  end,
})

LSP.setup("zls", {})
LSP.setup("gopls", {})

LSP.setup(
  "tailwindcss",
  vim.tbl_extend("force", {
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
  }, LSP.default_config("tailwindcss"))
)

-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('motch.code_action').code_action_listener()]])
--

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local random = augroup("random", { clear = true })

autocmd("BufWritePost", { group = random, pattern = "plugins.lua", command = "PackerCompile" })
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
autocmd({ "BufRead", "BufNewFile" }, { group = random, pattern = "*.livemd", command = "set filetype=markdown" })
autocmd({ "BufRead", "BufNewFile" }, { group = random, pattern = "aliases.local", command = "set filetype=zsh" })
autocmd({ "BufRead", "BufNewFile" }, { group = random, pattern = "*.lexs", command = "set filetype=elixir" })

-- augroup("random", function(autocmd)
--   autocmd([[BufWritePost plugins.lua PackerCompile]])
--   -- autocmd [[User FloatermOpen execute "normal G" | wincmd p]]
--   autocmd([[VimResized * :wincmd =]])
--   autocmd([[GUIEnter * set visualbell t_vb=]])
--   autocmd([[FileType netrw :lua RemoveNetrwMap()]])
--   autocmd([[FileType fzf :tnoremap <buffer> <esc> <C-c>]])
--   autocmd([[BufRead,BufNewFile *.zsh-theme set filetype=zsh]])
--   autocmd([[BufRead,BufNewFile *.livemd set filetype=markdown]])
--   autocmd([[BufRead,BufNewFile aliases.local set filetype=zsh]])
--   autocmd([[BufRead,BufNewFile *.lexs set filetype=elixir]])
--   autocmd([[BufRead,BufNewFile *.exs set filetype=elixir]])
--   autocmd([[BufRead,BufNewFile *.ex set filetype=elixir]])
--   autocmd([[FileType elixir setlocal commentstring=#\ %s]])
-- end)

local clojure = augroup("clojure", { clear = true })
autocmd("BufWritePost", { group = clojure, pattern = "*.clj", command = "silent Require" })

local markdown = augroup("markdown", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, { group = markdown, pattern = "*.md", command = "setlocal spell" })
autocmd({ "BufRead", "BufNewFile" }, { group = markdown, pattern = "*.md", command = "setlocal linebreak" })

vim.cmd([[let g:test#javascript#jest#file_pattern = '\v(.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$']])
