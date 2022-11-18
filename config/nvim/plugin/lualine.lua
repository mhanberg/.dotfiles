-- local theme = require("thicc_forest.lualine")

require("lualine").setup({
  options = { globalstatus = true, theme = "everforest" },
  extensions = { "fzf" },
  sections = {
    lualine_c = { { "filename", path = 1 } },
  },
})
