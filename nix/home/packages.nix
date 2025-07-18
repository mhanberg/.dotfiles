{pkgs, ...}: {
  home.packages = with pkgs;
    [
      argc
      actionlint
      alejandra
      autoconf
      autogen
      automake
      bat
      beam.packages.erlang_28.elixir_1_18
      beam.packages.erlang_28.erlang
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
      # mise
      neovim
      neovim-remote
      nil
      nixd
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
}
