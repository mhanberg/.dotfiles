{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
in {
  imports = [
    ./common.nix
    ./themes/rose-pine.nix
  ];
  home.packages = common.packages;
  programs.ghostty.settings.font-size = 14;
  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
