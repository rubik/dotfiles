alias ls='ls --color=always'
alias la='ls -a'
alias grep='grep --color=always'
alias pacman='pacman-color'
alias upd='sudo pacman -Syy && sudo pacman -Syu'
alias orph='sudo pacman -R $(pacman -Qtdq)'
alias cacheclean='sudo cacheclean -v 1'

export EDITOR='vim'
# Bash prompt
bold_style=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)
export PS1="\[$bold_style\]\[$red\][\[$yellow\]\A\[$red\]]\[$cyan\] \u@\h:\[$green\]\W\[$white\]\$\[$reset\] "

# Sudo TAB completion
complete -cf sudo
