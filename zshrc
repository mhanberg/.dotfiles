#                   __
#     ____   _____ / /_   _____ _____
#    /_  /  / ___// __ \ / ___// ___/
#  _  / /_ (__  )/ / / // /   / /__
# (_)/___//____//_/ /_//_/    \___/
#

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
zplug "MichaelAquilina/zsh-you-should-use"

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

export PATH="/opt/homebrew/bin/qt@5.5/bin:$PATH"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="$brew_prefix/opt/python@3.9/libexec/bin:$PATH"
export PATH="$HOME/Library/Python/3.8/bin:$PATH"
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
export PATH="$(yarn global bin):$PATH"
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

alias luamake=/Users/mitchell/.cache/nvim/nlua/sumneko_lua/lua-language-server/3rd/luamake/luamake

if [ -f "$brew_prefix"/opt/asdf/libexec/asdf.sh ]; then
  . "$brew_prefix"/opt/asdf/libexec/asdf.sh
fi

eval "$(starship init zsh)"

eval "$(direnv hook zsh)"
