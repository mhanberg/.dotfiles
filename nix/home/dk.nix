{
  pkgs,
  config,
  ...
} @ args: let
  myLib = import ../lib.nix args;
  dk-aws = import ./dk/aws.nix {
    inherit pkgs;
    age-secrets = config.age;
  };
in {
  imports = [
    ./themes/rose-pine-moon.nix
    ./services/syncthing.nix
  ];
  home.username = "m.hanberg";
  home.homeDirectory = "/Users/m.hanberg";
  age.secrets = {
    aws-role-arn.file = ./dk/secrets/aws-role-arn.age;
    aws-role-session-name.file = ./dk/secrets/aws-role-session-name.age;
  };

  home.packages = [
    dk-aws
    # dotnetCorePackages.dotnet_8.sdk
    # dotnetCorePackages.runtime_8_0-bin
  ];

  programs.rummage = {
    settings.search_paths = [
      (myLib.joinHome "/src/simplebet/")
      (myLib.joinHome "/src/draftkings/")
      (myLib.joinHome "/src/other/")
      (myLib.joinHome "/src/motchvim")
    ];
  };

  programs.zsh = {
    sessionVariables = {
      AWS_PROFILE = "dag-default";
    };
    shellAliases = {
      eav = "eval $(export-aws-vars)";
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
