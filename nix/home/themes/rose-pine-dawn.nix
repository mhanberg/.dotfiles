{pkgs, ...}: {
  programs.ghostty.settings.theme = "rose-pine-dawn";
  home.file = {
    ".motchvim-theme".text = "rose-pine-dawn";
  };
  programs.bat.themes = {
    rose-pine-dawn = {
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "tm-theme";
        rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
        sha256 = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
      };
      file = "dist/themes/rose-pine-dawn.tmTheme";
    };
  };
  programs.fzf.colors = {
    "fg" = "#797593";
    "bg" = "#faf4ed";
    "hl" = "#d7827e";
    "fg+" = "#575279";
    "bg+" = "#f2e9e1";
    "hl+" = "#d7827e";
    "border" = "#dfdad9";
    "header" = "#286983";
    "gutter" = "#faf4ed";
    "spinner" = "#ea9d34";
    "info" = "#56949f";
    "pointer" = "#907aa9";
    "marker" = "#b4637a";
    "prompt" = "#797593";
  };
  programs.tmux = {
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'dawn'
          set -g @rose_pine_disable_active_window_menu "on"
          set -g @rose_pine_window_status_separator " "
        '';
      }
    ];
  };
  programs.bat.config.theme = "rose-pine-dawn";
  programs.git.delta.options.syntax-theme = "rose-pine-dawn";
}
