vim.opt.list = true
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup({
  space_char_blankline = " ",
  char = "│",
  filetype_exclude = {
    "terminal",
    "json",
    "lspinfo",
    "packer",
    "checkhealth",
    "help",
    "",
  },
})
