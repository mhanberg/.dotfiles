{...}: {
  imports = [./common.nix];
  programs.ghostty.settings.config-file = "/Users/mitchell/.config/ghostty/themes/KanagwaDragon";
  programs.ghostty.settings.font-size = 14;
  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
