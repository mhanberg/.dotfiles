# Path to your oh-my-zsh installation.
export ZSH=/Users/mitchell/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="steeef"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export JAVA_HOME="$(/usr/libexec/java_home)"

source /usr/local/opt/asdf/asdf.sh
export PATH="/usr/local/opt/qt@5.5/bin:$PATH"

if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

#alias tmux="TERM=screen-256color-bce tmux"
