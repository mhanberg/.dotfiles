{...}: let
  commonCasks = import ./casks.nix;
in {
  homebrew.casks =
    [
      "tailscale"
      "1password"
      "1password-cli"
      "audio-hijack"
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
  nix.settings.trusted-users = ["mitchell"];
}
