local dnd = {}

local zk = require("zk")

dnd.previous_session = function()
  local err, current_session = zk.get(vim.fn.expand("%"), { "title", "absPath", "created" })

  if err then
    vim.api.nvim_err_write("[zk] Error fetching the current session's note: " .. vim.inspect(err))
    return
  end

  local previous_session_err, previous_session = zk.list({
    select = { "title", "path", "filenameStem" },
    excludeHrefs = { current_session.absPath },
    createdBefore = current_session.created,
    tags = { "dnd", "session" },
    limit = 1,
    sort = { "created" },
  })

  if previous_session_err then
    vim.api.nvim_err_write("[zk] Error fetching the previous session's note: " .. vim.inspect(previous_session_err))
    return
  end

  if #previous_session == 0 then
    vim.api.nvim_err_writeln("[dnd] No previous session!")
    return
  end

  return previous_session[1]
end

dnd.next_session = function()
  local err, current_session = zk.get(vim.fn.expand("%"), { "title", "absPath", "created" })

  if err then
    vim.api.nvim_err_write("[zk] Error fetching the current session's note: " .. vim.inspect(err))
    return
  end

  local params = {
    select = { "title", "path", "filenameStem" },
    excludeHrefs = { current_session.absPath },
    createdAfter = current_session.created,
    tags = { "dnd", "session" },
    limit = 1,
    sort = { "created+" },
  }

  local next_session_err, next_session = zk.list(params)

  if next_session_err then
    vim.api.nvim_err_write("[zk] Error fetching the next session's note: " .. vim.inspect(next_session_err))
    return nil
  end

  if #next_session == 0 then
    vim.api.nvim_err_writeln("[dnd] No next session!")
    return nil
  end

  return next_session[1]
end

dnd.move_to = function(direction)
  local note
  if direction == "next" then
    note = dnd.next_session()
  elseif direction == "previous" then
    note = dnd.previous_session()
  end

  if note ~= nil then
    vim.cmd("e " .. note.path)
  end
end

dnd.insert_link = function(note)
  vim.cmd('exe "normal \\<esc>i[' .. note.title .. "](" .. note.filenameStem .. [[)"]])
end

vim.cmd([[command! InsertPreviousSessionLink lua motch.dnd.insert_link(motch.dnd.previous_session())]])

_G.motch.dnd = dnd
