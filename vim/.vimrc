" ============================================
" .vimrc
" 2024年10月9日
" ============================================

" 关闭 Vi 兼容模式
set nocompatible

set autoread                    " 文件被其他编辑器修改时发出提示
set confirm                     " 处理未保存或只读文件时弹出确认
set title                       " 改变窗口标题
syntax on                       " 启用语法高亮
set number                      " 显示行号

" jk 映射为 ESC
inoremap jk <Esc>

" 不同模式使用不同的光标
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" 进入插入模式时高亮当前行，退出插入模式则自动关闭
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

" 缩进和制表符设置
set tabstop=4                   " 设置 Tab 字符宽度为 4 个空格
set softtabstop=4               " 插入时使用 4 个空格宽度
set shiftwidth=4                " 自动缩进的宽度为 4 个空格
set expandtab                   " 插入 Tab 时使用空格替代
set shiftround                  " 自动缩进保持整数倍
set smarttab                    " 根据上下文智能决定使用 Tab 或空格

" 智能缩进和复制缩进
set autoindent                  " 自动缩进新行
set copyindent                  " 复制缩进
set preserveindent              " 保持当前缩进
set cindent                     " C 语言文件的缩进规则

" 错误提示设置
set noerrorbells                " 关闭错误音
set novisualbell                " 关闭错误音可视化（屏幕闪烁）
set vb t_vb=                    " 置空错误铃声的终端代码

" 换行符和编码设置
set fileformats=unix,dos,mac    " 优先使用 LF 换行符，其次使用 CRLF
" 当文件中使用 CRLF 换行符时，显示 CRLF 换行符为 ↵
autocmd BufReadPost * if &fileformat == 'dos' | set listchars+=eol:↵ | endif


set encoding=utf-8              " 设置文件编码为 UTF-8
set termencoding=utf-8          " 终端编码设置
" 支持多种文件编码
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312

" 显示不可见字符
set list                        " 显示不可见字符
set listchars=tab:▷\ ,trail:·   " 设置显示 Tab 和尾随空格样式

" 状态栏设置
set laststatus=2     " 始终显示状态栏
" 定制状态栏具体内容
set statusline=
set statusline+=\ %F%m%r%h%w\ %=
set statusline+=\ %({%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%k\|%Y}%)
set statusline+=\ %([%l,%v][%p%%]\ %)

" 搜索设置
set ignorecase      " 搜索时忽略大小写
set smartcase       " 智能忽略大小写（若输入含大写，则不会忽略大小写）
" set hlsearch        " 高亮搜索结果

" 光标禁止时高亮消失
autocmd CursorHold * set nohlsearch
" 当输入查找命令时，再启用高亮
noremap n :set hlsearch<cr>n
noremap N :set hlsearch<cr>N
noremap / :set hlsearch<cr>/
noremap ? :set hlsearch<cr>?
noremap * *:set hlsearch<cr>

" 显示当前行列数、输入命令和当前模式
set ruler           " 显示行列数
set showcmd         " 显示输入的命令
set showmode        " 显示当前模式
set showmatch       " 括号匹配显示
set matchtime=2     " 匹配时间为 200 毫秒

" 打开非 UTF-8 编码文件时提示
function! CheckFileEncodingUTF8()
    let file_encoding = &fileencoding
    if file_encoding !=# 'utf-8'
        echo "Warning: file is encoded as " . file_encoding . ", not UTF-8."
    endif
endfunction
autocmd BufReadPost * call CheckFileEncodingUTF8()

" 保存时自动移除行尾空格
autocmd BufWritePre * %s/\s\+$//e

" 立即生效对vim配置文件的更改
autocmd BufWritePost $MYVIMRC source $MYVIMRC
