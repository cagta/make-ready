[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

alias python='python3'
alias python2='/usr/bin/python2.7'

# Simple listing commands.
alias ls='ls -AlhG --color=always'
alias ll='ls'
alias ..='cd ..'

# Simple shortcuts.
alias ccat='source-highlight --out-format=esc -o STDOUT -i'
alias bhelp='ccat ~/.bash_profile'
alias bref='cp ~/Code/bash-profile/.bash_profile ~/; source ~/.bash_profile'
alias grg='cd ~/Code'

# Database related
alias udb='sudo su - postgres'
alias dbstat='systemctl status postgresql-9.4.service'
alias dbrest='sudo systemctl restart postgresql-9.4.service'

# Git-related shortcuts.
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpdev='gp origin dev'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias grao='git remote add origin'
alias gcb='git checkout -b'