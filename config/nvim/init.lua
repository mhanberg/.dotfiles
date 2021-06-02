require("motch.plugins")

local augroup = require("motch.utils").augroup
local nnoremap = require("motch.utils").nnoremap
-- local opt = require("motch.utils").opt
local opt = vim.opt

function RemoveNetrwMap()
  if vim.fn.hasmapto("<Plug>NetrwRefresh") > 0 then
    vim.cmd [[unmap <buffer> <C-l>]]
  end
end

NVIM = require("nvim")
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
vim.g.forest_night_enable_italic = 1
vim.g.forest_night_diagnostic_text_highlight = 1

-- vim.cmd [[color forest-night]]
vim.cmd [[color thicc_forest]]

vim.g.indentLine_fileTypeExclude = {"json"}
vim.g.indentLine_char = "│"

vim.cmd [[command! Q q]]
vim.cmd [[command! Qall qall]]
vim.cmd [[command! QA qall]]
vim.cmd [[command! E e]]
vim.cmd [[command! W w]]
vim.cmd [[command! Wq wq]]

vim.env.FZF_DEFAULT_OPTS = "--reverse"
opt.g("fzf_preview_window", {})
opt.g(
  "fzf_layout",
  {
    window = {
      width = 119,
      height = 0.6,
      yoffset = 0,
      highlight = "Normal"
    }
  }
)

nnoremap("cn", ":cnext<cr>")
nnoremap("<leader><space>", ":set hls!<cr>")
nnoremap("<leader>ev", ":vsplit ~/.vimrc<cr>")
nnoremap("<leader>sv", [[:luafile $MYVIMRC<cr>]])
nnoremap("<c-p>", ":Files<cr>")
nnoremap("gl", ":BLines<cr>")
nnoremap("<leader>a", ":RG<cr>")
nnoremap("<leader>gr", ":grep<cr>")
nnoremap("<leader>c", ":botright copen 20<cr>")
nnoremap("<leader>gd", ":silent !tmux popup -K -w '90\\%' -h '90\\%' -R 'git diff'<cr>")
nnoremap("<leader>gs", ":silent !tmux popup -K -w '90\\%' -h '90\\%' -R 'git status'<cr>")

vim.g.dispatch_handlers = {"job"}
vim.g["test#strategy"] = "floaterm"
vim.g.floaterm_wintype = "split"
vim.g.floaterm_height = 0.3
vim.g.floaterm_autoclose = 1
vim.g.floaterm_autoinsert = false

nnoremap("<leader>n", ":TestNearest<cr>")
nnoremap("<leader>f", ":TestFile<cr>")
nnoremap("<leader>s", ":TestSuite<cr>")
nnoremap("<leader>l", ":TestLast<cr>")

-- ctags
nnoremap("<leader>ct", ":!ctags -R .<cr>")
nnoremap("<leader>t", ":Tags<cr>")
nnoremap("<leader>r", ":BTags")

opt.completeopt = {"menuone", "noinsert", "noselect"}
vim.g.completion_enable_snippet = "vim-vsnip"

vim.g.blamer_enabled = 1
vim.g.blamer_relative_time = 1

require("motch.treesitter")

opt.grepprg = "ag --vimgrep -Q $*"
opt.grepformat = "%f:%l:%c:%m"

vim.g.jsx_ext_required = 0

nnoremap("<leader>gy", ":Goyo<cr>")
vim.g.goyo_width = 120
vim.g.goyo_height = 100

vim.g.markdown_syntax_conceal = 0

vim.g.Hexokinase_optInPatterns = {"full_hex", "triple_hex", "rgb", "rgba", "hsl", "hsla"}

local LSP = require("motch.lsp")

local path_to_elixirls = vim.fn.expand("~/.cache/nvim/lspconfig/elixirls/elixir-ls/release/language_server.sh")
LSP.setup(
  "elixirls",
  {
    settings = {
      elixirLS = {
        dialyzerEnabled = false,
        fetchDeps = false
      }
    },
    cmd = {path_to_elixirls}
  }
)
LSP.setup(
  "efm",
  {
    filetypes = {
      "elixir",
      "javascript",
      "lua",
      "bash",
      "zsh",
      "sh"
    }
  }
)
LSP.setup("rust_analyzer", {})
LSP.setup("solargraph", {})
LSP.setup("omnisharp", {})
LSP.setup("tsserver", {})
LSP.setup("vimls", {})

RG = function(query, fullscreen)
  local command_format =
    "rg --glob '!yarn.lock' --glob '!package-lock.json' --glob '!.git' --hidden --column --line-number --no-heading --color=always --smart-case %s || true"
  local initial_command = vim.fn.printf(command_format, vim.fn.shellescape(query))
  local reload_command = vim.fn.printf(command_format, "{q}")
  local spec = {
    options = {"--disabled", "--query", query, "--bind", "change:reload:" .. reload_command},
    window = {width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal"}
  }

  vim.fn["fzf#vim#grep"](initial_command, 1, vim.fn["fzf#vim#with_preview"](spec, "right"), fullscreen)
end

vim.cmd [[command! -nargs=* -bang RG lua RG(<q-args>, <bang>0)]]

augroup(
  "random",
  function(autocmd)
    autocmd [[BufWritePost plugins.lua PackerCompile]]
    autocmd [[User FloatermOpen execute "normal G" | wincmd p]]
    autocmd [[VimResized * :wincmd =]]
    autocmd [[GUIEnter * set visualbell t_vb=]]
    autocmd [[FileType netrw :lua RemoveNetrwMap()]]
    autocmd [[BufRead,BufNewFile *.zsh-theme set filetype=zsh]]
    autocmd [[BufRead,BufNewFile aliases.local set filetype=zsh]]
    autocmd [[BufRead,BufNewFile *.lexs set filetype=elixir]]
  end
)

augroup(
  "clojure",
  function(autocmd)
    autocmd [[BufWritePost *.clj :silent Require]]
  end
)

augroup(
  "markdown",
  function(autocmd)
    autocmd [[BufRead,BufNewFile *.md setlocal spell]]
    autocmd [[BufRead,BufNewFile *.md setlocal linebreak]]
  end
)

vim.cmd [[let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$']]
