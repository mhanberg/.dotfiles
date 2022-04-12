local system = vim.fn.system
vim.keymap.set("n", "<leader>n", ":TestNearest<cr>")
vim.keymap.set("n", "<leader>f", ":TestFile<cr>")
vim.keymap.set("n", "<leader>s", ":TestSuite<cr>")
vim.keymap.set("n", "<leader>l", ":TestLast<cr>")

local vim_notify_notfier = function(exit)
  if exit == 0 then
    vim.notify("Success: " .. cmd, vim.log.levels.INFO)
  else
    vim.notify("Fail: " .. cmd, vim.log.levels.ERROR)
  end
end
local terminal_notifier_notfier = function(cmd, exit)
  if exit == 0 then
    print("Success!")
    system(string.format([[terminal-notifier -title "Neovim" -subtitle "%s" -message "Success!"]], cmd))
  else
    print("Failure!")
    system(string.format([[terminal-notifier -title "Neovim" -subtitle "%s" -message "Fail!"]], cmd))
  end
end

-- vim.g["test#javascript#jest#executable"] = "bin/test"

vim.g["test#custom_strategies"] = {
  motch = function(cmd)
    local winnr = vim.fn.winnr()
    require("motch.term").open(cmd, winnr, terminal_notifier_notfier)
  end,
}
vim.g["test#strategy"] = "motch"
