local nnoremap = require("motch.utils").nnoremap
local _ = require("underscore")

vim.cmd([[command! ZkDaily :term zk daily]])

local colors = require("ansicolors")

local zk = {}

zk.note_picker = function(source)
  local notes = vim.fn.system(source)

  if vim.fn.trim(notes) == "" then
    notes = "[]"
  end

  notes = vim.fn.json_decode(notes)

  notes = _.map(notes, function(n)
    local tags = _.join(
      _.map(n.tags, function(t)
        return "#" .. t
      end),
      " "
    )

    return colors.noReset("%{bright}%{yellow}")
      .. n.title
      .. colors("%{reset}")
      .. " "
      .. ":"
      .. " "
      .. tags
      .. " "
      .. ":"
      .. " "
      .. n.absPath
  end)

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
      require("lspconfig/configs").zk.new({ title = query })
    end,
  }

  FZF({
    source = notes,
    sinklist = function(selected)
      local query = selected[1]
      local action = actions[selected[2]]
      local parts = vim.fn.split(selected[3], ":")

      action(parts[#parts], query)
    end,
    options = {
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
    },
    window = { width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal" },
  })
end

zk.list = function()
  zk.note_picker("zk list --quiet -f json --sort=created")
end

zk.tags = function()
  local tags = vim.fn.system("zk tag list --quiet -f json")

  tags = _.map(vim.fn.json_decode(tags), function(t)
    return t.name
  end)

  FZF({
    source = tags,
    sink = function(tag)
      zk.note_picker(string.format("zk list --quiet -f json --sort=created --tag %s", tag))
    end,
    options = { "--ansi", "--prompt", "Tags> " },
    window = { width = 0.9, height = 0.6, yoffset = 0, highlight = "Normal" },
  })
end

zk.backlinks = function()
  zk.note_picker(string.format("zk list --quiet -f json --sort=created --link-to %s", vim.fn.expand("%")))
end

zk.links = function()
  zk.note_picker(string.format("zk list --quiet -f json --sort=created --linked-by %s", vim.fn.expand("%")))
end

_G.motch.zk = zk

local dir = require("lspconfig").util.root_pattern(".zk")(vim.fn.getcwd())
if type(dir) == "string" then
  nnoremap("<C-p>", ":lua motch.zk.list()<cr>")
  nnoremap("<space>zt", ":lua motch.zk.tags()<cr>")
  nnoremap("<space>zb", ":lua motch.zk.backlinks()<cr>")
  nnoremap("<space>zl", ":lua motch.zk.links()<cr>")
  nnoremap("<space>zd", ":ZkDaily<cr>")
end
