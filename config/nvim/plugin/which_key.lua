local which = require("which-key")
which.setup {
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
}

-- which.register({
--   z = {
--     name = "zk notes", -- optional group name
--     f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
--     r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap = false, buffer = 123 }, -- additional options for creating the keymap
--     n = { "New File" }, -- just a label. don't create any mapping
--     e = "Edit File", -- same as above
--     ["1"] = "which_key_ignore", -- special label to hide it in the popup
--     b = {
--       function()
--         print("bar")
--       end,
--       "Foobar",
--     }, -- you can also pass functions!
--   },
-- }, { prefix = "<space>" })
