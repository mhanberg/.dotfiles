{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
  work_packages = with pkgs; [
    docker-compose
  ];
in {
  imports = [./common.nix];
  home.packages = common.packages ++ work_packages;

  programs.ghostty.settings.config-file = "/Users/mitchell/.config/ghostty/themes/KanagwaWave";
  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
