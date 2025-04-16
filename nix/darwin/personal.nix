{...}: {
  homebrew.casks = [
    "cleanshot"
    "autodesk-fusion"
    "tailscale"
    "1password"
    "1password-cli"
    "audio-hijack"
    "bambu-studio"
    "discord"
    "element"
    "elgato-control-center"
    "elgato-stream-deck"
    "farrago"
    "fission"
    "nordvpn"
    "obs"
    "pikopixel"
    "screenflow"
    "slack"
    "wacom-tablet"
    "zoom"
  ];
  nix.settings.trusted-users = ["mitchell"];
}
