vim.env.FZF_DEFAULT_OPTS = "--reverse"
vim.g.fzf_preview_window = {}
vim.g.fzf_layout = {
  window = {
    width = 119,
    height = 0.6,
    yoffset = 0,
    highlight = "Normal"
  }
}
vim.g.fzf_buffers_jump = 1

RG = function(query, fullscreen)
  local command_format =
    "rg --glob '!yarn.lock' --glob '!package-lock.json' --glob '!.git' --hidden --column --line-number --no-heading --color=always --smart-case %s || true"
  local initial_command = vim.fn.printf(command_format, vim.fn.shellescape(query))
  local reload_command = vim.fn.printf(command_format, "{q}")
  local spec = {
    options = {"--disabled", "--query", query, "--bind", "change:reload:" .. reload_command},
    window = {width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal"}
  }

  vim.fn["fzf#vim#grep"](initial_command, 1, vim.fn["fzf#vim#with_preview"](spec, "right"), fullscreen)
end

vim.cmd [[command! -nargs=* -bang RG lua RG(<q-args>, <bang>0)]]
