{config, ...}: let
  myLib = import ../lib.nix {inherit config;};
in {
  imports = [
    ./themes/rose-pine-moon.nix
  ];
  home.username = "m.hanberg";
  home.homeDirectory = "/Users/m.hanberg";

  programs.rummage = {
    settings.search_paths = [
      (myLib.joinHome "/src/simplebet/")
      (myLib.joinHome "/src/draftkings/")
      (myLib.joinHome "/src/other/")
      (myLib.joinHome "/src/motchvim")
    ];
  };

  services.syncthing = {
    enable = true;
    settings = {
      options = {
        globalAnnounceServers = [
          "https://syncthing-discovery.motch.systems"
        ];
      };
      folders = {
        "${config.home.homeDirectory}/shared/notes" = {
          id = "notes";
        };
      };
    };
  };

  programs.git = let
    mkWorkConfig = dir: {
      condition = "gitdir:${dir}";
      contents = {
        user.email = "m.hanberg@draftkings.com";
      };
    };
  in {
    includes = [
      (mkWorkConfig "~/src/draftkings/")
      (mkWorkConfig "~/src/simplebet/")
    ];
    extraConfig = {
      gpg.format = "ssh";
      commit.gpgSign = true;
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
