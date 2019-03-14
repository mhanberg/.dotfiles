# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export EDITOR="vim"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mah"

plugins=(zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

disable r
setopt nohistignoredups

if [ -f /usr/libeexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

if [ -f $HOME/.asdf/asdf.sh ]; then
  source $HOME/.asdf/asdf.sh
  source $HOME/.asdf/completions/asdf.bash
fi

export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

function () {
  GIT_ZSH_COMPLETIONS_FILE_PATH="$(brew --prefix)/share/zsh/site-functions/_git"
  if [ -f $GIT_ZSH_COMPLETIONS_FILE_PATH ]
  then
    rm $GIT_ZSH_COMPLETIONS_FILE_PATH
  fi
}

if [ -f ~/.zsh/aliases ]; then
  source ~/.zsh/aliases
fi

if [ -f ~/.zsh/funcs ]; then
  source ~/.zsh/funcs
fi

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

export PATH="/Users/mahanberg/.asdf/installs/nodejs/10.13.0/.npm/bin:$PATH"
export PATH="/Users/mahanberg/.asdf/installs/nodejs/11.0.0/.npm/bin:$PATH"

# Enable shell history in iex
export ERL_AFLAGS="-kernel shell_history enabled"
