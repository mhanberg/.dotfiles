M = {}

if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

M.augroup = function(name, callback)
  vim.cmd("augroup " .. name)
  vim.cmd("autocmd!")
  callback(function(cmd)
    vim.cmd("autocmd " .. cmd)
  end)
  vim.cmd("augroup END")
end

local scopes = { o = vim.o, b = vim.bo, w = vim.wo, g = vim.g }

local set_opt = function(scope, key, value)
  scopes[scope][key] = value
  if scope ~= "o" and scope ~= "g" then
    scopes["o"][key] = value
  end
end

M.opt = {
  o = function(key, value)
    set_opt("o", key, value)
  end,
  b = function(key, value)
    set_opt("b", key, value)
  end,
  w = function(key, value)
    set_opt("w", key, value)
  end,
  g = function(key, value)
    set_opt("g", key, value)
  end,
}

M.nnoremap = function(from, to, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.api.nvim_set_keymap("n", from, to, opts)
end

M.bufnnoremap = function(from, to, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.api.nvim_buf_set_keymap(0, "n", from, to, opts)
end

M.imap = function(from, to, opts)
  vim.api.nvim_set_keymap("i", from, to, opts or {})
end

M.inoremap = function(from, to, opts)
  opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.api.nvim_set_keymap("i", from, to, opts)
end

M.smap = function(from, to, opts)
  vim.api.nvim_set_keymap("s", from, to, opts or {})
end

return M
