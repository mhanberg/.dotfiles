#                   __
#     ____   _____ / /_   _____ _____
#    /_  /  / ___// __ \ / ___// ___/
#  _  / /_ (__  )/ / / // /   / /__
# (_)/___//____//_/ /_//_/    \___/
#

export HOMEBREW_NO_GOOGLE_ANALYTICS=1

if [ $(arch) = "arm64" ]; then
  brew_prefix='/opt/homebrew'

  eval $(/opt/homebrew/bin/brew shellenv)
else
  brew_prefix='/usr/local'
fi

if ! command -v starship >/dev/null; then
  echo "==> starship.rs not installed. Installing now..."
  brew install starship
fi

export TMPDIR="$(mktemp -d)"
export EDITOR="nvim"
export CLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/"
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/'"
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export ZPLUG_PROTOCOL="SSH"
export ZPLUG_HOME="$brew_prefix"/opt/zplug
source $ZPLUG_HOME/init.zsh

function maybe_touch() {
  if [ ! -f "$1" ]; then
    touch "$1"
  fi
}

if [ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ]; then
  source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
fi

unset -v GEM_HOME

maybe_touch "$HOME/.zsh/aliases.local"
maybe_touch "$HOME/.zsh/zshrc.local"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "lib/history", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh

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
setopt ignoreeof

if [ -f /usr/libeexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

export PATH="/opt/homebrew/bin/qt@5.5/bin:$PATH"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
# export PATH="$brew_prefix/opt/python@3.9/libexec/bin:$PATH"
export PATH="$HOME/Library/Python/3.8/bin:$PATH"
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
export PATH="$HOME/zls/zig-out/bin:$PATH"

# Enable shell history in iex
export ERL_AFLAGS="-kernel shell_history enabled"

# echo "sourcing z.sh"
. "$brew_prefix"/etc/profile.d/z.sh

source "$brew_prefix"/opt/fzf/shell/key-bindings.zsh
# echo "sourcing fzf.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -f "$brew_prefix"/opt/asdf/libexec/asdf.sh ]; then
  . "$brew_prefix"/opt/asdf/libexec/asdf.sh
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
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /opt/homebrew/bin/gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###

eval "$(starship init zsh)"

eval "$(direnv hook zsh)"
#compdef redocly
###-begin-redocly-completions-###
#
# yargs command completion script
#
# Installation: ../../.asdf/installs/nodejs/16.9.1/.npm/bin/redocly completion >> ~/.zshrc
#    or ../../.asdf/installs/nodejs/16.9.1/.npm/bin/redocly completion >> ~/.zsh_profile on OSX.
#
_redocly_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" ../../.asdf/installs/nodejs/16.9.1/.npm/bin/redocly --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _redocly_yargs_completions redocly
###-end-redocly-completions-###

