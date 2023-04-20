local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local random = augroup("random", { clear = true })

autocmd("FileType", { pattern = "fzf", group = "random", command = "setlocal winhighlight+=Normal:Normal" })
autocmd("VimResized", { group = random, pattern = "*", command = "wincmd =" })
autocmd("GUIEnter", {
  group = random,
  pattern = "*",
  callback = function()
    vim.opt.visualbell = "t_vb="
  end,
})

autocmd("LspAttach", {
  group = augroup("lsp", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local map_opts = { buffer = bufnr, silent = true }

    vim.keymap.set("n", "df", vim.lsp.buf.format, map_opts)
    vim.keymap.set("n", "gd", vim.diagnostic.open_float, map_opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, map_opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, map_opts)

    vim.keymap.set("n", "dt", vim.lsp.buf.definition, map_opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, map_opts)
    vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, map_opts)
    vim.keymap.set("n", "gr", ":References<cr>", map_opts)
    vim.keymap.set("n", "gi", ":Implementations<cr>", map_opts)
    vim.keymap.set("n", "g0", ":DocumentSymbols<cr>", map_opts)
    vim.keymap.set("n", "g7", ":WorkspaceSymbols<cr>", map_opts)
    vim.keymap.set("n", "<leader>dd", ":Diagnostics<cr>", map_opts)
    vim.keymap.set("n", "<leader>da", ":DiagnosticsAll<cr>", map_opts)
    vim.keymap.set("n", "<space>r", vim.lsp.codelens.run, map_opts)

    vim.cmd([[imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
    vim.cmd([[smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
    if client.server_capabilities.codelensProvider then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })
      vim.lsp.codelens.refresh()
    end

    require("cmp_nvim_lsp").default_capabilities(require("motch.lsp").capabilities)

    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
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
        yaml = {
          keyOrdering = false,
          schemaStore = { enable = true },
        },
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

    if vim.fn.hasmapto("<Plug>NetrwHideEdit") > 0 then
      vim.cmd([[unmap <buffer> <C-h>]])
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
