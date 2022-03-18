local theme = require("thicc_forest.lualine")

require("lualine").setup({
  options = { globalstatus = true, theme = theme },
  extensions = { "fzf" },
  sections = {
    lualine_c = { { "filename", path = 1 } },
  },
})
