#!/usr/bin/env bash
set -e

print_divider() {
    echo -e "\n============================================================"
}

run_step() {
    local desc="$1"
    shift
    echo -e "\n==> $desc..."
    
    if "$@"; then
        echo "✅ $desc выполнено успешно"
    else
        echo "❌ Ошибка при $desc"
        exit 1
    fi

    print_divider
}

export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes

run_step "Установка Oh My Zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

run_step "Установка темы" ln -fs $HOME/.dotfiles/mrbars1k.zsh-theme $HOME/.oh-my-zsh/custom/themes/mrbars1k.zsh-theme
run_step "Установка .zshrc" ln -fs $HOME/.dotfiles/.zshrc $HOME/.zshrc

PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

run_step "Клонирование zsh-autosuggestions" git clone https://github.com/zsh-users/zsh-autosuggestions $PLUGINS_DIR/zsh-autosuggestions
run_step "Клонирование zsh-syntax-highlighting" git clone https://github.com/zsh-users/zsh-syntax-highlighting $PLUGINS_DIR/zsh-syntax-highlighting

run_step "Запуск Zsh" zsh -c "echo 'Zsh работает'"

run_step "Смена shell на zsh" chsh -s /usr/bin/zsh
