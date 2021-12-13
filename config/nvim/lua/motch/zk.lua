local zk = {}

local default_callbacks = {
  new = function(err, result)
    if err then
      vim.api.nvim_err_write("[zk] Error creating new note: " .. vim.inspect(err))
      return
    end

    vim.cmd("edit " .. result.path)
  end,
}

setmetatable(zk, {
  __index = function(_, key)
    return function(args, callback)
      vim.lsp.buf_request(0, "workspace/executeCommand", {
        command = "zk." .. key,
        arguments = { vim.api.nvim_buf_get_name(0), args },
      }, callback or default_callbacks[key])
    end
  end,
})

return zk
