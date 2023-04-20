M = {}

local has_run = {}

M.navic = function()
  local navic = require("nvim-navic")
  local loc = navic.get_location()
  if loc and #loc > 0 then
    return "%#NavicSeparator#> " .. navic.get_location()
  else
    return ""
  end
end

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
  if require("vim.lsp.log").should_log(convert_lsp_log_level_to_neovim_log_level(result.type)) then
    vim.notify(result.message, levels[result.type])
  end
end

M.default_config = function(name)
  return require("lspconfig.server_configurations." .. name).default_config
end

-- vim.lsp.set_log_level(0)

return M
