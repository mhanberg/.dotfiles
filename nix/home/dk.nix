{
  pkgs,
  config,
  ...
}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
  work_packages = [];
in {
  imports = [
    ./common.nix
    ./themes/rose-pine-moon.nix
  ];
  home.username = "m.hanberg";
  home.homeDirectory = "/Users/m.hanberg";

  home.packages = common.packages ++ work_packages;
  programs.rummage = {
    settings.search_paths = [
      "~/src/simplebet/"
      "~/src/draftkings/"
      "~/src/other/"
      "~/src/motchvim"
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
