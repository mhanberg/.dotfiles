{...}: {
  system.primaryUser = "mhanberg";
  homebrew.casks = [
    "cleanshot"
    "podman-desktop"
    "postgres-unofficial"
    "elgato-stream-deck"
    "focus"
  ];
  homebrew.brews = [
    "podman"
    "podman-compose"
  ];
  ids.gids.nixbld = 350;
  nix.settings.trusted-users = ["mhanberg"];
}
