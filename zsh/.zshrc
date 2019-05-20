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
# autoload -Uz up-line-or-search
# autoload -Uz down-line-or-history
# zle -N up-line-or-beginning-search up-line-or-beginning-search
# zle -N down-line-or-history
# bindkey "^[[A" up-line-or-search
# bindkey "^[[B" down-line-or-history

# Fix for above
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward
##Setting colors
export TERM=xterm-256color
autoload -U compinit promptinit
compinit
promptinit
autoload -U colors
colors
export LS_COLORS='di=1;34:ln=35:so=32:pi=0;33:ex=32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=1;34:ow=1;34:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:*' menu yes select
eval $(dircolors ~/.dir_colors)

#Functions
# Shell inside emacs fails when bindkeys with Ctrl is used
# Had to add this override to avoid this
if [ -n "$INSIDE_EMACS" ]; then
    echo "Inside emacs" 
else
    function cd_back(){
	cd ..
	echo ""
	echo "$fg[blue]$PWD$reset_color>\c"
    }
    zle -N cd_back
    bindkey "^j" cd_back
fi

function extract () {
    if [ -f $1 ] ; then
	case $1 in
	    *.tar.bz2)   tar xjvf $1     ;;
	    *.tar.gz)    tar xzvf $1     ;;
	    *.tar.xz)    tar xpvf $1     ;;
	    *.bz2)       bunzip2 $1     ;;
	    *.rar)       unrar e $1     ;;
	    *.gz)        gunzip $1      ;;
	    *.tar)       tar xf $1      ;;
	    *.tbz2)      tar xjf $1     ;;
	    *.tgz)       tar xzf $1     ;;
	    *.zip)       unzip $1       ;;
	    *.Z)         uncompress $1  ;;
	    *.7z)        7z x $1        ;;
	    *)     echo "'$1' cannot be extracted via extract()" ;;
	esac
    else
	echo "'$1' is not a valid file"
    fi
}

function pkill(){
    echo `ps -ef|grep -v grep|grep $1|head -n 1`
    pid=`ps -ef|grep -v grep|grep $1|awk '{print $2}'|head -n 1`
    echo "Killing..."
    sleep 2
    kill -9 $pid
}

function pterm(){
    echo `ps -ef|grep -v grep|grep $1|head -n 1`
    pid=`ps -ef|grep -v grep|grep $1|awk '{print $2}'|head -n 1`
    echo "Terming..."
    sleep 2
    kill -15 $pid
}

function paste_from_clipboard() {
    cat ~/.clipboard
}


runonchange () {
    filename=$1
    run=$2
    echo "Will be running \"$run\" when \"$filename\" changes"
    LTIME=`stat -c %Z ${filename}`
    run_count=0
    while true
    do
	ATIME=`stat -c %Z ${filename}`
	if [[ "$ATIME" != "$LTIME" ]]
	then
	    run_count=$((${run_count}+1))
	    echo "\033[0;31m RUN COUNT = ${run_count} \033[0m"
	    eval $run
	    LTIME=$ATIME
	fi
	sleep 1
    done
}

pyrun () {
    cat *.py> /tmp/pyrun
    run=$1
    LTIME=`md5sum /tmp/pyrun`
    run_count=0
    while true
    do
	cat *.py> /tmp/pyrun
	hash=`md5sum /tmp/pyrun`
	if [[ "$hash" != "$LTIME" ]]
	then
	    run_count=$((${run_count}+1))
	    echo "\033[0;31m RUN COUNT = ${run_count} | $run \033[0m"
	    eval $run
	    LTIME=$hash
	fi
	sleep 2
    done
}

function gitl(){
    git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
}
function gits(){
    git branch
    echo ""
    echo ""
    git status $@
}

function compile-org-to-html(){
  fname=$1;
  runonchange $1 "emacs -nw $1 -f org-html-export-to-html --kill"
}

function timer(){
    for i in {$1..000}; do
	sleep 1;
	echo $i;
    done
}


#exports
export EDITOR="/usr/bin/emacs -nw"
source ~/.zsh/git-prompt/zshrc.sh
PROMPT='%{$fg[red]%}%M%{$reset_color%}% %{$fg[blue]%}%1d%b$(git_super_status)>%{$reset_color%}'

#aliases
alias c="xclip; xclip -o>~/.clipboard"
alias diff="colordiff $@"
alias gdrive="python2 ~/myscripts/gdrive.py"
alias got="ps -ef|ack $@"
alias host="sudo python2 -m SimpleHTTPServer 80"
alias l="ls --color=yes -lh"
alias ls="ls --color=yes"
alias p='paste_from_clipboard'
alias py2="sudo rm /usr/bin/python;sudo ln -s /usr/bin/python2 /usr/bin/python"
alias py3="sudo rm /usr/bin/python;sudo ln -s /usr/bin/python3 /usr/bin/python"
alias tmux="TERM=screen-256color-bce tmux"
alias zs="emacs ~/.zshrc;source ~/.zshrc"
alias S="sudo pacman --noconfirm -S $@"
alias R="sudo pacman -Rns $@"
alias rc="cd;emacs .config/awesome/rc.lua"

