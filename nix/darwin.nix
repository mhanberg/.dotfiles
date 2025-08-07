{self, ...}: {
  imports = [
    ./darwin/brew.nix
  ];
  environment.systemPackages = [];

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.accept-flake-config = true;

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 1;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 8d";
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 4;

  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.tilesize = 39;

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
