
##################### User Configuration ########################
# set path for grpc
if command -v go &> /dev/null; then
	export PATH="$PATH:$(go env GOPATH)/bin"
fi

# it's kind of overwhelming to attach tmux whenever I start a new one,
# therefore, disabling it, and provide alias
# alias tmux="tmux new -s mytmux"
alias tmuxa="tmux attach -t mytmux"
alias tmuxs="tmux new -A -s mytmux"

setopt IGNORE_EOF

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# System specific settings
export EDITOR=nvim

if [[ "$(uname)" == "Darwin" ]]; then
	# set terminfo to be alacritty
	# export TERM=alacritty
	# set commands to start aria2 for macos
	alias start-aria2='aria2c --conf-path="$HOME/.aria2/aria2.conf\"'
	# set homebrew path
  eval $(/opt/homebrew/bin/brew shellenv)
	export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
	export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
	export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
	export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_INSTALL_FROM_API=1

elif [[ "$(uname -r)" == *WSL* ]]; then
	export BROWSER="/mnt/c/Program Files/google/Chrome/Application/chrome.exe"
else
	export BROWSER=google
fi

###### aliases #####
alias ra=ranger
alias yz=yazi
alias ws=web_search
alias vim=nvim
alias cnv="cd ~/.config/nvim/"
alias cwm="cd ~/.local/opt/dwm/"
alias dot="cd ~/.dotfiles/"
alias prj="cd ~/Projects"
alias lg=lazygit
alias clangfmt="clang-format --dump-config --style=\"{BasedOnStyle: LLVM, IndentWidth: 4}\" > .clang-format"

# environment variables
# source ~/.OPENAI-API-KEY

# for gpg
export GPG_TTY=$(tty)


# for the installation of nodejs and npm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


######################## ZIM setting
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh
# to override exa default setting for ls
alias ls='eza --group-directories-first --icons'
