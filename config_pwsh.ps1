# get root dir
$script_root_dir = Split-Path -Parent -Path (Resolve-Path $MyInvocation.MyCommand.Definition)

# get pwsh module dir
$pwsh_module_dir = ($env:PSModulePath -split ';')[0]

# pwsh module
$pwsh_module_target = "$pwsh_module_dir/simple_pwsh_utils"
if (Test-Path -Path $pwsh_module_target) {
    Write-Host "Error: Directory '$pwsh_module_target' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $pwsh_module_target -Target "$script_root_dir/pwsh/simple_pwsh_utils" -Force
    Write-Host "pwsh module config finished."
}

# pwsh profile
$pwsh_profile_target = "$pwsh_module_dir/../Microsoft.PowerShell_profile.ps1"
if (Test-Path -Path $pwsh_profile_target) {
    Write-Host "Error: File '$pwsh_profile_target' already exists. Please remove it or choose another location."
} else {
    New-Item -ItemType SymbolicLink -Path $pwsh_profile_target -Target "$script_root_dir/pwsh/Microsoft.PowerShell_profile.ps1" -Force
    Write-Host "pwsh profile config finished."
}
