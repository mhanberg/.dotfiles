local colors = require("ansicolors")
local nnoremap = require("motch.utils").nnoremap
local zk = require("motch.zk")

local notes = {}

local prepend_hash = function(str)
  return "#" .. str
end

local default_opts = function(opts)
  return vim.tbl_extend("force", { select = { "title", "tags", "absPath" }, sort = { "created" } }, opts or {})
end

local actions = {
  ["enter"] = function(selected)
    vim.fn.execute("edit " .. selected)
  end,
  ["ctrl-v"] = function(selected)
    vim.fn.execute("vsplit " .. selected)
  end,
  ["ctrl-x"] = function(selected)
    vim.fn.execute("split " .. selected)
  end,
  ["ctrl-n"] = function(_, query)
    zk.new({ title = query })
  end,
}

local options = {
  "--expect",
  "enter,ctrl-v,ctrl-x,ctrl-n",
  "--header",
  colors("%{blue}CTRL-N: create a note with the query as title"),
  "--print-query",
  "--ansi",
  "--delimiter",
  ":",
  "--preview",
  "bat {-1}",
  "--nth",
  "1..2",
  "--prompt",
  "Notes> ",
}

local to_note_entry = function(n)
  local sep = " "
  local tags = vim.fn.join(vim.tbl_map(prepend_hash, n.tags or {}), sep)

  return colors.noReset("%{bright}%{yellow}") .. n.title .. colors("%{reset}") .. " : " .. tags .. " : " .. n.absPath
end

notes.find = function(...)
  zk.list(default_opts(...), function(err, result)
    if err then
      vim.api.nvim_err_write("[zk] Error fetching notes: " .. vim.inspect(err))

      return
    end

    if #result == 0 then
      vim.api.nvim_err_writeln("[zk] No notes found!")

      return
    end

    FZF({
      source = vim.tbl_map(to_note_entry, result),
      sinklist = function(selected)
        local query = selected[1]
        local action = actions[selected[2]]
        local parts = vim.fn.split(selected[3], ":")

        action(parts[#parts], query)
      end,
      options = options,
      window = { width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal" },
    })
  end)
end

notes.find_by_tag = function()
  zk["tag.list"](nil, function(err, result)
    if err then
      vim.api.nvim_err_write("[zk] Error fetching tags: " .. vim.inspect(err))
      return
    end

    local tags = vim.tbl_map(function(t)
      return t.name
    end, result)

    FZF({
      source = tags,
      sink = function(tag)
        notes.find({ tags = { tag } })
      end,
      options = { "--ansi", "--prompt", "Tags> " },
      window = { width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal" },
    })
  end)
end

_G.motch.notes = notes

local dir = require("lspconfig").util.root_pattern(".zk")(vim.fn.getcwd())
if type(dir) == "string" then
  vim.cmd([[command! ZkDaily :term zk daily]])
  nnoremap("<C-p>", [[:lua motch.notes.find()<cr>]])
  nnoremap("<space>zt", [[:lua motch.notes.find_by_tag()<cr>]])
  nnoremap("<space>zb", [[:lua motch.notes.find({linkTo = {vim.fn.expand("%")}})<cr>]])
  nnoremap("<space>zl", [[:lua motch.notes.find({linkedBy = {vim.fn.expand("%")}})<cr>]])
  nnoremap("<space>zd", ":ZkDaily<cr>")
end
