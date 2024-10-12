{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
in {
  imports = [./common.nix];
  home.packages = common.packages;
  programs.ghostty.settings.config-file = "/Users/mitchell/.config/ghostty/themes/KanagwaDragon";
  programs.ghostty.settings.font-size = 14;
  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
