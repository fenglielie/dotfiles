import platform
import subprocess
import json
import os
import sys
import logging


# Color codes for terminal output
class Colors:
    GREEN = "\033[92m"  # Green
    RED = "\033[91m"  # Red
    WHITE = "\033[0m"  # Default (White)


# Configure logging
logging.basicConfig(level=logging.DEBUG, format="%(message)s")


def log_info(message, color=Colors.WHITE):
    """Log an info message with color."""
    logging.info(f"{color}{message}{Colors.WHITE}")


def truncate_output(output):
    """Truncate output to keep only the first 3 and last 3 lines if it exceeds 6 lines."""
    lines = output.strip().split("\n")
    if len(lines) > 6:
        return "\n".join(lines[:3] + ["..."] + lines[-3:])
    return output.strip()


def execute_commands(commands):
    """Execute a group of commands sequentially, returning the last command's exit status."""
    group_output = []  # Store output for the current group
    for command in commands:
        group_output.append(f"{Colors.GREEN}Command:{Colors.WHITE} {command}")
        try:
            if platform.system() == "Windows":
                # Use PowerShell to execute the command
                result = subprocess.run(
                    ["pwsh", "-Command", command],
                    capture_output=True,
                    text=True,
                    shell=True,
                    check=True,
                )
            else:
                # Use shell=True for Unix-like systems
                result = subprocess.run(
                    command,
                    capture_output=True,
                    text=True,
                    shell=True,
                    check=True,
                )

            output = truncate_output(result.stdout)

            # Treat empty output as an error
            if not output:
                group_output.append(f"{Colors.RED}Error: No output for command '{command}'{Colors.WHITE}")

                log_info("\n".join(group_output))
                return 1  # Return error status

            group_output.append(f"{Colors.GREEN}Output:{Colors.WHITE}\n{output}")
        except subprocess.CalledProcessError as e:
            group_output.append(f"{Colors.RED}Error: {e.stderr.strip()}{Colors.WHITE}")

            log_info("\n".join(group_output))
            return e.returncode  # Return error status

    log_info("\n".join(group_output))
    return 0  # All commands executed successfully


def read_config(file_path):
    """Read JSON configuration file and return a dictionary of commands."""
    if not os.path.exists(file_path):
        log_info(
            f"{Colors.RED}Configuration file {file_path} does not exist.{Colors.WHITE}"
        )
        sys.exit(1)  # Return error code

    with open(file_path, "r") as f:
        config = json.load(f)
    return config


def print_separator(title=""):
    """Print a centered separator line with a fixed length."""
    total_length = 40  # Set the total length of the separator line

    if len(title) > 0:
        title_length = len(title)
        padding = (
            total_length - 2 - title_length
        )  # Subtract 2 for the surrounding dashes
        left_padding = padding // 2
        right_padding = padding - left_padding  # Ensure total length is maintained

        separator = f"{'-' * left_padding} {title} {'-' * right_padding}"
        log_info(separator)
    else:
        log_info(
            "-" * total_length + "\n"
        )  # Print a matching line of dashes at the end


def main():

    logging.info("dotfiles check started.")

    # Get root dir
    script_root_dir = os.path.dirname(os.path.realpath(__file__))
    logging.info(f"Script root directory: {script_root_dir}")

    # Load configuration from JSON file
    config_file_path = os.path.join(script_root_dir, "check-config.json")
    logging.info(f"Loading configuration from '{config_file_path}'")

    if not os.path.exists(config_file_path):
        logging.error(f"Configuration file '{config_file_path}' not found.")
        return

    commands_config = read_config(config_file_path)

    # Iterate over each software's command group
    results = []
    for software, commands in commands_config.items():
        print_separator(software.upper())

        if execute_commands(commands) != 0:
            results.append(f"- [x] {software}")

        print_separator()

    # Print checkbox-style list of results
    if len(results) == 0:
        log_info("All commands executed successfully!")
    else:
        log_info("Some commands failed:")
        for result in results:
            log_info(f"{Colors.RED}{result}{Colors.WHITE}")


if __name__ == "__main__":
    main()
