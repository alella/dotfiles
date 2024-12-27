# requirements:
#  brew, pyenv, nvm, git
setopt sharehistory
setopt correctall
setopt extendedhistory
export HISTTIMEFORMAT="%T "
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.history
source ~/.zsh/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
export LC_ALL=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
bindkey -e


# Prompt setup (https://github.com/spaceship-prompt/spaceship-prompt)
## First time, run these:
# mkdir -p "$HOME/.zsh"
# git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.zsh/spaceship"
source "$HOME/.zsh/spaceship/spaceship.zsh"
export SPACESHIP_USER_SHOW="always"
export SPACESHIP_HOST_SHOW="always"
export SPACESHIP_EXEC_TIME_SHOW=true
export SPACESHIP_EXIT_CODE_SHOW=true
export SPACESHIP_ASYNC_SHOW_COUNT=true
export SPACESHIP_ASYNC_SYMBOL=⏳
export SPACESHIP_AWS_SHOW=true
export SPACESHIP_DOCKER_COMPOSE_SHOW=true
export SPACESHIP_DOCKER_SHOW=true


function gitl(){
    git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
}
function gits(){
    git branch
    echo ""
    echo ""
    git status $@
}
function paste_from_clipboard() {
    cat ~/.clipboard
}
function cd_back(){
	cd ..
	echo "$PWD\n\n"
}
zle -N cd_back
bindkey "^j" cd_back
# aliases
alias c="cb copy; cb paste>~/.clipboard"
alias diff="colordiff $@"
alias got="ps -ef|ack $@"
alias l="ls --color=yes -lh"
alias ll="ls --color=yes -lah"
alias ls="ls --color=yes"
alias p='paste_from_clipboard'
alias t='tmux attach'
alias zs="code ~/.zshrc;code ~/.zshrc"
# brew
if [[ "$(uname)" == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="~/.local/bin:$PATH"