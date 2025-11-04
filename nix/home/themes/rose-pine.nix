{pkgs, ...}: let
  colors = {
    "fg" = "#908caa";
    "bg" = "#191724";
    "hl" = "#ebbcba";
    "fg+" = "#e0def4";
    "bg+" = "#26233a";
    "hl+" = "#ebbcba";
    "border" = "#403d52";
    "header" = "#31748f";
    "gutter" = "#191724";
    "spinner" = "#f6c177";
    "info" = "#9ccfd8";
    "pointer" = "#c4a7e7";
    "marker" = "#eb6f92";
    "prompt" = "#908caa";
  };
in {
  imports = [
    (import ../modules/fzf.nix {inherit colors;})
  ];
  programs.ghostty.settings.theme = "Rose Pine";
  home.file = {
    ".motchvim-theme".text = "rose-pine-main";
  };
  programs.bat.themes = {
    rose-pine = {
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "tm-theme"; # Bat uses sublime syntax for its themes
        rev = "c4cab0c431f55a3c4f9897407b7bdad363bbb862";
        sha256 = "sha256-maQp4QTJOlK24eid7mUsoS7kc8P0gerKcbvNaxO8Mic=";
      };
      file = "dist/themes/rose-pine.tmTheme";
    };
  };
  programs.tmux = {
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'main'
          set -g @rose_pine_disable_active_window_menu "on"
          set -g @rose_pine_window_status_separator " "
        '';
      }
    ];
  };
  programs.bat.config.theme = "rose-pine";
  programs.delta.options = {
    syntax-theme = "rose-pine";
    dark = true;
  };
  programs.lazygit.settings.git.paging.pager = "delta --paging=never --dark";
}
