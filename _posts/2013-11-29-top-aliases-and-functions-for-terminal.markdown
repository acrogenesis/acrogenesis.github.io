---
author: acrogenesis
comments: true
date: 2013-11-29 16:27:53+00:00
layout: AcrogenesisCom.PostLayout
slug: top-aliases-and-functions-for-terminal
title: My top aliases and functions for terminal
wordpress_id: 40
categories:
- Terminal
permalink: /:slug
---

This are my top aliases for terminal, I've order them on how frequently I use them and separated by topics.

To add this aliases and functions to your terminal simply run ```bash vim ~/.bash_profile ``` if it doesn't exit it will create a new one.

Git


```bash
alias psh="git push origin" #push to origin specifying branch, ex. psh master
alias pll="git pull origin" #pull from origin specifying branch, ex. pll master
alias cmm="git commit -m" #commit
alias cmma="git commit -am" #commit and add modified files
rgc() {
  git commit -m"`curl -s http://whatthecommit.com/index.txt`" #get a random commit message from whatthecommit.com
}
function gc() { git clone "$1" && cd `echo "'$1'" | cut -d/ -f2 | cut -d. -f1`; } # clones git repository and cd's into it
```


Files and Folders


```bash
alias dev="cd ~/Copy/Development" #cd to my development folder
alias editbash="mvim ~/.bash_profile" #open my bash_profile in MacVim (you can change this to the editor you wish)
function mcd() { mkdir -p "$1" && cd "$1";} #mkdir a folder and cd into it
```


DNS


```bash
alias cleardns="sudo killall -HUP mDNSResponder" #clear dns on 10.8+
```


Changing Mac Address(I'm using en0 check which interface you use running ifconfig)


```bash
alias mac="sudo ifconfig en0 ether" #specify a mac address, ex mac 11:22:33:44:55:66
alias mymac="sudo ifconfig en0 ether 11:22:33:44:55:66" #revert back to my mac address, you have to check you mac address first.
alias chkmac="ifconfig en0 |grep ether" #check the mac I currently use
alias ranmac="openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'" # generate a random mac address
rmac(){
  sudo ifconfig en0 ether `ranmac`; #apply a random mac address
}
```


Beautiful Terminal (when on a git repository it show the branch you are on)


```bash
# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
function prompt {
  local GRAY="\[\033[0;37m\]"
  local WHITE="\[\033[1;37m\]"
  local GREEN="\[\033[0;32m\]"
  local CYAN="\[\033[0;36m\]"
  local MAGENTA="\[\033[0;35m\]"
  local RED="\[\033[0;31m\]"
  local BLACK="\[\033[0;30m\]"
  local YELLOW="\[\033[0;33m\]"
  local BLUE="\[\033[0;34m\]"
  export PS1="${GREEN}\u@${WHITE}mbp:${RED}acrogenesis${WHITE}\$(parse_git_branch) \w \`if [ \$? = 0 ]; then echo -e '\[\e[01;32m\]\n\xF0\x9F\x9A\x80'; else echo -e '\[\e[01;31m\]\n\xF0\x9F\x9A\x80'; fi\` \[\e[01;34m\]\[\e[00m\] "
  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced
}
prompt
```

[gallery columns="2" link="none" type="slideshow" ids="48,47"]
