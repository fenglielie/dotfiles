##################################################################
# cd ...

function Set-MyCd {
    param
    (
        $Path = $null, # 要更改到的目标目录路径，默认为空
        $LiteralPath = $null, # 要更改到的目标目录的字面路径，默认为空
        $PassThru, # 如果指定此参数，函数将返回更改后的目标目录的路径
        $StackName, # 未使用的参数
        $UseTransaction       # 未使用的参数
    )

    # 如果没有提供任何参数，返回到指定目录
    if (-not $Path -and -not $LiteralPath) {
        Set-Location -Path $env:UserProfile # 无参数时返回默认路径
        return
    }

    # 使用 Set-Location 命令来更改当前工作目录
    $newPath = Set-Location @PSBoundParameters

    if ($PassThru) {
        return $newPath
    }
}

##################################################################
# which

function Get-MyWhich {
    param (
        [string]$CommandName
    )

    $command = Get-Command $CommandName -ErrorAction SilentlyContinue

    if ($command) {
        return $command.Path -replace '\\', '/'  # 返回路径
    } else {
        Write-Error "Command '$CommandName' not found."  # 输出错误信息
        return $null  # 返回 null
    }
}

##################################################################
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

##################################################################
# mkdir

function New-MyMkdir {
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [string]$directoryPath
    )

    if (-not (Test-Path -Path $directoryPath -PathType Container)) {
        New-Item -Path $directoryPath -ItemType Directory | Out-Null
    } else {
        Write-Host "Dir '$directoryPath' already exist" -ForegroundColor Red
    }
}

##################################################################


# 判断别名是否已经存在，如果存在则不替换，这个工具函数不导出
function Add-MyAliasIfNoExists {
    param (
        [string]$AliasName,
        [string]$AliasToName
    )

    # 判断命令是否可执行
    if (Get-Command $AliasName -ErrorAction SilentlyContinue) {
        # Write-Host "'$AliasName' exists"

        # 判断别名是否已经存在
        if (Test-Path Alias:\$AliasName) {
            # 移除别名
            Remove-Item Alias:\$AliasName
            # Write-Host "Alias '$AliasName' has been removed."
        }
    }
    else {
        # 不可执行时添加别名并重写
        # Write-Host "'$AliasName' does not exist, add an alias."
        Set-Alias -Name $AliasName -Value $AliasToName -Scope Global

    }
}

function Get-MyPwd {
    (Get-Location).ToString()
}

function Get-MyPath{
    $env:PATH -split ';'
}

##################################################################

# 这些命令如果不存在，则通过powershell函数伪装实现

Add-MyAliasIfNoExists which Get-MyWhich
Add-MyAliasIfNoExists touch New-MyTouch

# 别名
Set-Alias -Name cd -Value Set-MyCd -Force -Option "AllScope"
Set-Alias -Name pwd -Value Get-MyPwd
Set-Alias -Name mkdir -Value New-MyMkdir
Set-Alias -Name path -Value Get-MyPath

##################################################################

Set-PSReadLineOption -Colors @{
    String               = "yellow"
    Command              = "blue"
    Parameter            = "green"
}
