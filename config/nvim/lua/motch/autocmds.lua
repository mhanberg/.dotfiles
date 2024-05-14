local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local random = augroup("random", { clear = true })

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
    assert(client, "LSP is yet to be found")
    local map_opts = function(override)
      vim.tbl_extend("force", { buffer = bufnr, silent = true }, override or {})
    end

    autocmd("BufWritePre", {
      group = random,
      buffer = bufnr,
      callback = function()
        require("conform").format { async = false, lsp_fallback = true, id = client.id }
        -- vim.lsp.buf.format()
        -- vim.lsp.buf.format { id = client.id }
      end,
    })

    local fzf = function(func, override)
      local opts = override or { winopts = { height = 0.9, width = 0.9 } }
      return function()
        require("fzf-lua")[func](opts)
      end
    end

    vim.keymap.set("n", "df", function()
      -- local range = nil
      -- if args.count ~= -1 then
      -- local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      -- range = {
      -- start = { args.line1, 0 },
      -- ["end"] = { args.line2, end_line:len() },
      -- }
      -- end
      require("conform").format { async = false, lsp_fallback = true, id = client.id }
      -- vim.lsp.buf.format { async = false }
      -- require("conform").format { async = false, lsp_fallback = true }
      -- vim.lsp.buf.format {
      --   filter = function(fmt_client)
      --     return fmt_client.name ~= "ElixirLS"
      --   end,
      -- }
    end, map_opts { desc = "Format file" })
    vim.keymap.set("n", "gd", vim.diagnostic.open_float, map_opts { desc = "Open diagnostic window" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, map_opts { desc = "Prev. diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, map_opts { desc = "Next diagnostic" })

    vim.keymap.set("n", "dt", vim.lsp.buf.definition, map_opts { desc = "Go to definition" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts { desc = "Show hover documentation" })
    vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, map_opts { desc = "Go to type definition" })
    vim.keymap.set("n", "gr", fzf("lsp_references"), map_opts { desc = "Find references" })
    vim.keymap.set("n", "gi", fzf("lsp_implementations"), map_opts { desc = "Find implementations" })
    vim.keymap.set("n", "g0", fzf("lsp_document_symbols"), map_opts { desc = "Document Symbols" })
    vim.keymap.set("n", "g7", fzf("lsp_workspace_symbols"), map_opts { desc = "Workspace Symbols" })
    vim.keymap.set("n", "<leader>ca", fzf("lsp_code_actions", {}), map_opts { desc = "Code Actions" })
    vim.keymap.set(
      "n",
      "<leader>dd",
      fzf("lsp_document_diagnostics"),
      map_opts { desc = "Buffer diagnostics" }
    )
    vim.keymap.set(
      "n",
      "<leader>da",
      fzf("lsp_workspace_diagnostics"),
      map_opts { desc = "Workspace diagnostics" }
    )
    vim.keymap.set("n", "<space>r", vim.lsp.codelens.run, map_opts { desc = "Run codelens" })

    vim.cmd([[imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
    vim.cmd([[smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])

    if client and client.name == "Next LS" then
      vim.keymap.set(
        "n",
        "<space>tp",
        ":Elixir nextls to-pipe<cr>",
        { desc = "Convert nested syntax to pipe syntax" }
      )

      vim.keymap.set(
        "n",
        "<space>fp",
        ":Elixir nextls from-pipe<cr>",
        { desc = "Convert pipe syntax to nested syntax" }
      )
    end
    if
      client and (client.server_capabilities.codeLensProvider or client.server_capabilities.codelensProvider)
    then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })
      vim.lsp.codelens.refresh()
    end

    if client and client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end

    if vim.lsp.inlay_hint and client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})

autocmd("ColorScheme", {
  group = random,
  pattern = "everforest",
  callback = function()
    local highlights = {
      ["@symbol.elixir"] = { link = "Blue" },
      ["@constant.elixir"] = { link = "PurpleItalic" },
    }

    for key, value in pairs(highlights) do
      vim.api.nvim_set_hl(0, key, value)
    end
  end,
})

autocmd({ "BufReadPre", "BufNewFile" }, {
  group = random,
  pattern = "GRAPHITE_PR_DESCRIPTION.md",
  callback = function()
    vim.treesitter.language.register("markdown", "octo")
  end,
})
autocmd("FileType", {
  group = random,
  pattern = "raml",
  callback = function()
    vim.bo.commentstring = "# %s"
    vim.lsp.start {
      name = "ALS",
      cmd = { "als", "--systemStream" },
      root_dir = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1]),
      settings = {},
      capabilities = require("motch.lsp").capabilities,
      on_attach = require("motch.lsp").on_attach,
    }
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
    vim.cmd.setlocal("winhighlight+=Normal:Normal")
    vim.keymap.set("t", "<esc>", "<C-c>", { buffer = 0, desc = "Exit fzf" })
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
