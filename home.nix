{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mitchell";
  home.homeDirectory = pkgs.lib.mkForce(if pkgs.stdenv.isLinux then "/home/mitchell" else "/Users/mitchell");

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
    actionlint
    nodePackages.bash-language-server
    bat
    cachix
    chromedriver
    cmake
    delta
    direnv
    eza
    fastfetch
    fd
    figlet
    fzf
    gh
    git
    graphite-cli
    hyperfine
    jq
    lazydocker
    lazygit
    lua-language-server
    neovim-nightly
    neovim-remote
    nodejs
    ripgrep
    mise
    rust-analyzer
    selenium-server-standalone
    shellcheck
    shfmt
    silicon
    sqlite-interactive
    sqlite
    starship
    stylua
    tmux
    tmuxinator
    tree-sitter
    vim
    yarn
    zsh
  ] ++ (if pkgs.stdenv.isLinux then [ clang clang-tools backblaze-b2 xclip unixtools.ifconfig inotify-tools ] else []);

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
