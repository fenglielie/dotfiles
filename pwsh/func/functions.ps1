##################################################################
# cd ...

function Set-SimpleCd {
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

function Get-SimpleWhich {
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

function New-SimpleTouch {
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

function New-SimpleMkdir {
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
# ls

function Get-SimpleLs {
    param (
        [string]$Path = ".",
        [switch]$l,  # Long listing format
        [switch]$a,  # Show all files, including hidden
        [switch]$F   # Append file type indicator
    )

    # 获取指定路径下的文件和文件夹
    $items = Get-ChildItem -Force $Path

    # 处理 -a 选项
    if (-not $a) {
        $items = $items | Where-Object { $_.Name -notlike '.*' }
    }

    # 如果没有文件，直接返回
    if ($items.Count -eq 0) {
        return
    }

    if ($l) {
        $items | Format-Table -AutoSize Mode, Length, LastWriteTime, Name
    } else {
        $output = @()
        $colors = @()
        foreach ($item in $items) {
            $name = $item.Name
            $color = "White"

            # 添加文件类型指示符和颜色
            if ($item.PSIsContainer) {
                $typeIndicator = "/"
                $color = "Blue"  # 目录为蓝色
            } elseif ($item.Attributes -match "Executable") {
                $typeIndicator = "*"
                $color = "Green"  # 可执行文件为绿色
            } elseif ($item.Extension -eq ".lnk") {
                $typeIndicator = "@"
                $color = "Yellow"  # 链接文件为黄色
            }
            else{
                $typeIndicator = ""
                $color = "White"  # 其他文件为白色
            }

            $name = $name + $typeIndicator

            $output += $name
            $colors += $color
        }

        for ($i = 0; $i -lt $output.Count; $i++) {
            $item = $output[$i] + " "
            if (($i + 1) % 4 -eq 0) {
                Write-Host $item -ForegroundColor $colors[$i]
            }
            else{
            Write-Host $item -ForegroundColor $colors[$i] -NoNewline
            }
        }
    }
}


function Get-SimpleLl {
    param (
        [string]$Path = "."
    )
    Get-SimpleLs -Path $Path -a -l -F
}

function Get-SimpleLa {
    param (
        [string]$Path = "."
    )
    Get-SimpleLs -Path $Path -A
}

function Get-SimpleL {
    param (
        [string]$Path = "."
    )
    Get-SimpleLs -Path $Path -F
}

##################################################################
# vi/vim -> notepad in windows

function Open-SimpleNotepad {
    param (
        [string]$FilePath
    )

    # 如果提供了文件路径参数
    if ($FilePath) {
        # 检查文件是否存在
        if (-not (Test-Path $FilePath)) {
            # 文件不存在时，检查提供的参数是否为相对路径
            if (-not [System.IO.Path]::IsPathRooted($FilePath)) {
                # 如果是相对路径，则加上当前位置得到绝对路径
                $FilePath = (Join-Path (Get-Location).Path $FilePath)
            }
            Write-Host "Create new file: $FilePath"

            notepad /q $FilePath
        }
        else {
            # 文件存在
            notepad $FilePath
        }
    }
    else {
        # 如果未提供文件路径参数，则直接打开
        notepad
    }
}

##################################################################


# 判断别名是否已经存在，如果存在则不替换，这个工具函数不导出
function Add-SimpleAliasIfNoExists {
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

function Get-SimplePwd {
    (Get-Location).ToString()
}

function Get-SimplePath{
    $env:PATH -split ';'
}

# 检查路径是否在全局 PATH 中
function Test-SimplePath{
    param (
        [string]$Directory = $PWD.Path
    )
    return $env:PATH -split ';' -contains $Directory
}

function Add-SimpleTempPath{
    param (
        [string]$Directory = $PWD.Path
    )

    # 检查目录是否存在
    if (-not (Test-Path $Directory)) {
        Write-Error "Directory '$Directory' does not exist."
        return
    }

    # 获取当前 PATH 环境变量值
    $currentPath = $env:PATH

    # 检查路径是否已经存在于 PATH 中
    if ($currentPath -split ';' -contains $Directory) {
        Write-Output "Directory '$Directory' is already in PATH."
        return
    }

    # 将路径添加到 PATH 中
    $env:PATH = "$currentPath;$Directory"
    Write-Output "Directory '$Directory' added to PATH temporarily."
}



##################################################################

# 这些命令如果不存在，则通过powershell函数伪装实现
Add-SimpleAliasIfNoExists vi Open-SimpleNotepad
Add-SimpleAliasIfNoExists vim Open-SimpleNotepad
Add-SimpleAliasIfNoExists which Get-SimpleWhich
Add-SimpleAliasIfNoExists touch New-SimpleTouch

# 别名
Set-Alias -Name cd -Value Set-SimpleCd -Force -Option "AllScope"
Set-Alias -Name ls -Value Get-SimpleLs
Set-Alias -Name la -Value Get-SimpleLa
Set-Alias -Name ll -Value Get-SimpleLl
Set-Alias -Name l -Value Get-SimpleL
Set-Alias -Name pwd -Value Get-SimplePwd
Set-Alias -Name mkdir -Value New-SimpleMkdir
Set-Alias -Name path -Value Get-SimplePath
Set-Alias -Name pathcheck -Value Test-SimplePath
Set-Alias -Name pathadd -Value Add-SimpleTempPath

##################################################################

Set-PSReadLineOption -Colors @{
    String               = "yellow"
    Command              = "blue"
    Parameter            = "green"
}
# PSReadLineOption的颜色只影响输入时的当前行渲染，不会影响输出，输出的颜色受到terminal主题的影响
# PSReadLineOption的设置：
# 如果使用文字，则具体颜色基于terminal的主题；
# 如果直接使用RGB，则不受terminal主题的影响

Set-Alias -Name cd -Value Set-SimpleCd -Force -Option "AllScope"
