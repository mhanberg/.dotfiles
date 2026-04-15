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
    macs = ["mitchells-mini" "mitchells-air"];
    linux = ["nublar"];

    all = macs ++ linux;
  in
    myLib.fromHome {
      "/shared/notes".devices = all;
      "/shared/dash".devices = macs;
      "/shared/alfred".devices = macs;
      "/shared/streamdeck".devices = macs;
    };

  programs.ghostty.package = null;

  programs.ssh.matchBlocks."*".identityAgent = "'~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock'";

  programs.git = {
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDckxDud0PGdGd60v/1SUa0pbWWe46FcVIbuTijwzeZR";
    settings.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    settings.gpg.format = "ssh";
    settings.commit.gpgSign = true;
  };
}
