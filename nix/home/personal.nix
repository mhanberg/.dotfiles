{config, ...} @ args: let
  myLib = import ../lib.nix args;
in {
  home.username = "mitchell";
  home.homeDirectory = "/Users/mitchell";
  imports = [
    ./themes/rose-pine.nix
    ./services/syncthing.nix
  ];
  programs.rummage = {
    settings.search_paths = [
      (myLib.joinHome "/src")
    ];
  };
  programs.ghostty.settings.font-size = 14;
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
  programs.ssh.extraConfig = ''
    Host * "test -z $SSH_TTY"
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';
  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  programs.git.extraConfig.gpg.format = "ssh";
  programs.git.extraConfig.commit.gpgSign = true;
  programs.git = {
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDckxDud0PGdGd60v/1SUa0pbWWe46FcVIbuTijwzeZR";
  };
}
