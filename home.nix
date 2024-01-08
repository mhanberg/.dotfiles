{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mitchell";
  home.homeDirectory = "/home/mitchell";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    backblaze-b2
    bat
    btop
    cachix
    chromedriver
    clang
    clang-tools
    cmake
    delta
    direnv
    eza
    fastfetch
    fd
    fzf
    gh
    git
    graphite-cli
    hyperfine
    inotify-tools
    lazydocker
    lazygit
    lua-language-server
    neovim-remote
    ripgrep
    rtx
    rust-analyzer
    selenium-server-standalone
    shfmt
    silicon
    sqlite-interactive
    starship
    stylua
    tmux
    tmuxinator
    tokei
    tree-sitter
    unixtools.ifconfig
    vim
    xclip
    yarn
    zsh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".aprc".source = ./aprc;
    ".asdfrc".source = ./asdfrc;
    ".bin".source = ./bin;
    ".bin".recursive = true;
    ".config".source = ./config;
    ".config".recursive = true;
    ".ctags".source = ./ctags;
    ".gitconfig".source = ./gitconfig;
    ".gitignore_global".source = ./gitignore_global;
    ".hammerspoon/Spoons/EmmyLua.spoon/init.lua".source = ./hammerspoon/Spoons/EmmyLua.spoon/init.lua;
    ".hammerspoon/init.lua".source = ./hammerspoon/init.lua;
    ".tmate.conf".source = ./tmate.conf;
    ".vsnip/elixir.json".source = ./vsnip/elixir.json;
    ".xterm-256color.terminfo".source = ./xterm-256color.terminfo;
    ".zsh".source = ./zsh;
    ".zsh".recursive = true;
    ".zshrc".source = ./zshrc;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mitchell/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
