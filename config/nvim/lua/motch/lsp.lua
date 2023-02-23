local lspconfig = require("lspconfig")

M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local has_run = {}

local navic = require("nvim-navic")

navic.setup {
  highlight = true,
  safe_output = true,
}

M.navic = function()
  local loc = navic.get_location()
  if loc and #loc > 0 then
    return "> " .. navic.get_location()
  else
    return ""
  end
end

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
  vim.keymap.set("n", "<space>r", vim.lsp.codelens.run, map_opts)

  vim.cmd([[imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
  vim.cmd([[smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])

  require("cmp_nvim_lsp").default_capabilities(capabilities)

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

M.setup = function(name, opts)
  if not has_run[name] then
    has_run[name] = true

    local lspconfig = require("lspconfig")
    lspconfig[name].setup(vim.tbl_extend("force", {
      log_level = vim.lsp.protocol.MessageType.Log,
      message_level = vim.lsp.protocol.MessageType.Log,
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        if client.server_capabilities.codelensProvider then
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
          vim.lsp.codelens.refresh()
        end
        M.on_attach(client, bufnr)
      end,
    }, opts))
  end
end

M.capabilities = capabilities

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

vim.lsp.set_log_level(0)

return M
