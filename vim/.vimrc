" ============================================
" .vimrc
" fenglielie@qq.com
" ============================================

" Disable Vi compatibility mode
set nocompatible

" set number                    " Show line numbers
" set relativenumber            " Show relative line numbers

set autoread                    " Reload file if modified externally (if no conflicts)
set confirm                     " Prompt when handling unsaved or read-only files
set title                       " Change window title
syntax on                       " Enable syntax highlighting
set showmatch                   " Highlight matching parentheses
set matchtime=2                 " Match highlight duration (200ms)
set ruler                       " Show line and column numbers
set showcmd                     " Show typed commands
set showmode                    " Display current mode

" Indentation and tab settings
set tabstop=4                   " Tab width (4 spaces)
set softtabstop=4               " Soft tab width when editing
set shiftwidth=4                " Indent width for auto-indents
set expandtab                   " Use spaces instead of tabs
set shiftround                  " Round indentation to nearest shiftwidth
set smarttab                    " Adjust tabs intelligently based on context
set autoindent                  " Enable automatic indentation
set copyindent                  " Copy indentation from previous lines
set preserveindent              " Preserve original indentation
set cindent                     " Enable C-style indentation

" Disable error sounds and visuals
set noerrorbells                " Disable error sounds
set novisualbell                " Disable visual bell (screen flash)
set vb t_vb=                    " Clear terminal bell codes

" Search settings
set ignorecase                  " Ignore case during search
set smartcase                   " Case-sensitive if search includes uppercase letters

" Line ending support
set fileformats=unix,dos,mac    " Support Unix (LF), Windows (CRLF), and macOS (CR) line endings

" Encoding settings
set encoding=utf-8              " Set file encoding to UTF-8
set termencoding=utf-8          " Set terminal encoding to UTF-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312  " Recognize multiple file encodings

" ========= command =========

" Visualize tabs, trailing spaces and end-of-line characters
function! ToggleViz()
    if &list
        set nolist
        echo "invisible characters visualization OFF"
    else
        if &fileformat ==# 'dos'
            set listchars=tab:→\ ,trail:·,nbsp:␣,eol:↵
        elseif &fileformat ==# 'mac'
            set listchars=tab:→\ ,trail:·,nbsp:␣,eol:←
        else
            set listchars=tab:→\ ,trail:·,nbsp:␣,eol:↓
        endif
        set list
        echo "invisible characters visualization ON"
    endif
endfunction

command! Viz call ToggleViz()

" Clean trailing whitespace
function! CleanWhitespace()
    %s/\s\+$//e
endfunction

command! TrimWS call CleanWhitespace()

" Check the file's encoding and newline format
function! CheckFileEncodingAndEOL()
    let file_encoding = &fileencoding
    if file_encoding !=# 'utf-8'
        echo "Warning: File is encoded as " . file_encoding . ", not UTF-8."
    endif

    let file_format = &fileformat
    if file_format !=# 'unix'
        echo "Warning: File uses " . file_format . " line endings, not unix (LF)."
    endif
endfunction

augroup FileCheck
    autocmd!
    autocmd BufReadPost * call CheckFileEncodingAndEOL()
augroup END

" ========= statusline =========

" Always show the status line
set laststatus=2

" Customize the status line content
set statusline=
set statusline+=\ %F%m%r%h%w\ %=
set statusline+=\ %p%%\ %l:%v
set statusline+=\ %([%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",bomb\":\"\")}%k\|%Y]%)
