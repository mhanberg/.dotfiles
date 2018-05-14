# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="steeef"
plugins=(git)
disable r

source $ZSH/oh-my-zsh.sh
if [ -f /usr/libeexec/java_home ]; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

if [ -f $HOME/.asdf/asdf.sh ]; then
  source $HOME/.asdf/asdf.sh
fi

export PATH="/usr/local/opt/qt@5.5/bin:$PATH"

if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

alias blog="cd ~/Development/blog"
alias dotfiles="cd ~/.dotfiles"
alias v="vim ."

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
