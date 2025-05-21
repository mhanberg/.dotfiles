{...}: {
  system.primaryUser = "m.hanberg";
  homebrew.casks = [
    "cleanshot"
    "aws-vpn-client"
    "podman-desktop"
    "postgres-unofficial"
    "elgato-control-center"
    "elgato-stream-deck"
  ];
  homebrew.brews = [
    {
      name = "dotnet@8";
      link = true;
    }
    "podman"
    "podman-compose"
  ];
  ids.gids.nixbld = 350;
  nix.settings.trusted-users = ["m.hanberg"];
}
