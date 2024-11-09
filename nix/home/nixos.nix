{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./themes/rose-pine.nix
  ];

  programs.git.extraConfig.gpg.ssh.program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
}
