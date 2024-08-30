# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# Tab Completion Settings
autoload -U colors && colors
autoload -U compinit && compinit -u
setopt auto_menu
setopt complete_in_word
setopt always_to_end
zstyle ':completion:*' menu select
## Auto complete with case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
## For all completions: Selected item color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} 'ma=0\;30;44'
## For all completions: Commands color
zstyle ':completion:*:commands' list-colors '=*=1;33'
## For all completions: Options color
zstyle ':completion:*:options' list-colors '=^(-- *)=36'
zmodload zsh/complist
compinit
_comp_options+=(globdots) #Hidden files
## Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.cache/zsh/tab-cache

# History Settings
HISTFILE=$HOME/.cache/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY_TIME
setopt hist_verify

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi



# VI mode
#bindkey -v
#export KEYTIMEOUT=1

# Use vim keys in tab completion menu
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'right' vi-forward-char

# Fix backspace bug when switching modes
#bindkey "^?" backward-delete-char

# Change directory with LF
bindkey -s "^o" "lfcd\n"

# Home, End, Delete keybinds
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '\e[3~' delete-char



# General
alias ..='cd ..; ls'
alias ..=' cd ..; ls'
alias ...=' cd ..; cd ..; ls'
alias ....=' cd ..; cd ..; cd ..; ls'
alias src='source ${ZDOTDIR}/.zshrc'
alias zshrc='${=EDITOR} ${ZDOTDIR}/.zshrc'
alias m='micro'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS}'
alias ip='ip -c'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias btw='fastfetch'
alias code-extensions='code --list-extensions | xargs -L 1 echo code --install-extension'
alias d2ua='find . -type f -print0 | xargs -0 dos2unix'

# System
alias df='df -Tha --total'
alias du='du -ach | sort -h'
alias free='free -mtl'
alias p='procs'
alias pw='p -w'
alias kill='killall -q'
alias mypip='curl http://ifconfig.me/; echo'
alias mypipinfo='curl https://ipinfo.io/json/; echo'
alias ping='ping -c 5'
alias cpuinfo='lscpu'
alias agpu='glxinfo | grep "OpenGL renderer"'
alias ccram="ClearRamCache"

# History, Search history, Case sensative history
alias h="fc -fl"
alias hs="fc -fl 0 | grep"
alias hsi="fc -fl 0 | grep -i"

# EXA
alias ls='eza --icons always --color always --group-directories-first'
alias lsf='eza --icons always --color always --group-directories-first -f'
alias lsd='eza --icons always --color always --group-directories-first -D'
alias la='eza --icons always --color always --group-directories-first -a'
alias ll='eza --icons always --color always --group-directories-first --git -hbl'
alias lla='eza --icons always --color always --group-directories-first --git -hbla'
alias llg='eza --icons always --color always --group-directories-first --git -hblag'
alias lls='eza --icons always --color always --group-directories-first --git -hblas size'
alias lld='eza --icons always --color always --group-directories-first --git -hblaUum'
alias lt='eza --icons always --color always --group-directories-first -T'
alias lta='eza --icons always --color always --group-directories-first -Ta'

# TMUX
alias t='tmux'
alias tn='tmux new'
alias tns='tmux new -s'
alias tks='tmux kill-session -t'
alias tka='tmux kill-session -a'
alias tls='tmux list-sessions'
alias ta='tmux attach'
alias tas='tmux attach -t'
alias tlsk='tmux list-keys'
alias ti='tmux info'

# GIT
alias glr='~/.local/bin/convert-gitlab-ssh.sh'
alias ghr='~/.local/bin/convert-github-ssh.sh'
# SSH
alias sshrsa='ssh-keygen -t rsa -b 4096'
alias sshag='eval "$(ssh-agent -s)"'

alias sshgh='ssh-add ~/.ssh/id_GitHub'
alias sshgl='ssh-add ~/.ssh/id_GitLab'
alias sshrpi='ssh-add ~/.ssh/id_RPi'

# Pacman
alias pacupd="sudo pacman -Sy"
alias pacupg='sudo pacman -Syu'
alias pacmir='sudo pacman -Syy'
alias pacin='sudo pacman -S'
alias pacins='sudo pacman -U'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacinsd='sudo pacman -S --asdeps'
alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'
alias pacfileupg='sudo pacman -Fy'
alias pacfiles='pacman -F'
alias pacls='pacman -Ql'
alias pacown='pacman -Qo'
alias pacmanallkeys='sudo pacman-key --refresh-keys'
alias paccac='sudo pacman -Sc'
alias pacmirror='reflector_mirror'

# Paru
alias parupg='paru -Sua --upgrademenu'
alias parus='paru -Si'
alias parucac='paru -Sc'



source ${ZDOTDIR}/themes/starship.zsh
source ${ZDOTDIR}/functions.zsh
source ${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosugesstions.plugin.zsh
source ${ZDOTDIR}/plugins/zsh-completions/zsh-completions.plugin.zsh
source ${ZDOTDIR}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting/plugin.zsh
source ${ZDOTDIR}/plugins/colored-man-pages.plugin.zsh
source ${ZDOTDIR}/plugins/command-not-found.plugin.zsh
source ${ZDOTDIR}/plugins/dirhistory.plugin.zsh
source ${ZDOTDIR}/plugins/extract.plugin.zsh
source ${ZDOTDIR}/plugins/git.plugin.zsh
source ${ZDOTDIR}/plugins/ssh.plugin.zsh
source ${ZDOTDIR}/plugins/ssh-agent.plugin.zsh
source ${ZDOTDIR}/plugins/sudo.plugin.zsh
source ${ZDOTDIR}/plugins/you-should-use.plugin.zsh

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
else
    echo 'Starship not found, please install it from https://starship.rs'
fi