--
-- Load the information from the Alfred configuration.
--
require("hs.ipc")

-- hs.loadSpoon("EmmyLua")

hs.hotkey.bind({ "cmd", "alt", "control" }, "\\", function()
  hs.application.open("Alacritty")
end)

hs.hotkey.bind({ "cmd", "alt" }, "M", function()
  hs.application.open("Messages")
end)

hs.hotkey.bind({ "cmd", "alt" }, "N", function()
  hs.application.open("Mail")
end)

hs.hotkey.bind({ "cmd", "alt" }, "K", function()
  hs.application.open("Firefox Developer Edition")
end)

hs.hotkey.bind({ "cmd", "alt" }, "L", function()
  hs.application.open("Slack")
end)

hs.hotkey.bind({ "cmd", "alt" }, "T", function()
  hs.application.open("Things3")
end)

hs.hotkey.bind({ "cmd", "alt" }, "D", function()
  hs.application.open("Discord")
end)

hs.hotkey.bind({ "control", "shift" }, "T", function()
  hs.application.open("TweetDeck")
end)

hs.hotkey.bind({ "control", "shift" }, "N", function()
  hs.application.launchOrFocus("Twitter")
  local twitter = hs.application.get("Twitter")
  twitter:setFrontmost()
  twitter:selectMenuItem("New Tweet")
end)
