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

vim.cmd([[highlight! link @symbol Blue]])
vim.cmd([[highlight! link @constant PurpleItalic]])

local palette = vim.fn["everforest#get_palette"]("medium", vim.g.everforest_colors_override)

vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, fg = palette.fg[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, fg = palette.yellow[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, fg = palette.fg[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, fg = palette.fg[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, fg = palette.blue[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, fg = palette.green[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, fg = palette.green[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, fg = palette.blue[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, fg = palette.purple[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, fg = palette.purple[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, fg = palette.green[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, fg = palette.purple[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsKeyword", { default = true, fg = palette.purple[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, fg = palette.green[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, fg = palette.orange[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, fg = palette.fg[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, fg = palette.green[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicText", { default = true, fg = palette.fg[1], bg = nil })
vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, fg = palette.fg[1], bg = nil })
