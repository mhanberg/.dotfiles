{ pkgs, lib, ... }:
let
  colors = {
    "fg" = "#908caa";
    "bg" = "#232136";
    "hl" = "#ea9a97";
    "fg+" = "#e0def4";
    "bg+" = "#393552";
    "hl+" = "#ea9a97";
    "border" = "#44415a";
    "header" = "#3e8fb0";
    "gutter" = "#232136";
    "spinner" = "#f6c177";
    "info" = "#9ccfd8";
    "pointer" = "#c4a7e7";
    "marker" = "#eb6f92";
    "prompt" = "#908caa";
  };
in
{
  programs.ghostty.settings.theme = "Rose Pine Moon";
  home.file = {
    ".motchvim-theme".text = "rose-pine-moon";
    ".fzf-colors".text = lib.concatStringsSep "," (
      lib.mapAttrsToList (name: value: "${name}:${value}") colors
    );
  };

  programs.bat.themes = {
    rose-pine-moon = {
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "tm-theme"; # Bat uses sublime syntax for its themes
        rev = "c4cab0c431f55a3c4f9897407b7bdad363bbb862";
        sha256 = "sha256-maQp4QTJOlK24eid7mUsoS7kc8P0gerKcbvNaxO8Mic=";
      };
      file = "dist/themes/rose-pine-moon.tmTheme";
    };
  };
  programs.tmux = {
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'moon'
          set -g @rose_pine_disable_active_window_menu "on"
          set -g @rose_pine_window_status_separator " "
        '';
      }
    ];
  };
  programs.bat.config.theme = "rose-pine-moon";
  programs.delta.options = {
    syntax-theme = "rose-pine-moon";
    dark = true;
  };
  programs.lazygit.settings.git.paging.pager = "delta --paging=never --dark";
  programs.btop = {
    settings.color_theme = "rose-pine-moon";
    themes.rose-pine-moon =
      let
        src = pkgs.fetchFromGitHub {
          owner = "rose-pine";
          repo = "btop";
          rev = "c27e5d48e44e8bd115a2838ecf8cf1f3ea39475e";
          hash = "sha256-vtqqMEQbPOSRfQ28RIln5zZ4cZlyB3sMc2NaLUcITWo=";
        };
      in
      builtins.readFile "${src}/rose-pine-moon.theme";
  };
}
