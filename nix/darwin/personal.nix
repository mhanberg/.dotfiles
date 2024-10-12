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
  homebrew.brews = import ./brews.nix;
  homebrew.masApps = {
    Magnet = 441258766;
    Dato = 1470584107;
  };
}
