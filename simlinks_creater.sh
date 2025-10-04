#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

files=(
    .bashrc
    .zshrc
    .sqliterc
    .vimrc
    .gitconfig
    .config/hypr
    .config/waybar
    .config/swaync
    .config/wofi
    .config/swappy
    .config/kitty
    .config/ranger
    .config/vesktop
    .config/gsimplecal
    .config/fastfetch
)

for i in "${files[@]}"; do
    target="$HOME/$i"
    source="$DOTFILES/$i"

    mkdir -p "$(dirname "$target")"

    rm -rf "$target"

    ln -s "$source" "$target"
    echo "Linked $source → $target"
done


