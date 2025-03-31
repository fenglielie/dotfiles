# Dotfiles

This repository is used to synchronize configuration files across different platforms.

## Usage

Clone it into the home directory (or another location) and execute the `setup.py` script

```bash
git clone git@github.com:/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

python ./setup.py
```

The `setup.py` script creates symbolic links to configuration files stored in this repository, ensuring consistency across platforms.

Additionally, `setup.py` provides a `--check` option to verify the availability of commonly used tools on the current platform.

The file paths and the check targets are defined in `config.json`, which can be modified as needed.

> **Note:** On Windows, administrator privileges are required while creating symbolic links.

## Home Directory Configurations

The following configuration files are managed in the home directory:

- **Git**: `~/.config/git/config` (not `~/.gitconfig`)
- **(Linux-only)**
  - **Vim**: `~/.vimrc`
  - **Tmux**: `~/.config/tmux/tmux.conf` (not `~/.tmux.conf`)
  - **Fish**: `~/.config/fish/mysetup.d`

These file locations adhere to the modern **XDG Base Directory Specification** if possible.

## Project Root Configurations

The default project root is `~/projectroot/` on Linux and `D:/ProjectRoot/` on Windows. This can be customized in `config.json`.

Configuration files within the project root include:

- `.editorconfig`: Standardizes text formatting settings (encoding, line endings, indentation, etc.).
- `.clang-format`: Defines C++ code formatting rules.
- `.clang-tidy`: Configures static code analysis for `clangd`.

## Shell Configurations

Since shell environments differ across platforms, full synchronization of shell configurations is impractical.

A **common initialization mechanism** is implemented via the `init.py` script, similar to `conda init`. This script injects a small, auto-generated initialization snippet into the shell's configuration file.

To initialize bash/fish/pwsh, run:

```bash
./init.py bash

# or
./init.py fish

# or (Windows)
./init.py pwsh
```

For **Bash**, `init.py` appends the following snippet to `~/.bashrc`:

```bash
# [START] my dotfiles init
# Auto-generated block for my dotfiles, do not edit

if [ -f "/home/$USER/.dotfiles/bash/init_bash.sh" ]; then
    source "/home/$USER/.dotfiles/bash/init_bash.sh"
fi

# [END] my dotfiles init
```

The `init_bash.sh` script then iterates through the `bash/func` directory and executes all Bash scripts found.

For **Fish**, the snippet is written to `~/.config/fish/config.fish`, following the same logic.

For **PowerShell**, determining the configuration file path is more complex. The script spawns a PowerShell process to run `echo $PROFILE`, retrieves the correct path, and appends the initialization snippet accordingly.
