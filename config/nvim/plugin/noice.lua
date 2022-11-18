require("noice").setup {
  cmdline = {
    enabled = true, -- disable if you use native command line UI
    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    opts = { buf_options = { filetype = "vim" } }, -- enable syntax highlighting in the cmdline
    icons = {
      ["/"] = { icon = " " },
      ["?"] = { icon = " " },
      [":"] = { icon = ":", firstc = false },
    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = 1,
        col = "50%",
      },
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "search_count",
      },
      opts = { skip = true },
    },
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    {
      view = "mini",
      filter = {
        find = "search hit BOTTOM, continuing at TOP",
      },
    },
    {
      view = "mini",
      filter = {
        find = "E486",
      },
    },
    {
      view = "mini",
      filter = {
        find = "change; before #",
      },
    },
    {
      view = "mini",
      filter = {
        find = "line less; before #",
      },
    },
    {
      view = "mini",
      filter = {
        find = "lines yanked",
      },
    },
    {
      view = "mini",
      filter = {
        find = "more lines",
      },
    },
    {
      view = "mini",
      filter = {
        find = "more line; before #",
      },
    },
    {
      view = "mini",
      filter = {
        find = "fewer lines; before #",
      },
    },
    {
      view = "mini",
      filter = {
        find = "fewer lines",
      },
    },
    {
      view = "mini",
      filter = {
        find = "changes; before #",
      },
    },
    {
      view = "mini",
      filter = {
        find = "Already at newest change",
      },
    },
    {
      view = "mini",
      filter = {
        find = "mix test ",
      },
    },
  },
}
