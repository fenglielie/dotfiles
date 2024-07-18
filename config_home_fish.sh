#!/bin/bash

# Get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# Define target directory
target_dir="$HOME/.config/fish/conf.d"
target_file="$target_dir/mysetup.fish"

# Ensure the target directory exists
mkdir -p "$target_dir"

if [ -e "$target_file" ]; then
    echo "Error: File '$target_file' already exists. Please remove it or choose another location."
else
    # Create symlink
    ln -sf "$script_root_dir/fish/conf.d/mysetup.fish" "$target_file"
    echo "Fish config finished."
fi
