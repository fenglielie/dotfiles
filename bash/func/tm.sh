# tm(): simply the usage of tmux in bash

tm() {
    # Check for help options
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: tm [SESSION_NAME]"
        echo
        echo "Examples:"
        echo "  tm            - List all tmux sessions."
        echo "  tm ls         - Same as above."
        echo "  tm list       - Same as above."
        echo "  tm my_session - Attach to or create 'my_session' tmux session."
        return 0
    fi

    local session_name="$1"

    if [[ -z "$session_name" || "$session_name" == "list" || "$session_name" == "ls" ]]; then
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
