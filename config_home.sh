#!/bin/bash

# Get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# tmux
if [ -e "$HOME/.tmux.conf" ]; then
    echo "Error: File '$HOME/.tmux.conf' already exists. Please remove it or choose another location."
else
    ln -sf "$script_root_dir/tmux/.tmux.conf" "$HOME/.tmux.conf"
    echo "tmux config finished."
fi

# vim
if [ -e "$HOME/.vimrc" ]; then
    echo "Error: File '$HOME/.vimrc' already exists. Please remove it or choose another location."
else
    ln -sf "$script_root_dir/vim/.vimrc" "$HOME/.vimrc"
    echo "vim config finished."
fi

# git
if [ -e "$HOME/.gitconfig" ]; then
    echo "Error: File '$HOME/.gitconfig' already exists. Please remove it or choose another location."
else
    ln -sf "$script_root_dir/git/.gitconfig" "$HOME/.gitconfig"
    echo "git config finished."
fi
