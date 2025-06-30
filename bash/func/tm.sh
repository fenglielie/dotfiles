# tm(): simply the usage of tmux in bash

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
