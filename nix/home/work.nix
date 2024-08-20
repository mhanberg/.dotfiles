{...}: {
  imports = [./common.nix];

  programs.ghostty.settings.config-file = "/Users/mitchell/.config/ghostty/themes/KanagwaWave";
  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
