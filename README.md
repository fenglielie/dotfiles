# Dotfiles

个人使用的配置文件汇总，包括：

- Vim：[~/.vimrc](./.vimrc)
- Tmux：[~/.tmux.conf](.tmux.conf)（不支持 Windows）
- Git: [~/.gitconfig](./.gitconfig) （需要补全姓名和邮箱）
- clang：
  - [.clang-format](./.clang-format)
  - [.clang-tidy](./.clang-tidy)
- editorconfig: [.editorconfig](./.editorconfig)

直接复制到对应位置即可使用。

注意：

- Git 配置文件也支持 XDG 规范，存放在 `~/.config/git/config`
- Tmux （高版本）配置文件也支持 XDG 规范，存放在 `~/.config/tmux/tmux.conf`


## Shell Configuration

对于几种 shell（bash/fish/pwsh），还有对应的具体配置。

### bash

在 `~/.bashrc` 中添加以下内容：

`ls` 和 `rm` 相关的别名
```bash
alias ll='ls -lFh'
alias lla='ls -AlFh'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
```

有 `exa` 的情况下配置 `exa` 的选项
```bash
if command -v exa >/dev/null 2>&1; then
    alias exa='exa --group-directories-first --ignore-glob=".git|node_modules|__pycache__" --icons'
fi
```

自定义函数以简化 Tmux 的使用
```bash
tm() {
    # Check for help options
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: tm [SESSION_NAME]"
        echo
        echo "Examples:"
        echo "  tm            - Smart attach or create session logic:"
        echo "                   (1) No session -> create 'main' session"
        echo "                   (2) One session -> attach to it"
        echo "                   (3) Multiple sessions -> list them"
        echo "  tm ls         - List all tmux sessions."
        echo "  tm list       - Same as above."
        echo "  tm my_session - Attach to or create 'my_session' tmux session."
        return 0
    fi

    local session_name="$1"

    if [[ -z "$session_name" ]]; then
        local session_count
        session_count=$(tmux ls 2>/dev/null | wc -l)

        if [[ "$session_count" -eq 0 ]]; then
            echo "No tmux sessions found. Creating and attaching to session 'main'..."
            tmux new-session -s main
        elif [[ "$session_count" -eq 1 ]]; then
            local only_session
            only_session=$(tmux ls | awk -F: '{print $1}')
            echo "Attaching to the only session '$only_session'..."
            tmux attach-session -t "$only_session"
        else
            echo "Multiple tmux sessions found:"
            tmux ls
        fi
        return
    fi

    if [[ "$session_name" == "list" || "$session_name" == "ls" ]]; then
        tmux ls
        return
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Attaching to existing session '$session_name'..."
        tmux attach-session -t "$session_name"
    else
        echo "No session '$session_name' found. Creating a new session..."
        tmux new-session -s "$session_name"
    fi
}
```

### fish

在 `~/.config/fish/config.fish` 中添加以下内容：

关闭 fish 默认的欢迎词
```
function fish_greeting
end
```

`ls` 和 `rm` 相关的别名
```fish
abbr -a ll ls -lFh
abbr -a lla ls -AlFh
abbr -a la ls -A
abbr -a l ls -CF
abbr -a rm rm -i
```

有 `exa` 的情况下配置 `exa` 的选项
```fish
if type -q exa
    alias exa='exa --group-directories-first --ignore-glob=".git|node_modules|__pycache__" --icons'
end
```

设置主题样式
```fish
set -U fish_color_autosuggestion 707A8C
set -U fish_color_cancel \x2dr
set -U fish_color_command 5CCFE6
set -U fish_color_comment 5C6773
set -U fish_color_cwd 87D7FF
set -U fish_color_cwd_root red
set -U fish_color_end F29E74
set -U fish_color_error FF3333
set -U fish_color_escape 95E6CB
set -U fish_color_history_current \x2d\x2dbold
set -U fish_color_host normal
set -U fish_color_host_remote yellow
set -U fish_color_match F28779
set -U fish_color_normal CBCCC6
set -U fish_color_operator FFCC66
set -U fish_color_param CBCCC6
set -U fish_color_quote BAE67E
set -U fish_color_redirection D4BFFF
set -U fish_color_search_match \x2d\x2dbackground\x3dFFCC66
set -U fish_color_selection \x2d\x2dbackground\x3dFFCC66
set -U fish_color_status red
set -U fish_color_user brgreen
set -U fish_color_valid_path \x2d\x2dunderline
```

### pwsh

可以运行 `echo $PROFILE` 获取配置文件的位置，配置文件名称为 `Microsoft.PowerShell_profile.ps1`。

在 `$PROFILE` 中添加以下内容以提供自定义命令，包括 `cd`，`which`，`touch`，`mkdir` 等。
```pwsh
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

    if (-not $command) {
        Write-Error "Command '$CommandName' not found."
        return $null
    }

    switch ($command.CommandType) {
        'Application' {
            return $command.Path -replace '\\', '/'
        }
        'Alias' {
            return "Alias to: $($command.Definition)"
        }
        'Function' {
            return "Function: $CommandName"
        }
        'Cmdlet' {
            return "Cmdlet: $($command.Name)"
        }
        'ExternalScript' {
            return "Script file: $($command.Path -replace '\\', '/')"
        }
        default {
            return "Unsupported command type: $($command.CommandType)"
        }
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
Set-Alias ll Get-ChildItem
Set-Alias ls Get-ChildItem-Normal
Set-Alias l Get-ChildItem-Normal

Set-PSReadLineOption -Colors @{
    String    = "yellow"
    Command   = "blue"
    Parameter = "green"
}

$PSStyle.FileInfo.Directory = "`e[34m"
```

在命令行中使用 vim.exe
```pwsh
function vim {
    & "path\to\vim.exe" @Args
}
```

设置网络代理环境变量
```pwsh
$env:http_proxy = "http://127.0.0.1:7892"
$env:https_proxy = "http://127.0.0.1:7892"
```

基于 oh-my-pwsh 使用自定义主题（`simple.omp.json` 主题文件需要存放在配置文件相同的文件夹中，否则需要修改路径参数）
```pwsh
$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Path
oh-my-posh init pwsh --config "$ScriptDir/simple.omp.json" | Invoke-Expression
```
