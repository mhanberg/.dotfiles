local silicon = require("silicon")

silicon.setup {
  font = "Hack",
  lineNumber = false,
  -- bgImage = "/Users/mitchell/Downloads/robert-anasch-u6AQYn1tMSE-unsplash.jpg",
  -- bgImage = "/Users/mitchell/Downloads/engin-akyurt-HEMIBJ8QQuA-unsplash.jpg",
  -- bgImage = "/Users/mitchell/Downloads/sincerely-media-K5OLjMlPe4U-unsplash.jpg",
  bgImage = "/Users/mitchell/Downloads/sincerely-media-yHWvPxLadRE-unsplash.jpg",
  shadowBlurRadius = 0,
}

vim.keymap.set("v", "<space>ss", function()
  silicon.visualise_api {}
end, { desc = "Take a silicon code snippet" })
vim.keymap.set("v", "<space>sc", function()
  silicon.visualise_api { to_clip = true }
end, { desc = "Take a silicon code snippet into the clipboard" })
