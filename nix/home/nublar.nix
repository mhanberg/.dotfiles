{pkgs, ...} @ args: let
  myLib = import ../lib.nix args;
in {
  home.username = "mitchell";
  home.homeDirectory = "/home/mitchell";

  home.packages = with pkgs; [
    (flameshot.override {enableWlrSupport = true;})
    _1password-cli
    _1password-gui
    albert
    discord
    ghostty
    gnome-boxes
    gnomeExtensions.dash-to-panel
    gnomeExtensions.vitals
    libvirt
    nerd-fonts.jetbrains-mono
    qemu_kvm
    thunderbird
    virt-manager
    zeal
  ];

  imports = [
    ./themes/rose-pine.nix
    ./services/syncthing.nix
  ];

  services.syncthing = {
    guiAddress = "0.0.0.0:8384";
  };

  programs.zsh.enable = true;

  programs.ghostty.settings.font-size = 11;

  programs.rummage = {
    settings.search_paths = [
      (myLib.joinHome "/src")
    ];
  };

  programs.ssh.extraConfig = ''
    Host * "test -z $SSH_TTY"
      IdentityAgent ~/.1password/agent.sock
  '';

  programs.git = {
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDckxDud0PGdGd60v/1SUa0pbWWe46FcVIbuTijwzeZR";

    extraConfig.gpg = {
      ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      gpg.format = "ssh";
      commit.gpgSign = true;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-key-theme = "Default";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          dash-to-panel.extensionUuid
          vitals.extensionUuid
        ];
        disabled-extensions = [];
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
    };
  };
}
