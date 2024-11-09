{pkgs, ...}: {
  programs.ghostty.settings.theme = "rose-pine";
  home.file = {
    ".motchvim-theme".text = "rose-pine-main";
  };
  programs.bat.themes = {
    rose-pine = {
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "tm-theme"; # Bat uses sublime syntax for its themes
        rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
        sha256 = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
      };
      file = "dist/themes/rose-pine.tmTheme";
    };
  };
  programs.fzf.colors = {
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
  programs.git.delta.options.syntax-theme = "rose-pine";
}
