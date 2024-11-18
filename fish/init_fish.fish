set script_dir (realpath (dirname (status --current-filename)))

for script in $script_dir/func/*.fish
    if test -f $script
        # echo "source $script"
        source $script
    end
end
