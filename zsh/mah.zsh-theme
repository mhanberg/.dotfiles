# This theme is modified from the steeef theme provided by oh-my-zsh
#
# This theme is meant to be used with the Jelly Beans iterm2colorscheme
#
# The exec time of last command is stolen from the zsh theme refined,
# which is based of off sindresorhuses pure theme.
#
# prompt style and colors based on Steve Losh's Prose theme:
# https://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# https://briancarper.net/blog/570/git-info-in-your-zsh-prompt

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
	[ $VIRTUAL_ENV ] && echo '('%F{blue}$(basename $VIRTUAL_ENV)%f') '
}

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%f"
FMT_BRANCH="(%F{yellow}%b%u%c${PR_RST})"
FMT_ACTION="(%F{cyan}%a${PR_RST})"
FMT_UNSTAGED="%F{red}●"
FMT_STAGED="%F{cyan}●"

zstyle ':vcs_info:*:prompt:*' unstagedstr "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats ""

# Displays the exec time of the last command if set threshold was exceeded
cmd_exec_time() {
	local stop=$(date +%s)
	local start=${cmd_timestamp:-$stop}
	let local elapsed=stop-start
	[ $elapsed -gt 5 ] && echo ${elapsed}s
}

function calculate_command_time {
	# Get the initial timestamp for cmd_exec_time
	cmd_timestamp=$(date +%s)
}

function format_vcs_info {
	# check for untracked files or updated submodules, since vcs_info doesn't
	if git ls-files --other --exclude-standard 2>/dev/null | grep -q "."; then
		FMT_BRANCH="(%F{yellow}%b%u%c%F{magenta}●${PR_RST})"
	else
		FMT_BRANCH="(%F{yellow}%b%u%c${PR_RST})"
	fi
	zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH} "

	vcs_info 'prompt'
}

add-zsh-hook preexec calculate_command_time
add-zsh-hook precmd format_vcs_info

PROMPT=$'
%F{blue}%~${PR_RST} $vcs_info_msg_0_$(virtualenv_info) %B%F{cyan}$(cmd_exec_time)${PR_RST}
⚡︎'
