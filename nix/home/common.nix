{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mitchell";
  home.homeDirectory = pkgs.lib.mkForce (
    if pkgs.stdenv.isLinux
    then "/home/mitchell"
    else "/Users/mitchell"
  );

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
  home.packages = with pkgs;
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
      eza
      fastfetch
      fd
      figlet
      fswatch
      fzf
      gawk
      gh
      git
      hyperfine
      jq
      just
      lazydocker
      lazygit
      lua-language-server
      mise
      neovim
      neovim-remote
      nil
      bash-language-server
      nodejs
      openssl
      ripgrep
      rust-analyzer
      selenium-server-standalone
      shellcheck
      shfmt
      silicon
      silver-searcher
      sqlite
      sqlite-interactive
      starship
      stylua
      tmux
      tmuxinator
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
      then [gcc coreutils libstdcxx5 xclip unixtools.ifconfig inotify-tools ncurses5]
      else []
    );

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".bin".source = ../../bin;
    ".bin".recursive = true;
    ".config".source = ../../config;
    ".config".recursive = true;
    ".gitignore_global".source = ../../gitignore_global;
    ".tmux.conf".source = ../../tmux.conf;
    ".vsnip/elixir.json".source = ../../vsnip/elixir.json;
    ".xterm-256color.terminfo".source = ../../xterm-256color.terminfo;
  };

  programs.git = {
    enable = true;
    userName = "Mitchell Hanberg";
    userEmail = "mitch@mitchellhanberg.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDckxDud0PGdGd60v/1SUa0pbWWe46FcVIbuTijwzeZR";
    };
    delta = {
      enable = true;
    };
    includes = [
      {path = "~/.gitconfig.local";}
    ];

    extraConfig = {
      push.default = "simple";
      color.branch = "auto";
      core = {
        excludesFile = "~/.gitignore_global";
        editor = "nvim";
      };
      pull.ff = "only";
      init.defaultBranch = "main";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "/Users/mitchell/.ssh/allowed_signers";
      commit.gpgSign = true;
      rebase.updateRefs = true;
    };
  };

  programs.btop.enable = true;
  programs.btop.settings.color_theme = "tokyo-night";
  programs.btop.settings.theme_background = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    enableVteIntegration = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "ohmyzsh-key-bindings";
        src = pkgs.fetchFromGitHub {
          owner = "kytta";
          repo = "ohmyzsh-key-bindings";
          rev = "main";
          sha256 = "sha256-BXIYzHxmHHThMko+f87HL0/Vak53Mfdr/4VCrll8OiM=";
        };
      }
    ];
    shellAliases = {
      tsr = "tailscale serve reset";

      nublar = "ssh -q mitchell@nublar -L 4999:localhost:4999";
      tmux = "direnv exec / tmux";
      mux = "tmuxinator";
      blog = "cd ~/Development/blog";
      dotfiles = "tmuxinator start dotfiles --suppress-tmux-version-warning";

      # git
      git-trigger-build = "git commit --allow-empty -m 'Trigger Build'";
      gpu = "git push -u origin";
      gd = "git diff";
      gwip = "git add . && git commit -m 'WIP'";
      gtb = "git-trigger-build";
      tree = "tree | less";
      unwrap-last-commit = "git reset HEAD~1";
      mxi = "mix";
      shfmt = "shfmt -i 2";
      ls = "eza";

      dadbod = "nvim -c ':DBUI'";

      # docker
      dc = "docker-compose";
      docker-image-remove = "docker image rm $(docker image ls -q) --force";

      # gh aliases
      ghc = "gh repo clone";
      ghv = "gh repo view -w";

      # elixir
      mtc = "WALLABY_DRIVER=chrome mix test";
      mts = "WALLABY_DRIVER=selenium mix test";
      em = "mix ecto.migrate";

      # zk
      notes = "zk edit --match=README --tag=startup";
    };

    initExtra = ''
      export EDITOR=nvim

      if uname -a | grep -i "darwin" > /dev/null; then
        eval $(/opt/homebrew/bin/brew shellenv)
      fi

      path() {
        echo $PATH | tr ':' '\n'
      }

      tp() {
        session="$(tmux ls | fzf --reverse | awk '{ print $1 }' | sed 's/://g')"

        if [ -n "$session" ] && tmux attach -t "$session"
      }

      dev() {
        if [ -z "$1" ]; then
          cd ~/src
        else
          if [ -d "$HOME/src/$1" ]; then
            tmuxinator start --suppress-tmux-version-warning=0 code "$1"
          else
            echo "$HOME/src/$1 does not exist"
          fi
        fi
      }

      _dev() { _arguments "1: :($(ls $HOME/src))" }

      compdef _dev dev

      # aliases that use env vars or spaces
      alias icloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
      alias home="cd $HOME"
      alias rebuild-blog="curl -X POST -d {} https://api.netlify.com/build_hooks/$NETLIFY_BLOG_ID"

      export PATH="$HOME/.bin:$PATH"
    '';
  };

  programs.bat.enable = true;
  programs.bat.themes = {
    kanagawa = {
      src = pkgs.fetchFromGitHub {
        owner = "obergodmar";
        repo = "kanagawa-tmTheme"; # Bat uses sublime syntax for its themes
        rev = "edb1e41256421a7b26348c80146bcff2c3e37f34";
        sha256 = "5Gj0Jz6UUm55v5d7V7E89ujUDSn0aGsZrOMS5FXduAE=";
      };
      file = "Kanagawa.tmTheme";
    };
  };

  programs.bat.config = {
    theme = "kanagawa";
  };

  programs.fzf.enable = true;
  programs.direnv.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [┌](bold white) $time
        [│](bold white)$all'';
      command_timeout = 1000;
      character = {
        format = "[└ ](bold white)$symbol ";
        success_symbol = "[](bold yellow)";
        error_symbol = "[](bold red)";
      };
      cmd_duration = {
        min_time = 5000;
        format = "took [$duration](bold yellow)";
      };
      git_metrics = {
        disabled = false;
      };
      time = {
        disabled = false;
        use_12hr = true;
        format = "[$time](bold yellow)";
      };
      aws = {
        symbol = "  ";
      };
      conda = {
        symbol = " ";
      };
      dart = {
        symbol = " ";
      };
      directory = {
        read_only = " ";
        style = "bold blue";
        substitutions = {
          "/Library/Mobile Documents/com~apple~CloudDocs" = "/iCloud";
        };
      };
      docker_context = {
        disabled = true;
        symbol = " ";
      };
      elixir = {
        symbol = " ";
      };
      elm = {
        symbol = " ";
      };
      git_branch = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
      };
      hg_branch = {
        symbol = " ";
      };
      java = {
        symbol = " ";
      };
      julia = {
        symbol = " ";
      };
      memory_usage = {
        symbol = " ";
      };
      nim = {
        symbol = " ";
      };
      nix_shell = {
        symbol = " ";
      };
      package = {
        symbol = " ";
        disabled = true;
      };
      perl = {
        symbol = " ";
      };
      php = {
        symbol = " ";
      };
      python = {
        symbol = " ";
      };
      ruby = {
        symbol = " ";
      };
      rust = {
        symbol = "󱘗 ";
      };
      scala = {
        symbol = " ";
      };
      shlvl = {
        symbol = " ";
      };
      swift = {
        symbol = "󰛥 ";
      };
    };
  };

  programs.mise = {
    enable = false;
  };

  programs.ghostty = {
    enable = true;
    settings = {
      shell-integration-features = "no-cursor";
      background = "#181616";
      foreground = "#c5c9c5";
      cursor-color = "#C8C093";

      selection-foreground = "#C8C093";
      selection-background = "#223249";

      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 14;
      font-thicken = false;

      cursor-style-blink = false;
    };
  };

  programs.home-manager.enable = true;
}
