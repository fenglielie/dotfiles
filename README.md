# dotfiles

这是个人使用的用于同步各个平台的各种配置文件的仓库，
使用时只需将当前仓库下载到本地家目录下并命名为`.dotfiles/`，然后执行`setup.py`脚本
```bash
cd ~
git clone git@github.com:fenglielie/dotfiles.git .dotfiles
cd .dotfiles
python setup.py
```

`setup.py`脚本的主要工作是在配置文件位置建立指向仓库中的已有配置文件的软链接，
便于在全平台统一相关的配置文件，具体的路径信息从`config.json`中获取。

> 由于在Windows下建立软链接需要开启管理员权限，`setup.py`脚本需要管理员权限才能成功执行。


在用户家目录下的配置文件包括：

- vim 配置文件 `~/.vimrc`
- latexmk 配置文件 `~/.latexmkrc`
- git 配置文件 `~/.config/git/config`（注意不是`~/.gitconfig`）
- tmux 配置文件 `~/.config/tmux/tmux.conf`（Linux only）（注意不是`~/.tmux.conf`）
- fish 配置文件 `~/.config/fish/mysetup.d`（Linux only）

这里的配置文件位置尽可能符合XDG规范。

在项目根目录下的配置文件包括：

- `.editorconfig`: 用于规范编码，回车以及tab的文本细节
- `.clang-format`: 用于格式化C++代码
- `.clang-tidy`: 用于clangd的静态代码分析

> 项目根目录在Linux平台下默认为`~/projectroot/`，在Windows平台下默认为`D:/ProjectRoot/`，可以通过修改`config.json`手动设置为其它目录。


除此之外，在Windows平台上还包括PowerShell的相关配置：

- `simple_pwsh_utils/`
  - `simple_pwsh_utils.psm1`：一个自定义的pwsh模块，对一些常用命令进行了封装
  - `simple.omp.json`：一个自定义的pwsh主题（基于`oh-my-posh`定制的主题）
- `Microsoft.PowerShell_profile.ps1`：pwsh启动脚本

> 在`setup.py`脚本中，PowerShell相关配置的目标路径为环境变量`$env:PSModulePath`的第一项。
