{...}: let
  commonCasks = import ./casks.nix;
in {
  homebrew.casks =
    [
      "farrago"
      "nordvpn"
      "obs"
      "screenflow"
    ]
    ++ commonCasks;
}
