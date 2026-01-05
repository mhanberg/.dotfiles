{pkgs, config, ...}: {
  system.primaryUser = "mitchell";

  users.users.mitchell = {
    name = "mitchell";
    home = "/Users/mitchell";
  };

  environment.systemPackages = with pkgs; [
    librewolf
  ];
  # Add home-manager applications to `system.build.applications` so they will be linked
  # by services.link-apps.
  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages;
    pathsToLink = ["/Applications"];
  });

  services.link-apps = {
    enable = true;
    userName = config.users.users.mitchell.name;
    userHome = config.users.users.mitchell.home;
  };
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
    "fastmail"
    "fission"
    "freecad"
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
