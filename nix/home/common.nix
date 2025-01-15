{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".bin".source = ../../bin;
    ".bin".recursive = true;
    ".config".source = ../../config;
    ".config".recursive = true;
    ".gitignore_global".source = ../../gitignore_global;
    ".vsnip/elixir.json".source = ../../vsnip/elixir.json;
    ".xterm-256color.terminfo".source = ../../xterm-256color.terminfo;
  };

  xdg.enable = true;

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-s";
    baseIndex = 1;
    terminal = "xterm-ghostty";
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      bind-key - split-window -v -c '#{pane_current_path}'
      bind-key \\ split-window -h -c '#{pane_current_path}'

      set -a terminal-features '*:usstyle'
      set -as terminal-features ',xterm-ghostty:clipboard'
      set -g allow-passthrough on
      set -s set-clipboard on
      set -g set-titles on
      set -g set-titles-string "#S (#W)"
      set-option -g focus-events on
      #Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
      bind-key -n C-'\' if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      bind-key -T copy-mode-vi C-h select-pane -L
      bind-key -T copy-mode-vi C-j select-pane -D
      bind-key -T copy-mode-vi C-k select-pane -U
      bind-key -T copy-mode-vi C-l select-pane -R
      bind-key -T copy-mode-vi C-'\' select-pane -l
      bind C-r source-file ~/.config/tmux/tmux.conf \; display "Reloaded ~/.config/tmux/tmux.conf"
      set -g status-keys "emacs"
      set -g renumber-windows on
      bind-key b break-pane -d

      bind C-j display-popup -B -E -w "50%" -h "50%" -y "0"  "tmux-switch-clients"
      bind C-y display-popup -B -E -w "50%" -h "50%" -y "0"  "tmux-open-project"

      bind C-m display-popup -E -w "90%" -h "90%" -e XDG_CONFIG_HOME="$HOME/.config" "lazygit"
      bind C-u display-popup -E -w "90%" -h "90%" "btop"
      bind C-h display-popup -E -w "90%" -h "90%"  "fzf-prs"
      bind C-i display-popup -E -w "90%" -h "90%"  "fzf-issues"

      unbind-key C-d

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # bind-key -T vi-copy v begin-selection
      # bind-key -T vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

      # unbind -T vi-copy Enter
      # bind-key -T vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"
    '';
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
  };

  programs.git = {
    enable = true;
    userName = "Mitchell Hanberg";
    userEmail = "mitch@mitchellhanberg.com";
    # signing = {
    #   key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDckxDud0PGdGd60v/1SUa0pbWWe46FcVIbuTijwzeZR";
    # };
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
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
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
    sessionVariables = {
      EDITOR = "nvim";
      ERL_AFLAGS = "-kernel shell_history enabled";
      KERL_BUILD_DOCS = "yes";
      CLOUD = "$HOME/Library/Mobile Documents/com~apple~CloudDocs/";
      ICLOUD = "$HOME/Library/Mobile Documents/com~apple~CloudDocs";
    };

    shellAliases = {
      tsr = "tailscale serve reset";

      dev = "tmux-open-project";

      nublar = "ssh -q mitchell@nublar -L 4999:localhost:4999 -L 8000:localhost:8000";
      tmux = "direnv exec / tmux";
      blog = "cd ~/Development/blog";
      em = "mix ecto.migrate";
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

      # tmux
      tp = "tmux-switch-clients";

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

      # aliases that use env vars or spaces
      alias icloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
      alias home="cd $HOME"
      alias rebuild-blog="curl -X POST -d {} https://api.netlify.com/build_hooks/$NETLIFY_BLOG_ID"
      export PATH="$HOME/.bin:$PATH"
      # export PATH="$HOME/.local/bin:$PATH"

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

  programs.fzf = {
    enable = true;
    defaultCommand = "rg --files --hidden --glob '!.git/'";
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

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
    package = null;
    installBatSyntax = false;
    settings = {
      shell-integration-features = "no-cursor";
      font-family = "JetBrainsMono Nerd Font Mono";
      font-thicken = false;

      cursor-style-blink = false;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --paging=never";
          useConfig = false;
        };
        commit = {
          signOff = false;
          verbose = "default";
        };
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
        allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium";
        overrideGpg = false;
        disableForcePushing = false;
        confirmOnQuit = false;
        os = {
          open = "open -- {{filename}}";
          openLink = "open {{link}}";
        };
        disableStartupPopups = false;
        notARepository = "prompt";
      };
    };
  };

  programs.home-manager.enable = true;
}
