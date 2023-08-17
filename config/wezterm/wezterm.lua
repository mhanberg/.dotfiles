local wezterm = require("wezterm")
local home = "/Users/mitchell"
local icloud = string.format("%s/Library/Mobile Documents/com~apple~CloudDocs", home)
local src = string.format("%s/src", home)

local table_filter = function(tbl, filterer)
  local new_table = {}

  for _, el in ipairs(tbl) do
    if filterer(el) then
      table.insert(new_table, el)
    end
  end

  return new_table
end

local function isViProcess(pane)
  -- get_foreground_process_name On Linux, macOS and Windows,
  -- the process can be queried to determine this path. Other operating systems
  -- (notably, FreeBSD and other unix systems) are not currently supported
  return pane:get_foreground_process_name():find("n?vim") ~= nil
  -- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if isViProcess(pane) then
    window:perform_action(wezterm.action.SendKey { key = "w", mods = "CTRL" }, pane)
    window:perform_action(wezterm.action.SendKey { key = vim_direction }, pane)
  else
    window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
  conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
  conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
  conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
  conditionalActivatePane(window, pane, "Down", "j")
end)
wezterm.on("user-var-changed", function(window, pane, name, value)
  if name == "WORKSPACE_CHANGED" and string.len(value) > 0 then
    wezterm.log_info(name, value, "/Users/mitchell/src/" .. value)
    local cwd
    if value == ".dotfiles" then
      cwd = "/Users/mitchell/.dotfiles"
    elseif value == "notes" then
      cwd = string.format("%s/%s", icloud, "notes/personal")
    elseif value == "work-notes" then
      cwd = string.format("%s/%s", icloud, "notes/work")
    else
      cwd = string.format("%s/%s", src, value)
    end

    wezterm.GLOBAL.last_open_workspace = window:active_workspace()

    window:perform_action(
      wezterm.action.SwitchToWorkspace {
        name = value,
        spawn = {
          cwd = cwd,
        },
      },
      pane
    )
  elseif name == "WORKSPACE_CHANGED" then
    wezterm.log_warn("couldn't change workspace for some reason", value)
  else
    wezterm.log_info("unhandled var change", name, value)
  end
end)

wezterm.on("fzf-workspaces-open", function(window)
  window:mux_window():spawn_tab {
    args = { "/Users/mitchell/.bin/wezterm-workspace-fzf" },
  }
end)

wezterm.on("fzf-workspaces-switch", function(window)
  window:mux_window():spawn_tab {
    args = { "/Users/mitchell/.bin/wezterm-switch-workspace" },
    set_environment_variables = {
      FZF_DEFAULT_COMMAND = string.format(
        "echo '%s'",
        table.concat(
          table_filter(wezterm.mux.get_workspace_names(), function(n)
            return n ~= window:active_workspace()
          end),
          "\n"
        )
      ),
    },
  }
end)

return {
  term = "wezterm",
  unix_domains = { { name = "unix" } },
  default_gui_startup_args = { "connect", "unix" },
  font = wezterm.font("JetBrainsMono Nerd Font Mono"),
  font_size = 14.0,
  color_scheme = "kanagawa_dragon",
  front_end = "WebGpu",
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 1.0,
  },
  skip_close_confirmation_for_processes_named = { "" },
  tab_bar_at_bottom = true,
  switch_to_last_active_tab_when_closing_tab = true,
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    { key = "y", mods = "LEADER|CTRL", action = wezterm.action { EmitEvent = "fzf-workspaces-open" } },
    { key = "j", mods = "LEADER|CTRL", action = wezterm.action { EmitEvent = "fzf-workspaces-switch" } },
    {
      key = "m",
      mods = "LEADER|CTRL",
      action = wezterm.action {
        SpawnCommandInNewTab = {
          args = { "lazygit" },
          set_environment_variables = {
            PATH = "/Users/mitchell/.local/share/rtx/installs/neovim/nightly/bin:/Users/mitchell/.local/share/rtx/installs/nodejs/18.16.0/bin:/opt/homebrew/bin:"
              .. os.getenv("PATH"),
            XDG_CONFIG_HOME = string.format("%s/%s", home, ".config"),
          },
        },
      },
    },
    {
      key = "h",
      mods = "LEADER|CTRL",
      action = wezterm.action {
        SpawnCommandInNewTab = {
          args = { "fzf-prs" },
          set_environment_variables = {
            PATH = string.format("%s/%s", home, ".bin:") .. "/opt/homebrew/bin:" .. os.getenv("PATH"),
          },
        },
      },
    },
    {
      key = "i",
      mods = "LEADER|CTRL",
      action = wezterm.action {
        SpawnCommandInNewTab = {
          args = { "fzf-issues" },
          set_environment_variables = {
            PATH = string.format("%s/%s", home, ".bin:") .. "/opt/homebrew/bin:" .. os.getenv("PATH"),
          },
        },
      },
    },
    {
      key = "l",
      mods = "LEADER|SHIFT",
      action = wezterm.action_callback(function(window, pane)
        local last = wezterm.GLOBAL.last_open_workspace
        wezterm.GLOBAL.last_open_workspace = window:active_workspace()
        window:perform_action(wezterm.action.SwitchToWorkspace { name = last }, pane)
      end),
    },

    { key = "c", mods = "LEADER", action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
    -- { key = "j", mods = "LEADER", action = wezterm.action { SpawnTab = { DomainName = "dotfiles" } } },
    { key = "l", mods = "LEADER", action = "ShowLauncher" },
    { key = "n", mods = "LEADER", action = wezterm.action { ActivateTabRelative = 1 } },
    { key = "p", mods = "LEADER", action = wezterm.action { ActivateTabRelative = -1 } },
    {
      key = "\\",
      mods = "LEADER",
      action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } },
    },
    {
      key = "-",
      mods = "LEADER",
      action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } },
    },
    { key = "x", mods = "LEADER", action = wezterm.action { CloseCurrentPane = { confirm = true } } },
    { key = "h", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
    { key = "j", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
    { key = "k", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
    { key = "l", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
    { key = "l", mods = "CMD", action = "ShowDebugOverlay" },
  },
}
