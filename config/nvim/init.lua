require("plugins")

local augroup = require("utils").augroup
local nnoremap = require("utils").nnoremap
local opt = require("utils").opt

function RemoveNetrwMap()
  if vim.fn.hasmapto("<Plug>NetrwRefresh") > 0 then
    vim.cmd [[unmap <buffer> <C-l>]]
  end
end

function SetWordCount(file_name)
  local file = vim.fn.expand(file_name)
  local count = vim.trim(vim.fn.system("cat " .. file .. ", | wc -w"))

  opt.b("word_count", count)
end

function GetWordCount()
  return vim.b.word_count or ""
end

NVIM = require("nvim")

opt.o("foldmethod", "syntax")
opt.o("foldlevelstart", 99)
opt.o("smartindent", true)
opt.b("tabstop", 2)
opt.b("shiftwidth", 2)
opt.b("expandtab", true)
opt.w("number", true)
opt.o("termguicolors", true)
opt.o("backupdir", vim.fn.expand("~/.tmp/backup"))
opt.o("directory", vim.fn.expand("~/.tmp/swp"))
opt.o("splitbelow", true)
opt.o("splitright", true)
opt.o("lazyredraw", true)
opt.o("showmode", false)
opt.o("incsearch", true)
opt.o("ignorecase", true)
opt.o("smartcase", true)
opt.o("undofile", true)
opt.o("undodir", vim.fn.expand("~/.tmp"))
opt.o("mouse", "a")
opt.o("errorbells", false)
opt.o("visualbell", true)
opt.o("t_vb", "")
opt.o("cursorline", true)
opt.o("inccommand", "nosplit")
opt.o("background", "dark")
opt.o("autoread", true)
opt.g("forest_night_enable_italic", 1)
opt.g("forest_night_diagnostic_text_highlight", 1)

-- vim.cmd [[color forest-night]]
vim.cmd [[color thicc_forest]]

opt.g("indentLine_fileTypeExclude", {"json"})
opt.g("indentLine_char", "│")

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
nnoremap("<leader>sv", [[:luafile $MYVIMRC<cr> | echo "Sourced $MYVIMRC"]])
nnoremap("<c-p>", ":Files<cr>")
nnoremap("gl", ":BLines<cr>")
nnoremap("<leader>a", ":RG<cr>")
nnoremap("<leader>gr", ":grep<cr>")
nnoremap("<leader>c", ":botright copen 20<cr>")
nnoremap("<leader>gd", ":silent !tmux popup -K -w '90\\%' -h '90\\%' -R 'git diff'<cr>")
nnoremap("<leader>gs", ":silent !tmux popup -K -w '90\\%' -h '90\\%' -R 'git status'<cr>")

opt.g("dispatch_handlers", {"job"})
opt.g("test#strategy", "floaterm")
opt.g("floaterm_wintype", "split")
opt.g("floaterm_height", 0.3)
opt.g("floaterm_autoclose", 1)
opt.g("floaterm_autoinsert", false)

nnoremap("<leader>n", ":TestNearest<cr>")
nnoremap("<leader>f", ":TestFile<cr>")
nnoremap("<leader>s", ":TestSuite<cr>")
nnoremap("<leader>l", ":TestLast<cr>")

-- ctags
nnoremap("<leader>ct", ":!ctags -R .<cr>")
nnoremap("<leader>t", ":Tags<cr>")
nnoremap("<leader>r", ":BTags")

opt.o("completeopt", "menuone,noinsert,noselect")
opt.g("completion_enable_snippet", "vim-vsnip")

opt.g("blamer_enabled", 1)
opt.g("blamer_relative_time", 1)

require("treesitter")

opt.o("grepprg", "ag --vimgrep -Q $*")
opt.o("grepformat", "%f:%l:%c:%m")

opt.g("jsx_ext_required", 0)

nnoremap("<leader>gy", ":Goyo<cr>")
opt.g("goyo_width", 120)
opt.g("goyo_height", 100)

opt.g("markdown_syntax_conceal", 0)

opt.g("Hexokinase_optInPatterns", {"full_hex", "triple_hex", "rgb", "rgba", "hsl", "hsla"})

local LSP = require("lsp")

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

LSP.setup("efm", {})
LSP.setup("rust_analyzer", {})
LSP.setup("solargraph", {})
LSP.setup("omnisharp", {})
LSP.setup("tsserver", {})
LSP.setup("vimls", {})

RG = function(query, fullscreen)
  command_format = "rg --glob '!yarn.lock' --glob '!package-lock.json' --glob '!.git' --hidden --column --line-number --no-heading --color=always --smart-case %s || true"
  initial_command = vim.fn.printf(command_format, vim.fn.shellescape(query))
  reload_command = vim.fn.printf(command_format, "{q}")
  spec = {
    options = {"--disabled", "--query", query, "--bind", "change:reload:"..reload_command},
    window = {width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal"}
  }

  vim.fn["fzf#vim#grep"](initial_command, 1, vim.fn["fzf#vim#with_preview"](spec, "right"), fullscreen)
end

vim.cmd [[command! -nargs=* -bang RG lua RG(<q-args>, <bang>0)]]

augroup(
  "random",
  function(autocmd)
    autocmd "User FloatermOpen wincmd p"
    autocmd "VimResized * :wincmd ="
    autocmd "GUIEnter * set visualbell t_vb="
    autocmd "FileType netrw :lua RemoveNetrwMap()"
    autocmd "BufRead,BufNewFile *.zsh-theme set filetype=zsh"
    autocmd "BufRead,BufNewFile aliases.local set filetype=zsh"
    autocmd "BufRead,BufNewFile *.lexs set filetype=elixir"
  end
)

augroup(
  "clojure",
  function(autocmd)
    autocmd "BufWritePost *.clj :silent Require"
  end
)

augroup(
  "markdown",
  function(autocmd)
    autocmd "BufRead,BufNewFile *.md setlocal spell"
    autocmd "BufRead,BufNewFile *.md setlocal linebreak"
    autocmd "BufRead,BufNewFile,BufWritePost *.md lua SetWordCount('%:p')"
  end
)

-- vim.fn["cyclist#add_listchar_option_set"](
--   "default",
--   {
--     eol = "↲",
--     tab = "» ",
--     space = "",
--     trail = "𝁢",
--     extends = "…",
--     precedes = "…",
--     conceal = "┊",
--     nbsp = "☠"
--   }
-- )

vim.cmd [[let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$']]
