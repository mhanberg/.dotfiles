{
  lib,
  pkgs,
  ...
}: {
  home.username = "mitchell";
  home.homeDirectory = "/home/mitchell";
  imports = [
    ./common.nix
    ./themes/rose-pine.nix
  ];

  programs.git.extraConfig.gpg.ssh.program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
  programs.git.extraConfig.gpg.format = "ssh";
  programs.git.extraConfig.gpg.ssh.allowedSignersFile = "/Users/mitchell/.ssh/allowed_signers";
  programs.git.extraConfig.commit.gpgSign = true;
}
