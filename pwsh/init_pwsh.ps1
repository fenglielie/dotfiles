$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

$ScriptFiles = Get-ChildItem -Path "$ScriptDir/func" -Filter "*.ps1" -File

foreach ($Script in $ScriptFiles) {
    # Write-Host "Sourcing $($Script.FullName)"
    . $Script.FullName
}
