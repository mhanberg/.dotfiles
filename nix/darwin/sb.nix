{...}: let
  commonCasks = import ./casks.nix;
  workCasks = [
    "1password"
    "1password-cli"
    "aws-vpn-client"
    "discord"
    "docker"
    "elgato-control-center"
    "elgato-stream-deck"
    "gitpigeon"
    "slack"
    "zoom"
  ];
  commonBrews = import ./brews.nix;
  workBrews = [
    "kafka"
    "zookeeper"
  ];
in {
  homebrew.casks = commonCasks ++ workCasks;
  homebrew.brews = commonBrews ++ workBrews;
  nix.settings.trusted-users = ["mitchell"];
}
