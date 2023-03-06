local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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

autocmd("FileType", {
  group = random,
  pattern = "yaml",
  callback = function()
    -- vim.bo.commentstring = "# %s"
    vim.lsp.start {
      name = "YAML Language Server",
      cmd = { "yaml-language-server", "--stdio" },
      root_dir = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1]),
      settings = {
        redhat = { telemetry = { enabled = false } },
      },
      capabilities = require("motch.lsp").capabilities,
      on_attach = require("motch.lsp").on_attach,
    }
  end,
})
autocmd("FileType", {
  group = random,
  pattern = "raml",
  callback = function()
    local jobid = vim.fn.jobstart("als --port 9000 --listen")

    if jobid > 0 then
      vim.wait(1000, function() end)
      vim.lsp.start {
        name = "ALS",
        cmd = vim.lsp.rpc.connect("127.0.0.1", 9000),
        root_dir = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1]),
        settings = {},
        capabilities = require("motch.lsp").capabilities,
        on_attach = require("motch.lsp").on_attach,
      }
    else
      vim.notify("Couldn't start ALS", vim.log.levels.WARN)
    end
  end,
})

autocmd("FileType", {
  group = random,
  pattern = "netrw",
  callback = function()
    if vim.fn.hasmapto("<Plug>NetrwRefresh") > 0 then
      vim.cmd([[unmap <buffer> <C-l>]])
    end
  end,
})
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
