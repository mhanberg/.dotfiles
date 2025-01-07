{...}: let
  commonCasks = import ./casks.nix;
  workCasks = [
    "cleanshot"
  ];
  commonBrews = import ./brews.nix;
  workBrews = [
  ];
in {
  homebrew.casks = commonCasks ++ workCasks;
  homebrew.brews = commonBrews ++ workBrews;
}
