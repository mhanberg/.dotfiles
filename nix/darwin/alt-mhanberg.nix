{...}: let
  commonCasks = import ./casks.nix;
  workCasks = [
    "aws-vpn-client"
    "docker"
  ];
in {
  homebrew.casks = commonCasks ++ workCasks;
}
