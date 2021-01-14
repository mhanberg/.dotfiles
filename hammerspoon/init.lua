hs.hotkey.bind({"cmd", "alt", "control"}, "\\", function()
  hs.application.open("Alacritty")
end)

hs.hotkey.bind({"cmd", "alt"}, "M", function()
  hs.application.open("Messages")
end)

hs.hotkey.bind({"cmd", "alt"}, "N", function()
  hs.application.open("Mail")
end)

hs.hotkey.bind({"cmd", "alt"}, "K", function()
  hs.application.open("Google Chrome")
end)

hs.hotkey.bind({"cmd", "alt"}, "L", function()
  hs.application.open("Slack")
end)

hs.hotkey.bind({"cmd", "alt"}, "T", function()
  hs.application.open("Things3")
end)

hs.hotkey.bind({"cmd", "alt"}, "D", function()
  hs.application.open("Discord")
end)

BrewInfo:bindHotKeys({show_brew_info = {"cmd", "alt", "B"}})
