# Dotfiles

This repository is used to synchronize configurations across different platforms.

## Usage

Clone the repository into your home directory (or another location), and execute `setup.py`.
```bash
git clone git@github.com:fenglielie/dotfiles.git ~/.config/dotfiles

cd ~/.config/dotfiles

python ./setup.py
```

`setup.py` script creates symbolic links to configuration files stored in this repository, ensuring consistency across platforms.

For example, a symbolic link `~/.vimrc` will be created pointing to `[path/to/dotfiles]/vim/.vimrc`.
If `~/.vimrc` already exists and is not a symbolic link, the script will skip it and report an error.

> ⚠️ On Windows, administrator privileges are required to create symbolic links.

## Setup links

- **Git**: `~/.config/git/config`
- **Vim**: `~/.vimrc`
- **Tmux**: `~/.config/tmux/tmux.conf` (Linux-only)


## Check tools

`setup.py` also provides a `--check` option to verify the availability of commonly used tools on the current platform, such as `git`, `fish`, and `tmux`.

```bash
python setup.py --check
```

The check targets are defined in `config.json`, and this file can be customized as needed.

## Shell init

Due to differences between shell environments on various platforms, it is not practical to fully synchronize shell configurations.

A **common initialization mechanism** is implemented through the `init.py` script, similar to `conda init`. This script injects a small automatically generated initialization code snippet into the shell's configuration file.

To initialize Bash, Fish, or PowerShell, run the following:
```bash
./init.py bash

./init.py fish

# Powershell (Windows-only)
./init.py pwsh
```

For example, `init.py` adds the following snippet to `~/.bashrc`:
```bash
# [START] my dotfiles init
# Auto-generated block for my dotfiles, do not edit

if [ -f "[path/to/dotfiles]/bash/init_bash.sh" ]; then
    source "[path/to/dotfiles]/bash/init_bash.sh"
fi

# [END] my dotfiles init
```

The `init_bash.sh` script executes all bash scripts found in `[path/to/dotfiles]/bash/func/`

For Fish, the snippet is added to `~/.config/fish/config.fish`.
For PowerShell, the script launches a PowerShell process, runs `echo $PROFILE` to locate the profile path, and then appends the initialization snippet.
