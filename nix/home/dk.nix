{
  pkgs,
  config,
  ...
} @ args: let
  myLib = import ../lib.nix args;
in {
  imports = [
    ./themes/rose-pine-moon.nix
  ];
  home.username = "m.hanberg";
  home.homeDirectory = "/Users/m.hanberg";
  age.secrets.export-aws-keys.file = ./export-aws-keys.age;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "export-aws-keys";
      runtimeInputs = [pkgs.awscli2];
      text = ''
        main() {
          cmd="aws sts assume-role $(cat "${config.age.secrets.export-aws-keys.path}")"
          creds="$(eval "$cmd")"

          access_key_id=$(echo "$creds" | jq -r .Credentials.AccessKeyId)
          secret_access_key=$(echo "$creds" | jq -r .Credentials.SecretAccessKey)
          session_token=$(echo "$creds" | jq -r .Credentials.SessionToken)

          echo "
        export AWS_ACCESS_KEY_ID='$access_key_id'
        export AWS_SECRET_ACCESS_KEY='$secret_access_key'
        export AWS_SESSION_TOKEN='$session_token'
        "
        }

        main "$@"
      '';
    })
  ];

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
    };
  };

  programs.zsh = {
    sessionVariables = {
      AWS_PROFILE = "default";
    };
    shellAliases = {
      remove-aws-credentials = "rm ~/Downloads/credentials";
      cp-aws-credentials = "cp ~/Downloads/credentials ~/.aws/config";
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
