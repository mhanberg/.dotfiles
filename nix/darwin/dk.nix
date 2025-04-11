{...}: {
  homebrew.casks = [
    "cleanshot"
    "aws-vpn-client"
    "podman-desktop"
    "postgres-unofficial"
    "elgato-control-center"
    "elgato-stream-deck"
  ];
  homebrew.brews = [
    "podman"
    "podman-compose"
  ];
}
