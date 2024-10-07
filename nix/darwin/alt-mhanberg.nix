{...}: let
  commonCasks = import ./casks.nix;
  workCasks = [
    "aws-vpn-client"
    "docker"
  ];
  commonBrews = import ./brews.nix;
  workBrews = [
    "kafka"
    "zookeeper"
  ];
in {
  homebrew.casks = commonCasks ++ workCasks;
  homebrew.brews = commonBrews ++ workBrews;
}
