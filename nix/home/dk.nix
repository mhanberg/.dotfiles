{
  pkgs,
  config,
  ...
} @ args: let
  myLib = import ../lib.nix args;
  export-aws-vars = import ./dk/export-aws-vars.nix {
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
  age.secrets.export-aws-keys.file = ./export-aws-keys.age;

  home.packages = [
    export-aws-vars
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
      PATH = "$PATH:${config.home.homeDirectory}/.dotnet/tools";
      DOTNET_ROOT = "/opt/homebrew/Cellar/dotnet@8/8.0.16/libexec/";
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
