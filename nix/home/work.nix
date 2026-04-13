{work, ...}: {pkgs, ...} @ args: let
  myLib = import ../lib.nix args;
in {
  imports = [
    ./themes/rose-pine-moon.nix
    ./services/syncthing.nix
    (import work.homeManagerModules.default {inherit myLib;})
  ];

  home.packages = with pkgs; [yq-go];

  services.syncthing.settings.folders = let
    devices = [
      "mitchells-mini"
      "mitchells-air"
      "nublar"
    ];
  in
    myLib.fromHome {
      "/shared/notes".devices = devices;
      "/shared/dash".devices = devices;
      "/shared/alfred".devices = devices;
    };

  programs.ghostty.package = null;
}
