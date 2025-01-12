{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
in {
  home.username = "mitchell";
  home.homeDirectory = "/home/mitchell";
  imports = [
    ./common.nix
    ./themes/rose-pine.nix
  ];
  home.packages = common.packages;
  programs.ghostty.settings.font-size = 11;

  programs.git = {
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDckxDud0PGdGd60v/1SUa0pbWWe46FcVIbuTijwzeZR";

    extraConfig.gpg = {
      ssh.program = "/opt/1Password/op-ssh-sign";
      gpg.format = "ssh";
      commit.gpgSign = true;
    };
  };
}
