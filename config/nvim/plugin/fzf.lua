vim.env.FZF_DEFAULT_OPTS = "--reverse"
vim.g.fzf_commands_expect = "enter"
vim.g.fzf_layout = {
  window = {
    width = 0.9,
    height = 0.6,
    yoffset = 0,
    highlight = "Normal",
  },
}
vim.g.fzf_buffers_jump = 1

vim.g.fzf_lsp_width = 70
vim.g.fzf_lsp_layout = {
  window = {
    width = 0.95,
    height = 0.95,
    yoffset = 0,
    highlight = "Normal",
  },
}
vim.g.fzf_lsp_preview_window = { "right:50%" }
vim.g.fzf_lsp_pretty = true

local fzf_grep = vim.fn["fzf#vim#grep"]

_G.motch.files = function()
  vim.fn["fzf#vim#files"](".", { window = { width = 119, height = 0.6, yoffset = 0, highlight = "Normal" } })
end

local live_grep = function(query, fullscreen, dir)
  local command_format =
    "rg --glob '!yarn.lock' --glob '!package-lock.json' --glob '!.git' --hidden --column --line-number --no-heading --color=always --smart-case %s || true"
  local initial_command = vim.fn.printf(command_format, vim.fn.shellescape(query))
  local reload_command = vim.fn.printf(command_format, "{q}")
  local spec = {
    options = { "--disabled", "--query", query, "--bind", "change:reload:" .. reload_command },
    window = { width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal" },
    dir = dir,
  }

  fzf_grep(initial_command, 1, vim.fn["fzf#vim#with_preview"](spec, "right"), fullscreen)
end

_G.motch.local_project_search = function(query, fullscreen)
  live_grep(query, fullscreen)
end

vim.cmd([[command! -nargs=* -bang LocalProjectSearch lua motch.local_project_search(<q-args>, <bang>0)]])

_G.motch.global_project_search = function(query, fullscreen)
  live_grep(query, fullscreen, "~/src")
end

_G.motch.projects = function()
  FZF {
    source = [[fd --type d --hidden --glob ".git" /Users/mitchellhanberg/src --exec echo {} | rev | cut -c 6- - | rev]],
    sink = function(selection)
      vim.api.nvim_set_current_dir(selection)
      vim.cmd([[Files]])
    end,
  }
end

_G.motch.todos = function()
  FZF {
    source = [[rg --vimgrep '^\s+# TODO:']],
    options = {
      "--delimiter",
      ":",
    },
    sink = function(selection)
      vim.api.nvim_set_current_dir(selection)
      vim.cmd([[Files]])
    end,
  }
end
