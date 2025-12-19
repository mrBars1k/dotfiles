# ------------------------------ bashrc ------------------------------ #

[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

export LANG=en_US.UTF-8
export LC_TIME=ru_RU.UTF-8
export PATH=/home/mrbars1k/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

# ----------------------------- Aliases ------------------------------ #

alias ls='ls --color=auto'
alias lah="ls -lAh"
alias grep='grep --color=auto'
alias vim="nvim"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/mrbars1k/.lmstudio/bin"
# End of LM Studio CLI section

