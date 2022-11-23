local silicon_utils = require("silicon.utils")
vim.api.nvim_create_augroup("SiliconRefresh", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  group = "SiliconRefresh",
  callback = function()
    silicon_utils.build_tmTheme()
    silicon_utils.reload_silicon_cache { async = true }
  end,
  desc = "Reload silicon themes cache on colorscheme switch",
})

vim.opt.termguicolors = true

vim.g.everforest_diagnostic_virtual_text = "colored"
vim.g.everforest_enable_italic = true
vim.g.everforest_colors_override = {
  bg0 = { "#273433", "235" },
  bg1 = { "#394C4A", "236" },
  bg2 = { "#425755", "237" },
  bg3 = { "#4B6361", "238" },
  bg4 = { "#56716F", "239" },
}

vim.cmd.colorscheme("everforest")

vim.api.nvim_set_hl(0, "@symbol", { link = "Blue" })
vim.api.nvim_set_hl(0, "@constant", { link = "PurpleItalic" })
