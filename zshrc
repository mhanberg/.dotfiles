# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="steeef"
plugins=(git)

source $ZSH/oh-my-zsh.sh
if [ -f /usr/libeexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

if [ -f /usr/local/opt/asdf/asdf.sh ]; then
  source /usr/local/opt/asdf/asdf.sh
fi

export PATH="/usr/local/opt/qt@5.5/bin:$PATH"

if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
