{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
in {
  imports = [
    ./common.nix
    ./themes/rose-pine.nix
  ];
  home.packages = common.packages;
  programs.ghostty.settings.font-size = 14;
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';
  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
