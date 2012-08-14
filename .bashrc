alias ls='ls --color=always'
alias la='ls -a'
alias grep='grep --color=always'
alias pacman='pacman-color'
alias upd='sudo pacman -Syy && sudo pacman -Syu'

export EDITOR='vim'
# Bash prompt
export PS1="\[\033[1;31m[\[\033[1;33m\$(date +%H:%M)\[\033[1;31m] \u:\[\033[1;32m\W\[\033[1;37m\$\[\033[0m\] "

# Sudo TAB completion
complete -cf sudo
