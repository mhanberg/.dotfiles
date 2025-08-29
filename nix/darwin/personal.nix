{...}: {
  system.primaryUser = "mitchell";
  homebrew.casks = [
    "1password"
    "1password-cli"
    "audio-hijack"
    "bambu-studio"
    "cleanshot"
    "discord"
    "element"
    "elgato-stream-deck"
    "farrago"
    "fission"
    "obs"
    "pikopixel"
    "protonvpn"
    "screenflow"
    "slack"
    "tailscale-app"
    "wacom-tablet"
    "zoom"
  ];
  nix.settings.trusted-users = ["mitchell"];
}
