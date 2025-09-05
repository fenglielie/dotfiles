# echo "call alias"

alias ll='ls -lFh'
alias lla='ls -AlFh'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'

if command -v exa >/dev/null 2>&1; then
    alias exa='exa --group-directories-first --ignore-glob=".git|node_modules|__pycache__" --icons'
fi
