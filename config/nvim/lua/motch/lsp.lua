M = {}

local has_run = {}

local signs = {
  Error = "✘", -- x000f015a
  Warn = "󰀪", -- x000f002a
  Info = "󰋽", -- x000f02fd
  Hint = "󰌶", -- x000f0336
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

M.navic = function()
  if package.loaded["nvim-navic"] then
    local navic = require("nvim-navic")
    local loc = navic.get_location()
    if loc and #loc > 0 then
      return "%#NavicSeparator#> " .. navic.get_location()
    else
      return ""
    end
  else
    return ""
  end
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.setup = function(name, opts)
  if not has_run[name] then
    has_run[name] = true

    local lspconfig = require("lspconfig")
    lspconfig[name].setup(vim.tbl_extend("force", {
      log_level = vim.lsp.protocol.MessageType.Log,
      message_level = vim.lsp.protocol.MessageType.Log,
      capabilities = M.capabilities,
    }, opts))
  end
end

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
  -- if require("vim.lsp.log").should_log(convert_lsp_log_level_to_neovim_log_level(result.type)) then
  -- vim.print(result.message)
  vim.notify(result.message, vim.log.levels[levels[result.type]])
  -- end
end

M.default_config = function(name)
  return require("lspconfig.server_configurations." .. name).default_config
end

vim.lsp.set_log_level(2)

return M
