--
-- Load the information from the Alfred configuration.
--
require("hs.ipc")

-- hs.loadSpoon("EmmyLua")

hs.hotkey.bind({ "cmd", "alt", "control" }, "\\", function()
  hs.window.find("phoenix"):setSize(hs.geometry.size(1708, 1056))
end)
