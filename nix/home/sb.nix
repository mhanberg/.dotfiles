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
  home.username = "mitchell";
  home.homeDirectory = "/Users/mitchell";
  home.packages = common.packages ++ work_packages;

  # programs.ssh.extraConfig = ''
  #   Host *
  #     IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  # '';

  # programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  programs.git.extraConfig.gpg.format = "ssh";
  programs.git.extraConfig.gpg.ssh.allowedSignersFile = "/Users/mitchell/.ssh/allowed_signers";
  programs.git.extraConfig.commit.gpgSign = true;
  programs.git.extraConfig.user.signingkey = "~/.ssh/id_ed25519.pub";
}
