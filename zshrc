#                   __
#     ____   _____ / /_   _____ _____
#    /_  /  / ___// __ \ / ___// ___/
#  _  / /_ (__  )/ / / // /   / /__
# (_)/___//____//_/ /_//_/    \___/
#

# zmodload zsh/zprof
# profiling start
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '

# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile

# setopt XTRACE
# profiling end

# date
export TMPDIR="$(mktemp -d)"
export EDITOR="nvim"
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/'"
export ZPLUG_PROTOCOL="SSH"
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

unset -v GEM_HOME

if [ ! -f "$HOME/.zsh/aliases.local" ]; then
  touch "$HOME/.zsh/aliases.local"
fi

if [ ! -f "$HOME/.zsh/zshrc.local" ]; then
  touch "$HOME/.zsh/zshrc.local"
fi

# echo "starting zplug"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "lib/history", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "MichaelAquilina/zsh-you-should-use"
zplug "br/br-gitflow-completion"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

autoload -U compinit && compinit

# echo "sourcing zsh files"
for file (~/.zsh/*); do
  source $file
done

disable r
setopt nohistignoredups

if [ -f /usr/libeexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

if [ -f /usr/local/opt/asdf/asdf.sh ]; then
  source /usr/local/opt/asdf/asdf.sh
fi

export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/Library/Python/3.8/bin:$PATH"
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/go/bin:$PATH"

# Enable shell history in iex
export ERL_AFLAGS="-kernel shell_history enabled"

# echo "sourcing z.sh"
. /usr/local/etc/profile.d/z.sh

# echo "sourcing fzf.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source "$HOME"/.zshrc.local
source "$HOME"/.zsh/aliases.local

# echo "eval direnv"
eval "$(direnv hook zsh)"
# date
# profiling start
# unsetopt XTRACE
# exec 2>&3 3>&-
# profiling end
# zprof
