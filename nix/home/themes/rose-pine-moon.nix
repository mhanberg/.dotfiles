{pkgs, ...}: {
  programs.ghostty.settings.theme = "rose-pine-moon";
  home.file = {
    ".motchvim-theme".text = "rose-pine-moon";
  };
  programs.bat.themes = {
    rose-pine-moon = {
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "tm-theme"; # Bat uses sublime syntax for its themes
        rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
        sha256 = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
      };
      file = "dist/themes/rose-pine-moon.tmTheme";
    };
  };
  programs.fzf.colors = {
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
  programs.git.delta.options.syntax-theme = "rose-pine-moon";
}
