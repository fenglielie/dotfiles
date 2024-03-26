#!/bin/bash

# Get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# Define project root directory
project_root_dir="$HOME/projectroot"

# .editorconfig
if [ -e "$project_root_dir/.editorconfig" ]; then
    echo "Error: File '$project_root_dir/.editorconfig' already exists. Please remove it or choose another location."
else
    ln -sf "$script_root_dir/editorconfig/.editorconfig" "$project_root_dir/.editorconfig"
    echo ".editorconfig config finished."
fi

# .clang-format
if [ -e "$project_root_dir/.clang-format" ]; then
    echo "Error: File '$project_root_dir/.clang-format' already exists. Please remove it or choose another location."
else
    ln -sf "$script_root_dir/clang/.clang-format" "$project_root_dir/.clang-format"
    echo ".clang-format config finished."
fi

# .clang-tidy
if [ -e "$project_root_dir/.clang-tidy" ]; then
    echo "Error: File '$project_root_dir/.clang-tidy' already exists. Please remove it or choose another location."
else
    ln -sf "$script_root_dir/clang/.clang-tidy" "$project_root_dir/.clang-tidy"
    echo ".clang-tidy config finished."
fi
