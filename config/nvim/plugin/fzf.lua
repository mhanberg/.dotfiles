local _ = require("underscore")
local fzf = require("fzf").fzf

vim.env.FZF_DEFAULT_OPTS = "--reverse"
vim.g.fzf_preview_window = {}
vim.g.fzf_layout = {
  window = {
    width = 119,
    height = 0.6,
    yoffset = 0,
    highlight = "Normal",
  },
}
vim.g.fzf_buffers_jump = 1

-- local cd = function(path, callback)
--   vim.cmd(string.format("cd %q", vim.fn.expand(path)))
--   NVIM.print("before callback")
--   pcall(callback)
--   NVIM.print("after callback")
--   vim.cmd [[cd!]]
-- end

local calculate_height = function(height)
  local lines = relative and vim.fn.winheight(0) or (vim.opt.lines:get() - vim.fn.has("nvim"))
  return vim.fn.min({
    vim.fn.max({ 4, (height > 1) and height or vim.fn.float2nr(lines * height) }),
    lines,
  })
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

  vim.fn["fzf#vim#grep"](initial_command, 1, vim.fn["fzf#vim#with_preview"](spec, "right"), fullscreen)
end

_G.motch.local_project_search = function(query, fullscreen)
  live_grep(query, fullscreen)
end

vim.cmd([[command! -nargs=* -bang LocalProjectSearch lua motch.local_project_search(<q-args>, <bang>0)]])

_G.motch.global_project_search = function(query, fullscreen)
  live_grep(query, fullscreen, "~/Development")
end

vim.cmd([[command! -nargs=* -bang GlobalProjectSearch lua motch.global_project_search(<q-args>, <bang>0)]])

local proj_config = vim.fn.json_decode(vim.fn.readfile(vim.fn.expand("~/.dotfiles/projects.json")))
local projects = _.map(proj_config, function(k, v)
  return k
end)

vim.api.nvim_exec(
  [[
function! FzfWrapHelper(opts)
  call fzf#run(fzf#wrap(a:opts))
endfunction
]],
  false
)

_G.motch.change_project = function()
  vim.fn["FzfWrapHelper"]({
    source = projects,
    sink = function(selected)
      vim.fn.execute("cd " .. selected, "silent")
    end,
    options = { "--with-nth", "1", "--delimiter", ":" },
  })
end

-- TABS = function()
--   local source = _.map(vim.api.nvim_list_tabpages(), function(handle)
--     local err, name = pcall(vim.api.nvim_tabpage_get_var, handle, "name")

--     return (handle .. ":" .. (name or "NO NAME"))
--   end)

--   vim.fn["FzfWrapHelper"]({
--     source = source,
--     sink = function(selected)
--       local parts = vim.fn.split(selected, ":")
--       local handle = parts[1]

--       vim.api.nvim_set_current_tabpage(handle)
--     end,
--     options = { "--with-nth", "2", "--delimiter", ":" },
--   })
-- end

-- MARK_TAB = function()
--   vim.g.tabs = _.extend(vim.g.tabs or {}, { [vim.api.nvim_tabpage_get_number(0)] =

-- end

-- CUSTOM = function()
--   local result = vim.fn.system([[fd --base-directory "$HOME/Development" --max-depth 1 .]])
--   local projects = _.chain(vim.fn.split(result, "\n")):push(".dotfiles"):push("work-notes"):push("notes"):value()
--   coroutine.wrap(function()
--     -- NVIM.print(projects)
--     fzf(projects, "--ansi", {
--       window_on_create = function()
--         vim.cmd("set winhl=Normal:Normal")
--       end,
--       width = 119,
--       height = calculate_height(0.6),
--       row = 0,
--     })
--   end)()
-- end
