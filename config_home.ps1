# get root dir
$script_root_dir = Split-Path -Parent -Path (Resolve-Path $MyInvocation.MyCommand.Definition)

# tmux
$tmux_config = "$HOME/.tmux.conf"
if (Test-Path -Path $tmux_config) {
    Write-Host "Error: File '$tmux_config' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $tmux_config -Target "$script_root_dir/tmux/.tmux.conf" -Force
    Write-Host "tmux config finished."
}

# vim
$vim_config = "$HOME/.vimrc"
if (Test-Path -Path $vim_config) {
    Write-Host "Error: File '$vim_config' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $vim_config -Target "$script_root_dir/vim/.vimrc" -Force
    Write-Host "vim config finished."
}

# git
$git_config = "$HOME/.gitconfig"
if (Test-Path -Path $git_config) {
    Write-Host "Error: File '$git_config' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $git_config -Target "$script_root_dir/git/.gitconfig" -Force
    Write-Host "git config finished."
}
