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

vim.cmd [[highlight! link @symbol Blue]]
vim.cmd [[highlight! link @constant PurpleItalic]]
