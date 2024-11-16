# tm(): simply the usage of tmux in bash

tm() {
  # Check for help options
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: tm [SESSION_NAME]"
    echo
    echo "Examples:"
    echo "  tm            - List all tmux sessions."
    echo "  tm my_session - Attach to the 'my_session' tmux session or create it if it doesn't exist."
    return 0
  fi

  # Handle session name
  local session_name="${1:-}"

  if [ -z "$session_name" ]; then
    # List all tmux sessions if no session name is provided
    tmux ls
  else
    # Check if the session exists
    tmux has-session -t "$session_name" 2>/dev/null

    if [ $? != 0 ]; then
      echo "No session '$session_name' found. Creating a new session..."
      # Create a new session if it doesn't exist
      tmux new-session -s "$session_name"
    else
      echo "Attaching to existing session '$session_name'..."
      # Attach to the existing session
      tmux attach-session -t "$session_name"
    fi
  fi
}
