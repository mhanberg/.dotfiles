local lspconfig = require("lspconfig")

M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local has_run = {}

local navic = require("nvim-navic")

navic.setup {
  depth_limit = 5,
}

M.on_attach = function(client, bufnr)
  local map_opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "df", vim.lsp.buf.format, map_opts)
  vim.keymap.set("n", "gd", vim.diagnostic.open_float, map_opts)
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

  vim.cmd([[imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
  vim.cmd([[smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])

  require("cmp_nvim_lsp").default_capabilities(capabilities)

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local cmp = require("cmp")

cmp.setup {
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-y>"] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "vim-dadbod-completion" },
    { name = "spell", keyword_length = 5 },
    -- { name = "rg", keyword_length = 3 },
    -- { name = "buffer", keyword_length = 5 },
    -- { name = "emoji" },
    { name = "path" },
    { name = "gh_issues" },
  },
  formatting = {
    format = require("lspkind").cmp_format {
      with_text = true,
      menu = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        -- emoji = "[Emoji]",
        spell = "[Spell]",
        path = "[Path]",
        cmdline = "[Cmd]",
      },
    },
  },
}

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", keyword_length = 2 } }),
})

M.setup = function(name, opts)
  if not has_run[name] then
    has_run[name] = true

    lspconfig[name].setup(vim.tbl_extend("force", {
      log_level = vim.lsp.protocol.MessageType.Log,
      message_level = vim.lsp.protocol.MessageType.Log,
      capabilities = capabilities,
      on_attach = M.on_attach,
    }, opts))
  end
end

vim.lsp.set_log_level(2)

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

vim.lsp.handlers["window/showMessage"] = function(_, result)
  if require("vim.lsp.log").should_log(convert_lsp_log_level_to_neovim_log_level(result.type)) then
    vim.notify(result.message, levels[result.type])
  end
end

M.default_config = function(name)
  return require("lspconfig.server_configurations." .. name).default_config
end

return M
