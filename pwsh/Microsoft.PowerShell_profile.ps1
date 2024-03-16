##################################################################
# oh-my-posh scheme
oh-my-posh init pwsh --config "E:\lishu\Documents\PowerShell\Modules\mzcy_pwsh_utils\mzcy_simple.omp.json" | Invoke-Expression


##################################################################
# mzcy_pwsh_utils
Import-Module mzcy_pwsh_utils
Set-Alias -Name cd -Value Set-MzcyCd -Force -Option "AllScope"
