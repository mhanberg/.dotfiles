{pkgs, ...}: let
  common = pkgs.callPackage ./packages.nix {inherit pkgs;};
  work_packages = with pkgs; [
    docker-compose
  ];
in {
  imports = [
    ./common.nix
    ./themes/rose-pine-moon.nix
  ];
  home.packages = common.packages ++ work_packages;

  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';

  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
