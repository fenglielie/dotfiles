#!/bin/bash

# Get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# Define target directory
target_dir="$HOME/.config/fish"

# Check if target directory already exists
if [ -e "$target_dir" ]; then
    echo "Error: Directory '$target_dir' already exists. Please remove it or choose another location."
else
    # Create symlink
    ln -sf "$script_root_dir/fish" "$target_dir"
    echo "Fish config finished."
fi
