#                   __
#     ____   _____ / /_   _____ _____
#    /_  /  / ___// __ \ / ___// ___/
#  _  / /_ (__  )/ / / // /   / /__
# (_)/___//____//_/ /_//_/    \___/
#

function ensure_dep() {
	local dep
	dep="$1"

	if ! command -v "$dep" >/dev/null; then
		if command -v brew >/dev/null; then
			echo "⚠️ Installing \`$dep\` with homebrew"
			brew install "$dep"
		else
			echo "🚨 $dep is missing"
			exit 1
		fi
	fi
}

export HOMEBREW_NO_GOOGLE_ANALYTICS=1
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo

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

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait lucid
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::fzf

zinit ice wait lucid
zinit ice as'completion'
zinit snippet OMZP::gh

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
export KERL_BUILD_DOCS=yes

# echo "sourcing z.sh"
. "$brew_prefix"/etc/profile.d/z.sh

source "$brew_prefix"/opt/fzf/shell/key-bindings.zsh
# echo "sourcing fzf.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

ensure_dep "mise"
eval "$(mise activate zsh)"

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

ensure_dep "starship"
eval "$(starship init zsh)"

ensure_dep "direnv"
eval "$(direnv hook zsh)"
