#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

for script in "$SCRIPT_DIR"/func/*.sh; do
    if [ -f "$script" ]; then
        # echo "source $script"
        source "$script"
    fi
done
