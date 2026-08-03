{ pkgs, ... }: {

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    historyLimit = 20000;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-s";
    baseIndex = 1;
    terminal = "xterm-ghostty";
    shell = if pkgs.stdenv.isDarwin then "/bin/zsh" else "~/.nix-profile/bin/zsh";
    extraConfig = ''
      bind-key - split-window -v -c '#{pane_current_path}'
      bind-key \\ split-window -h -c '#{pane_current_path}'

      set -a terminal-features '*:usstyle'
      set -as terminal-features ',xterm-ghostty:clipboard'
      set -g allow-passthrough all
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

      bind C-m run-shell "XDG_CONFIG_HOME="$HOME/.config" tmux-persistent-popup lazygit #{pane_current_path} lazygit"
      bind C-, run-shell "XDG_CONFIG_HOME="$HOME/.config" tmux-persistent-popup lazyjira #{pane_current_path} lazyjira"
      bind C-o run-shell "tmux-persistent-popup clanker #{pane_current_path} zsh"
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
}
