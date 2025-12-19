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

parse() {
    cd /home/mrbars1k/Melon || return
    source venv/bin/activate
    python3 main.py parse "$@" --use mangalib
}

build-manga() {
    cd /home/mrbars1k/Melon || return
    source venv/bin/activate
    python3 main.py build-manga "$@" --use mangalib
}


# ----------------------------- Aliases ------------------------------ #

alias ls='ls --color=auto'
alias lah="ls -lAh"
alias grep='grep --color=auto'
alias vim="nvim"
alias vpn="~/.dotfiles/./vpn.sh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/mrbars1k/.lmstudio/bin"
# End of LM Studio CLI section

