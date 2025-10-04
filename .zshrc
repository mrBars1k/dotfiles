# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mrbars1k"

# zstyle ':omz:update' mode auto / disabled / reminder
zstyle ':omz:update' mode reminder

# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

plugins=(zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration
alias lah="ls -lAh --color=auto"
alias vim="nvim"

export LANG=en_US.UTF-8
export LC_TIME=ru_RU.UTF-8

export PATH=/home/mrbars1k/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

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
