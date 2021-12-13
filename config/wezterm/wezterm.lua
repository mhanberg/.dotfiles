local wezterm = require("wezterm")

local move_around = function(window, pane, direction_wez, direction_nvim)
  -- if pane:get_title():sub(-4) == "NVIM" then
  -- 	window:perform_action(wezterm.action({ SendString = "^" .. direction_nvim }), pane)
  -- else
  window:perform_action(wezterm.action({ ActivatePaneDirection = direction_wez }), pane)
  -- end
end

wezterm.on("move-left", function(window, pane)
  move_around(window, pane, "Left", "h")
end)

wezterm.on("move-right", function(window, pane)
  move_around(window, pane, "Right", "l")
end)

wezterm.on("move-up", function(window, pane)
  move_around(window, pane, "Up", "k")
end)

wezterm.on("move-down", function(window, pane)
  move_around(window, pane, "Down", "j")
end)

return {
  unix_domains = {
    {
      name = "default",
      connect_automatically = true,
    },
  },
  font = wezterm.font("JetBrainsMono Nerd Font Mono"),
  font_size = 14.0,
  skip_close_confirmation_for_processes_named = { "" },
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "j", mods = "LEADER", action = wezterm.action({ SpawnTab = { DomainName = "dotfiles" } }) },
    { key = "l", mods = "LEADER", action = "ShowLauncher" },
    { key = "n", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = "p", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = "\\", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
    { key = "h", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-left" }) },
    { key = "l", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-right" }) },
    { key = "k", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-up" }) },
    { key = "j", mods = "CTRL", action = wezterm.action({ EmitEvent = "move-down" }) },
    { key = "l", mods = "CMD", action = "ShowDebugOverlay" },
  },
  colors = {
    -- The default text color
    foreground = "#d8caac",
    -- The default background color
    background = "#273433",

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = "#52ad70",
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = "black",
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- of the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = "#52ad70",

    -- the foreground color of selected text
    selection_fg = "black",
    -- the background color of selected text
    selection_bg = "#fffacd",

    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = "#222222",

    -- The color of the split lines between panes
    split = "#444444",

    ansi = { "#d8caac", "#e68183", "#a7c080", "#d9bb80", "#89beba", "#d3a0bc", "#87c095", "#868d80" },
    brights = { "#5f747f", "#e68183", "#a7c080", "#d9bb80", "#89beba", "#d3a0bc", "#87c095", "#868d80" },

    -- Arbitrary colors of the palette in the range from 16 to 255
    -- indexed = { [136] = "#af8700" },
    tab_bar = {

      -- The color of the strip that goes along the top of the window
      background = "#2b2042",

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = "#2b2042",
        -- The color of the text for the tab
        fg_color = "#c0c0c0",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      },

    },

  },

}
