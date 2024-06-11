{
  lib,
  pkgs,
  ...
}: {
  imports = [./common.nix];
  programs.ghostty.settings.config-file = "/home/mitchell/.config/ghostty/themes/KanagwaDragon";

  programs.git.extraConfig.gpg.ssh.program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
}
