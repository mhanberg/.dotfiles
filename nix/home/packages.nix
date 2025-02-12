{pkgs, ...}: let
  packages = with pkgs;
    [
      actionlint
      alejandra
      autoconf
      autogen
      automake
      awscli2
      bat
      beam.packages.erlang_27.elixir_1_17
      beam.packages.erlang_27.erlang
      btop
      cachix
      chromedriver
      cmake
      delta
      direnv
      docker
      docker-compose
      eza
      fastfetch
      fd
      figlet
      fswatch
      fzf
      gawk
      gh
      git
      git-lfs
      hyperfine
      jq
      just
      lazydocker
      lazygit
      lua5_1
      luarocks
      lua-language-server
      mise
      neovim
      neovim-remote
      nil
      nix-direnv
      bash-language-server
      yaml-language-server
      nodejs
      openssl
      ripgrep
      rust-analyzer
      selenium-server-standalone
      shellcheck
      shfmt
      silicon
      charm-freeze
      silver-searcher
      sqlite
      sqlite-interactive
      starship
      stylua
      tailwindcss-language-server
      tmux
      twm
      tokei
      tree-sitter
      vim
      vscode-langservers-extracted
      yarn
      zk
      zsh
    ]
    ++ (
      if pkgs.stdenv.isLinux
      then [gcc coreutils xclip unixtools.ifconfig inotify-tools ncurses5]
      else []
    );
in {
  inherit packages;
}
