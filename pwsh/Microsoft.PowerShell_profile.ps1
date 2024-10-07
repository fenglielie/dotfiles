##################################################################
# oh-my-posh scheme
$pwsh_module_dir = ($env:PSModulePath -split ';')[0]
oh-my-posh init pwsh --config "$pwsh_module_dir/simple_pwsh_utils/simple.omp.json" | Invoke-Expression


##################################################################
# simple_pwsh_utils
Import-Module simple_pwsh_utils
Set-Alias -Name cd -Value Set-SimpleCd -Force -Option "AllScope"

# https://github.com/vors/ZLocation
Import-Module ZLocation
