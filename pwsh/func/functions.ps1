# cd
function Set-MyCd {
    param ([string]$TargetPath)

    if (-not $TargetPath) {
        $TargetPath = $env:UserProfile
    }

    Set-Location -Path $TargetPath
}


# which
function Get-MyWhich {
    param (
        [string]$CommandName
    )

    $command = Get-Command $CommandName -ErrorAction SilentlyContinue

    if ($command) {
        return $command.Path -replace '\\', '/'
    }
    else {
        Write-Error "Command '$CommandName' not found."
        return $null
    }
}

# touch
function New-MyTouch {
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [string]$FilePath
    )

    if (Test-Path $FilePath) {
        $now = Get-Date
        Set-ItemProperty -Path $FilePath -Name LastAccessTime -Value $now
        Set-ItemProperty -Path $FilePath -Name LastWriteTime -Value $now
    }
    else {
        New-Item -Path $FilePath -ItemType File | Out-Null
    }
}

# mkdir
function New-MyMkdir {
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [string]$directoryPath
    )

    if (-not (Test-Path -Path $directoryPath -PathType Container)) {
        New-Item -Path $directoryPath -ItemType Directory | Out-Null
    }
    else {
        Write-Host "Dir '$directoryPath' already exist" -ForegroundColor Red
    }
}

function Add-MyAliasIfNoExists {
    param (
        [string]$AliasName,
        [string]$AliasToName
    )

    # check if the alias already exists
    if (Get-Command $AliasName -ErrorAction SilentlyContinue) {
        # remove the alias if it exists
        if (Test-Path Alias:\$AliasName) {
            Remove-Item Alias:\$AliasName
        }
    }
    else {
        Set-Alias -Name $AliasName -Value $AliasToName -Scope Global

    }
}

function Get-MyPwd {
    (Get-Location).ToString()
}

function Get-MyPath {
    $env:PATH -split ';'
}

function Get-ChildItem-Normal {
    Get-ChildItem @args | Where-Object { -not $_.Name.StartsWith('.') }
}

##################################################################

# Add aliases if not exists
Add-MyAliasIfNoExists which Get-MyWhich
Add-MyAliasIfNoExists touch New-MyTouch

# Add aliases
Set-Alias -Name cd -Value Set-MyCd -Force -Option "AllScope"
Set-Alias -Name pwd -Value Get-MyPwd
Set-Alias -Name mkdir -Value New-MyMkdir
Set-Alias -Name path -Value Get-MyPath
Set-Alias ll Get-ChildItem
Set-Alias ls Get-ChildItem-Normal
Set-Alias l Get-ChildItem-Normal

Set-PSReadLineOption -Colors @{
    String    = "yellow"
    Command   = "blue"
    Parameter = "green"
}

$PSStyle.FileInfo.Directory = "`e[34m"
