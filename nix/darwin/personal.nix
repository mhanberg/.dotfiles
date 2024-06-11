{...}: let
  commonCasks = import ./darwin/casks.nix;
in {
  homebrew.casks = commonCasks;
}
