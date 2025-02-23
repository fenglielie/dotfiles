# dotfiles

这是个人使用的，用于同步各个平台的各种配置文件的仓库。

## 使用方法

在使用时只需将当前仓库下载到本地，例如放在家目录下并命名为`.dotfiles`，然后执行`setup.py`脚本
```bash
git clone git@github.com:fenglielie/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

python ./setup.py
```

`setup.py`脚本的主要工作是在配置文件位置建立指向仓库中的已有配置文件的软链接，便于在全平台统一相关的配置文件，具体的路径信息从`config.json`中获取，可以进行修改。

为了便于使用，还给`setup.py`加上了检查参数`--check`，可以快速查看当前平台是否具有常用的工具，具体检查条目从`config.json`中获取，可以进行修改。

> 在Windows平台需要注意：建立软链接需要开启管理员权限，`setup.py`脚本需要管理员权限才能成功执行。

## 家目录配置

在用户家目录下的配置文件包括：

- git 配置文件 `~/.config/git/config`（注意不是`~/.gitconfig`）
- Linux only
  - vim 配置文件 `~/.vimrc`
  - tmux 配置文件 `~/.config/tmux/tmux.conf`（注意不是`~/.tmux.conf`）
  - fish 配置文件 `~/.config/fish/mysetup.d`

这里的配置文件位置尽可能符合现代的XDG规范。

## 项目根目录配置

> 项目根目录在Linux平台下默认为`~/projectroot/`，在Windows平台下默认为`D:/ProjectRoot/`，可以通过修改`config.json`手动设置为其它目录。

在项目根目录下的配置文件包括：

- `.editorconfig`: 用于规范文本的格式细节，包括编码，回车以及tab等
- `.clang-format`: 用于C++代码格式化
- `.clang-tidy`: 用于clangd的静态代码分析


## shell配置

针对不同的shell（bash，fish，pwsh），考虑到不同平台的实际差异，完全同步整个配置文件是不合实际的，因此选择将适合同步的公共部分抽取出来，模仿`conda init`的机制，提供`init.py`脚本对shell进行初始化，在shell的配置文件中添加固定的启动片段。

```bash
./init.py bash
# or
./init.py fish
# or (windows)
./init.py pwsh
```

以bash为例，`init.py`脚本会在`~/.bashrc`中添加如下片段
```bash
# [START] my dotfiles init
# Auto-generated block for my dotfiles, do not edit
if [ -f "/home/fenglielie/.dotfiles/bash/init_bash.sh" ]; then
    source "/home/fenglielie/.dotfiles/bash/init_bash.sh"
fi
# [END] my dotfiles init
```

`init_bash.sh`的实际内容则是遍历`bash/func`子目录，执行其中的所有bash脚本。

对于fish，片段写入的配置文件为`~/.config/fish/config.fish`，具体逻辑同bash。

对于pwsh则比较复杂，因为无法直接确定配置文件的路径，在`init.py`中通过开启一个pwsh进程执行`echo $PROFILE`命令的方式来获取配置文件的完整路径，其它逻辑同bash。
