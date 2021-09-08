local thicc_colors = require("lush_theme.thicc_forest.colors")

local colors = {
  black = { gui = thicc_colors.bg0.hex, cterm = "235", cterm16 = "0" },
  blue = { gui = thicc_colors.blue.hex, cterm = "39", cterm16 = "4" },
  cyan = { gui = thicc_colors.cyan.hex, cterm = "38", cterm16 = "6" },
  green = { gui = thicc_colors.green.hex, cterm = "114", cterm16 = "2" },
  grey_comment = { gui = thicc_colors.bg1.hex, cterm = "59", cterm16 = "15" },
  grey_cursor = { gui = thicc_colors.bg1.hex, cterm = "236", cterm16 = "8" },
  grey_menu = { gui = thicc_colors.bg1.hex, cterm = "237", cterm16 = "8" },
  purple = { gui = thicc_colors.purple.hex, cterm = "170", cterm16 = "5" },
  red = { gui = thicc_colors.red.hex, cterm = "204", cterm16 = "1" },
  white = { gui = thicc_colors.fg.hex, cterm = "145", cterm16 = "7" },
  yellow = { gui = thicc_colors.yellow.hex, cterm = "180", cterm16 = "3" },
}

local inactive = {
  guifg = colors.grey_comment.gui,
  guibg = colors.grey_cursor.gui,
  ctermfg = colors.grey_comment.cterm,
  ctermbg = colors.grey_cursor.cterm,
}

local thicc_hardline = {
  mode = {
    inactive = inactive,
    normal = {
      guifg = colors.black.gui,
      guibg = colors.green.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.green.cterm,
    },
    insert = {
      guifg = colors.black.gui,
      guibg = colors.blue.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.blue.cterm,
    },
    replace = {
      guifg = colors.black.gui,
      guibg = colors.cyan.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.cyan.cterm,
    },
    visual = {
      guifg = colors.black.gui,
      guibg = colors.purple.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.purple.cterm,
    },
    command = {
      guifg = colors.black.gui,
      guibg = colors.red.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.red.cterm,
    },
  },
  low = {
    active = {
      guifg = colors.white.gui,
      guibg = colors.grey_cursor.gui,
      ctermfg = colors.white.cterm,
      ctermbg = colors.grey_cursor.cterm,
    },
    inactive = inactive,
  },
  med = {
    active = {
      guifg = colors.yellow.gui,
      guibg = colors.grey_cursor.gui,
      ctermfg = colors.yellow.cterm,
      ctermbg = colors.grey_cursor.cterm,
    },
    inactive = inactive,
  },
  high = {
    active = {
      guifg = colors.white.gui,
      guibg = colors.grey_menu.gui,
      ctermfg = colors.white.cterm,
      ctermbg = colors.grey_menu.cterm,
    },
    inactive = inactive,
  },
  error = {
    active = {
      guifg = colors.black.gui,
      guibg = colors.red.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.red.cterm,
    },
    inactive = inactive,
  },
  warning = {
    active = {
      guifg = colors.black.gui,
      guibg = colors.yellow.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.yellow.cterm,
    },
    inactive = inactive,
  },
  bufferline = {
    separator = inactive,
    current = {
      guifg = colors.black.gui,
      guibg = colors.green.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.green.cterm,
    },
    current_modified = {
      guifg = colors.black.gui,
      guibg = colors.blue.gui,
      ctermfg = colors.black.cterm,
      ctermbg = colors.blue.cterm,
    },
    background = {
      guifg = colors.green.gui,
      guibg = colors.black.gui,
      ctermfg = colors.green.cterm,
      ctermbg = colors.black.cterm,
    },
    background_modified = {
      guifg = colors.blue.gui,
      guibg = colors.black.gui,
      ctermfg = colors.blue.cterm,
      ctermbg = colors.black.cterm,
    },
  },
}

require("hardline").setup({
  theme = thicc_hardline,
  sections = {
    -- define sections
    { class = "mode", item = require("hardline.parts.mode").get_item },
    { class = "high", item = require("hardline.parts.git").get_item, hide = 80 },
    "%<",
    { class = "med", item = require("hardline.parts.filename").get_item },
    { class = "med", item = "%=" },
    { class = "low", item = require("hardline.parts.wordcount").get_item, hide = 80 },
    { class = "error", item = require("hardline.parts.lsp").get_error },
    { class = "warning", item = require("hardline.parts.lsp").get_warning },
    { class = "warning", item = require("hardline.parts.whitespace").get_item },
    { class = "high", item = require("hardline.parts.filetype").get_item, hide = 40 },
    { class = "mode", item = require("hardline.parts.line").get_item },
  },
})
