-- manipulatePipes:d0d48vqO-ehk0_Aqle_CUF_Mfj0U86Nt

local M = {}

local get_cursor_position = function()
  local rowcol = vim.api.nvim_win_get_cursor(0)
  local row = rowcol[1] - 1
  local col = rowcol[2]

  return row, col
end

local manipulate_pipes = function(direction, client)
  local row, col = get_cursor_position()

  client.request_sync("workspace/executeCommand", {
    command = "manipulatePipes:serverid",
    arguments = { direction, "file://" .. vim.api.nvim_buf_get_name(0), row, col },
  }, nil, 0)
end

M.from_pipe = function(client)
  return function()
    manipulate_pipes("fromPipe", client)
  end
end

M.to_pipe = function(client)
  return function()
    manipulate_pipes("toPipe", client)
  end
end

return M
