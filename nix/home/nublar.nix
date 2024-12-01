{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
in {
  imports = [
    ./common.nix
    ./themes/rose-pine.nix
  ];
  home.packages = common.packages;
  programs.ghostty.settings.font-size = 11;
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.1password/agent.sock
  '';

  programs.git.extraConfig.gpg.ssh.program = "/opt/1Password/op-ssh-sign";
}
