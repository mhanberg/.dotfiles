{ lib, pkgs, ... }: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
in {
  home.username = "mitchell";
  home.homeDirectory = "/home/mitchell";
  imports = [
    ./common.nix
    ./themes/rose-pine.nix
  ];

  home.packages = common.packages;
  programs.git.extraConfig.gpg.ssh.program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
  programs.git.extraConfig.gpg.format = "ssh";
  programs.git.extraConfig.commit.gpgSign = true;
}
