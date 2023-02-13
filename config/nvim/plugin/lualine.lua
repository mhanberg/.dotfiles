-- local theme = require("thicc_forest.lualine")
--
-- local navic = require("nvim-navic")

require("lualine").setup {
  options = { globalstatus = true, theme = "everforest" },
  extensions = { "fzf" },
  sections = {
    lualine_c = { { "filename", path = 1 } },
    -- lualine_x = { { navic.get_location, cond = navic.is_available }, "filetype" },
  },
}
