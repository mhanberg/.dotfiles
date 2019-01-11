# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export EDITOR="vim"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mah"

source $ZSH/oh-my-zsh.sh

disable r
setopt nohistignoredups

if [ -f /usr/libeexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

if [ -f $HOME/.asdf/asdf.sh ]; then
  source $HOME/.asdf/asdf.sh
fi

export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

if [ -f ~/.zsh/aliases ]; then
  source ~/.zsh/aliases
fi

if [ -f ~/.zsh/funcs ]; then
  source ~/.zsh/funcs
fi

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
