# echo "call alias"

abbr -a ll ls -lFh
abbr -a lla ls -AlFh
abbr -a la ls -A
abbr -a l ls -CF
abbr -a rm rm -i

if type -q exa
    alias exa='exa --group-directories-first --ignore-glob=".git|node_modules|__pycache__" --icons'
end
