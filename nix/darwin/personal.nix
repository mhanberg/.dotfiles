{...}: let
  commonCasks = import ./casks.nix;
in {
  homebrew.casks = commonCasks;
}
