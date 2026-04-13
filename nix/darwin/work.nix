{...}: {
  system.primaryUser = "mhanberg";
  homebrew.casks = [
    "1password"
    "1password-cli"
    "cleanshot"
    "docker-desktop"
    "postgres-app"
    "elgato-stream-deck"
    "focus"
    "slack"
  ];
  homebrew.brews = [
    "docker"
    "docker-compose"
  ];
  ids.gids.nixbld = 350;
  nix.settings.trusted-users = ["mhanberg"];
}
