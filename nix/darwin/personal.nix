{...}: let
  commonCasks = import ./casks.nix;
in {
  homebrew.casks =
    [
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
      "kindle"
      "nordvpn"
      "obs"
      "screenflow"
      "slack"
      "zoom"
    ]
    ++ commonCasks;
  homebrew.brews = import ./brews.nix;
  nix.settings.trusted-users = ["mitchell" "m.hanberg"];
}
