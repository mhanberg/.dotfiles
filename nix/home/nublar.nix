{...}: {
  imports = [./common.nix];
  programs.ghostty.settings.config-file = "/home/mitchell/.config/ghostty/themes/KanagwaDragon";

  programs.git.extraConfig.gpg.ssh.program = "/opt/1Password/op-ssh-sign";
}
