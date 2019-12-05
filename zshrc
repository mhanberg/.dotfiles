export EDITOR="nvim"
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/'"
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

autoload -U compinit && compinit

if [ ! -f "$HOME/.zsh/aliases.local" ]; then
  touch "$HOME/.zsh/aliases.local" 
fi

if [ ! -f "$HOME/.zsh/zshrc.local" ]; then
  touch "$HOME/.zsh/zshrc.local" 
fi

for file (~/.zsh/*); do
  source $file
done

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

disable r
setopt nohistignoredups

if [ -f /usr/libeexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

if [ -f $(brew --prefix asdf)/asdf.sh ]; then
  source $(brew --prefix asdf)/asdf.sh
  source $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
fi

export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/nushell-0.5.0:$PATH"


if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

# Enable shell history in iex
export ERL_AFLAGS="-kernel shell_history enabled"

. /usr/local/etc/profile.d/z.sh

