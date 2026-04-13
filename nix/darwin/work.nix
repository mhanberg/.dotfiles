{...}: {
  system.primaryUser = "mhanberg";
  homebrew.casks = [
    "cleanshot"
    "docker-desktop"
    "postgres-unofficial"
    "elgato-stream-deck"
    "focus"
  ];
  homebrew.brews = [
    "docker"
    "docker-compose"
  ];
  ids.gids.nixbld = 350;
  nix.settings.trusted-users = ["mhanberg"];
}
