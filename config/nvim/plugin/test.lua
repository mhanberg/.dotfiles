local system = vim.fn.system
vim.keymap.set("n", "<leader>n", ":TestNearest<cr>")
vim.keymap.set("n", "<leader>f", ":TestFile<cr>")
vim.keymap.set("n", "<leader>s", ":TestSuite<cr>")
vim.keymap.set("n", "<leader>l", ":TestLast<cr>")

local nil_buf_id = 999999
local term_buf_id = nil_buf_id

local vim_notify_notfier = function(exit)
  if exit == 0 then
    vim.notify("Success: " .. cmd, vim.log.levels.INFO)
  else
    vim.notify("Fail: " .. cmd, vim.log.levels.ERROR)
  end
end
local terminal_notifier_notfier = function(cmd, exit)
  if exit == 0 then
    system(string.format([[terminal-notifier -title "Neovim" -subtitle "%s" -message "Success!"]], cmd))
  else
    system(string.format([[terminal-notifier -title "Neovim" -subtitle "%s" -message "Fail!"]], cmd))
  end
end

vim.g.better_vim_test_runner_notifier = terminal_notifier_notfier

local function test(cmd)
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
      vim.g.better_vim_test_runner_notifier(cmd, exit_code)

      if exit_code == 0 then
        vim.api.nvim_buf_delete(term_buf_id, { force = true })
        term_buf_id = nil_buf_id
      end
    end,
  })

  vim.cmd([[normal! G]])
  vim.cmd([[wincmd p]])
end

-- vim.g["test#javascript#jest#executable"] = "bin/test"

vim.g["test#custom_strategies"] = { motch = test }
vim.g["test#strategy"] = "motch"
