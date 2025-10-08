# ------------------------------ zshrc ------------------------------- #

export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_TIME=ru_RU.UTF-8
export PATH=/home/mrbars1k/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

ZSH_THEME="mrbars1k"                #  ~/.oh-my-zsh/custom/themes
HIST_STAMPS="dd.mm.yyyy"            #  "mm/dd/yyyy" | "dd.mm.yyyy" | "yyyy-mm-dd"
zstyle ':omz:update' mode reminder  #  auto / disabled / reminder

plugins=(zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ------------------------------ Custom ------------------------------ #

# автоматически переходить в ту же директорию в shell,
# в которой был на момент выхода в ranger;
ranger() {
    local tempfile="$(mktemp -t ranger_cd.XXXXXX)"
    command ranger --choosedir="$tempfile" "$@"
    if [ -s "$tempfile" ]; then
        local target_dir="$(cat "$tempfile")"
        cd "$target_dir" || return
    fi
    rm -f "$tempfile"
}

# ----------------------------- Aliases ------------------------------ #

alias ls='ls --color=auto'
alias lah="ls -lAh"
alias grep='grep --color=auto'
alias vim="nvim"
