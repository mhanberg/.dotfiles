{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
  work_packages = [];
in {
  imports = [
    ./common.nix
    ./themes/rose-pine-moon.nix
  ];
  home.username = "m.hanberg";
  home.homeDirectory = "/Users/m.hanberg";

  home.packages = common.packages ++ work_packages;
  programs.git.extraConfig.gpg.format = "ssh";
  programs.git.extraConfig.commit.gpgSign = true;
  programs.git.extraConfig.user.signingkey = "~/.ssh/id_ed25519.pub";
}
