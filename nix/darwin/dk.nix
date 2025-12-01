{...}: {
  system.primaryUser = "m.hanberg";
  homebrew.casks = [
    "cleanshot"
    "aws-vpn-client"
    "podman-desktop"
    "postgres-unofficial"
    "elgato-stream-deck"
  ];
  homebrew.brews = [
    "podman"
    "podman-compose"
  ];
  ids.gids.nixbld = 350;
  nix.settings.trusted-users = ["m.hanberg"];
}
