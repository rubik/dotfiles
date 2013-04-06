alias ls='ls --color=always'
alias la='ls -a'
alias grep='grep --color=always'
alias less='less -R'
alias tree='tree -C'
alias pacman='pacman-color'
alias upd='sudo pacman -Syy && sudo pacman -Syu'
alias orph='sudo pacman -R $(pacman -Qtdq)'
alias cacheclean='sudo cacheclean -v 1'
alias svim='HOME=/home/miki && sudoedit'

export TERM='rxvt-unicode'
export EDITOR='vim'
export PATH=$PATH:~/android-sdk-linux/tools
export PATH=$PATH:~/android-sdk-linux/platform-tools
# Ruby gems
export PATH=$PATH:~/.gem/ruby/2.0.0/bin

# Python For Android
export ANDROIDSDK=$HOME/android-sdk-linux
export ANDROIDNDK=$HOME/android-ndk-r8b
export ANDROIDNDKVER=r7
export ANDROIDAPI=14

android-proj() {
  # Create a new Android project
  # ----------------------------
  # Arguments:
  # * $1: Target
  # * $2: Project Name
  # * $2: Workspace (default to ~/android-workspace
  local _workspace=$HOME/android-workspace
  target=$1
  name=$2
  workspace=${3-$_workspace}
  android create project --target $target --name $name \
      --path $workspace/$name --activity MainActivity \
      --package com.mine.${name,,}
}

# Yooo virtualenvs
# I don't want virtualenvwrapper, I want a simple a!!
function a() {
    # If an argument is not supplied, current wd is assumed.
    local _dir=$(pwd)
    dir=${1-$_dir}
    cd $dir
    source bin/activate
    cd $_dir
}

function proj(){
    django-admin.py startproject \
        --template=https://github.com/lincolnloop/django-layout/zipball/master \
        --extension=py,rst,gitignore,example $1
}

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


# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ----------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat $1 | cb; }
# Copy SSH public key
alias cbssh="cat ~/.ssh/id_rsa.pub | cb"
# Copy current working directory
alias cbwd="pwd | cb"
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"

# Sudo TAB completion
complete -cf sudo
# Git TAB completion
source $HOME/.git-completion.bash
