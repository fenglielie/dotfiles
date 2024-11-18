set script_dir (dirname (status --current-filename | realpath))

for script in $script_dir/func/*.sh
    if test -f $script
        # echo "source $script"
        source $script
    end
end
