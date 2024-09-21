{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix;
in {
  imports = [./common.nix];
  home.packages = common.packages;
  programs.ghostty.settings.config-file = "/home/mitchell/.config/ghostty/themes/KanagwaDragon";
  programs.ghostty.settings.font-size = 11;

  programs.git.extraConfig.gpg.ssh.program = "/opt/1Password/op-ssh-sign";
}
