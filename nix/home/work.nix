{work, ...}: {pkgs, ...} @ args: let
  myLib = import ../lib.nix args;
in {
  imports = [
    ./themes/rose-pine-moon.nix
    ./services/syncthing.nix
    (import work.homeManagerModules.default {inherit myLib;})
  ];

  home.packages = with pkgs; [yq-go];

  programs.ghostty.package = null;
}
