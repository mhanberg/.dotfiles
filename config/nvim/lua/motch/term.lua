local M = {}

local nil_buf_id = 999999
local term_buf_id = nil_buf_id
vim.g.motch_term_auto_close = true

function M.open(cmd, winnr, notifier)
  -- delete the current buffer if it's still open
  if vim.api.nvim_buf_is_valid(term_buf_id) then
    vim.api.nvim_buf_delete(term_buf_id, { force = true })
    term_buf_id = nil_buf_id
  end

  vim.cmd("botright new | lua vim.api.nvim_win_set_height(0, 15)")
  term_buf_id = vim.api.nvim_get_current_buf()
  vim.opt_local.number = false
  vim.opt_local.cursorline = false

  vim.fn.termopen(cmd, {
    on_exit = function(_jobid, exit_code, _event)
      if notifier then
        notifier(cmd, exit_code)
      end

      if vim.g.motch_term_auto_close and exit_code == 0 then
        vim.api.nvim_buf_delete(term_buf_id, { force = true })
        term_buf_id = nil_buf_id
      end
    end,
  })

  vim.notify(cmd, vim.log.levels.INFO)

  vim.cmd([[normal! G]])
  vim.cmd(winnr .. [[wincmd w]])
end

return M
