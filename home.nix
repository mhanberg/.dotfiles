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
      mise
      neovim-nightly
      neovim-remote
      nil
      nodePackages.bash-language-server
      nodejs
      ripgrep
      rust-analyzer
      selenium-server-standalone
      shellcheck
      shfmt
      silicon
      sqlite
      sqlite-interactive
      starship
      stylua
      tmux
      tmuxinator
      tree-sitter
      vim
      yarn
      zk
      zsh
    ]
    ++ (
      if pkgs.stdenv.isLinux
      then [clang clang-tools backblaze-b2 xclip unixtools.ifconfig inotify-tools]
      else []
    );

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
    # ".zshrc".source = ./zshrc;
  };

  programs.zsh = {
    enable = true;
    autocd = true;

    initExtra = ''
      #                   __
      #     ____   _____ / /_   _____ _____
      #    /_  /  / ___// __ \ / ___// ___/
      #  _  / /_ (__  )/ / / // /   / /__
      # (_)/___//____//_/ /_//_/    \___/
      #


      export HOMEBREW_NO_GOOGLE_ANALYTICS=1
      export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo

      if uname -a | grep -i "darwin" > /dev/null; then
        export CLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
        export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
        brew_prefix='/opt/homebrew'

        eval $(/opt/homebrew/bin/brew shellenv)
      fi

      export TMPDIR="$(mktemp -d)"
      export EDITOR="nvim"
      export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/'"

      function maybe_touch() {
        if [ ! -f "$1" ]; then
          touch "$1"
        fi
      }

      unset -v GEM_HOME

      maybe_touch "$HOME/.zsh/aliases.local"
      maybe_touch "$HOME/.zsh/zshrc.local"

      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "''${ZINIT_HOME}/zinit.zsh"

      zinit ice wait lucid
      zinit light-mode for \
          zdharma-continuum/zinit-annex-as-monitor \
          zdharma-continuum/zinit-annex-bin-gem-node \
          zdharma-continuum/zinit-annex-patch-dl \
          zdharma-continuum/zinit-annex-rust


      zinit wait lucid for \
       atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
          zdharma-continuum/fast-syntax-highlighting \
       blockf \
          zsh-users/zsh-completions \
       atload"!_zsh_autosuggest_start" \
          zsh-users/zsh-autosuggestions
      zinit snippet OMZL::key-bindings.zsh
      zinit snippet OMZL::history.zsh
      zinit snippet OMZP::colored-man-pages
      zinit snippet OMZP::fzf

      zinit ice wait lucid
      zinit ice as'completion'
      zinit snippet OMZP::gh

      # autoload -U compinit && compinit

      # echo "sourcing zsh files"
      for file (~/.zsh/*); do
        source $file
      done

      disable r
      setopt nohistignoredups
      setopt ignoreeof

      export PATH="/opt/homebrew/bin/qt@5.5/bin:$PATH"
      export PATH="$HOME/.bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"
      # export PATH="$HOME/Library/Python/3.9/bin:$PATH"
      # export PATH="$brew_prefix/opt/python@3.9/libexec/bin:$PATH"
      # export PATH="$HOME/Library/Python/3.8/bin:$PATH"
      # export PATH="$HOME/Library/Python/2.7/bin:$PATH"
      # export PATH="$HOME/go/bin:$PATH"
      # export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
      # export PATH="$HOME/zls/zig-out/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"

      # Enable shell history in iex
      export ERL_AFLAGS="-kernel shell_history enabled"
      export KERL_BUILD_DOCS=yes

      # source "$brew_prefix"/opt/fzf/shell/key-bindings.zsh
      # echo "sourcing fzf.zsh"
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

      if command -v mise >/dev/null; then
        eval "$(mise activate zsh)"
      else
        eval "$(rtx activate zsh)"
      fi

      #compdef gt
      ###-begin-gt-completions-###
      #
      # yargs command completion script
      #
      # Installation: /opt/homebrew/bin/gt completion >> ~/.zshrc
      #    or /opt/homebrew/bin/gt completion >> ~/.zprofile on OSX.
      #
      _gt_yargs_completions()
      {
        local reply
        local si=$IFS
        IFS=$'
      ' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /opt/homebrew/bin/gt --get-yargs-completions "''${words[@]}"))
        IFS=$si
        _describe 'values' reply
      }
      compdef _gt_yargs_completions gt
      ###-end-gt-completions-###
      if [[ "$(uname)" == "Linux" ]]; then
        export LC_ALL="C.UTF-8"
      fi
      eval "$(starship init zsh)"

      eval "$(direnv hook zsh)"
    '';
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
