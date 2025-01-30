{...}: let
  commonCasks = import ./casks.nix;
  workCasks = [
    "cleanshot"
    "aws-vpn-client"
    "podman-desktop"
  ];
  commonBrews = import ./brews.nix;
  workBrews = [
    "podman"
    "podman-compose"
  ];
in {
  homebrew.casks = commonCasks ++ workCasks;
  homebrew.brews = commonBrews ++ workBrews;
}
