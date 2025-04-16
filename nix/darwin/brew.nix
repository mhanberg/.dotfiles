{...}: {
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "uninstall";
  homebrew.masApps = {
    Magnet = 441258766;
    Dato = 1470584107;
    Reeder = 1529448980;
    Blackout = 1319884285;
    Shareful = 1522267256;
    Actions = 1586435171;
    MenuBarStats = 714196447;
    Things = 904280696;
    Keynote = 409183694;
    AmazonKindle = 302584613;
  };
  homebrew.taps = [
    "homebrew/services"
  ];
  homebrew.brews = [
    "openssl@3" # needed for compiling OTP with mise
    "php" # needed for Alfred
  ];
  homebrew.casks = [
    "alfred"
    "chromedriver"
    "cleanshot"
    "dash"
    "deckset"
    "dropbox"
    "figma"
    "firefox"
    "font-inter"
    "font-jetbrains-mono"
    "font-jetbrains-mono-nerd-font"
    "font-work-sans"
    "ghostty"
    "jordanbaird-ice"
    "loopback"
    "monodraw"
    "postico"
    "soundsource"
    "tuple"
    "via"
    "visual-studio-code"
    "vlc"
    "zed"
  ];
}
