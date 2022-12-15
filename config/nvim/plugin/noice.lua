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
  messages = {
    backend = "mini",
  },
  notify = {
    backend = "mini",
  },
  lsp = {
    message = {
      view = "mini",
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
      filter = { find = "Scanning" },
      opts = { skip = true },
    },
  },
}
