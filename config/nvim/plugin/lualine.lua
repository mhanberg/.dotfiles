local theme = require("thicc_forest.lualine")

require("lualine").setup({ options = { theme = theme }, extensions = { "fzf" } })
