#!/usr/bin/env python3

import os
import subprocess
import sys


def update_config_file(file_path, config, start_marker, end_marker, script_template):
    if not os.path.exists(file_path):
        print(f"Error: Configuration file '{file_path}' does not exist.")
        sys.exit(1)

    script_text = (
        script_template.format(
            config=config, start_marker=start_marker, end_marker=end_marker
        ).strip()
        + "\n"
    )

    with open(file_path, "r") as file:
        file_content = file.readlines()

    start_idx = None
    end_idx = None
    for idx, line in enumerate(file_content):
        if start_marker in line:
            start_idx = idx
        if end_marker in line:
            end_idx = idx

    if start_idx is not None and end_idx is not None:
        existing_block = "".join(file_content[start_idx : end_idx + 1])
        if existing_block == script_text:
            print(f"No changes made to {file_path}, the content is already up-to-date.")
            return
        else:
            print(f"FROM:\n{existing_block}\n")
            print(f"TO:\n{script_text}\n")

            file_content = (
                file_content[:start_idx] + [script_text] + file_content[end_idx + 1 :]
            )
            print(f"Updated existing section in {file_path}.")
    else:
        file_content.append(f"\n{script_text}\n")
        print(f"Added new section to {file_path}.")

    with open(file_path, "w") as file:
        file.writelines(file_content)

    print(f"Successfully updated {file_path}.")


def get_pwsh_profile():
    try:
        result = subprocess.run(
            ["pwsh", "-Command", "echo $PROFILE"],
            capture_output=True,
            text=True,
            check=True,
        )
        profile_path = result.stdout.strip()
        normalized_path = os.path.normpath(profile_path)
        return normalized_path

    except FileNotFoundError:
        print("Error: pwsh (PowerShell) is not installed or not in PATH.")
    except subprocess.CalledProcessError as e:
        print(f"Error: Failed to retrieve $PROFILE. Details: {e}")

    return None


def init_bash(config):
    bashrc_path = os.path.expanduser("~/.bashrc")
    start_marker = "# [START] my dotfiles init"
    end_marker = "# [END] my dotfiles init"
    script_template = """{start_marker}
# Auto-generated block for my dotfiles, do not edit
if [ -f "{config}" ]; then
    source "{config}"
fi
{end_marker}
"""
    update_config_file(bashrc_path, config, start_marker, end_marker, script_template)


def init_pwsh(config):
    pwsh_profile_path = get_pwsh_profile()

    if not pwsh_profile_path:
        print("Error: Could not determine the PowerShell profile path.")
        return

    start_marker = "# [START] my dotfiles init"
    end_marker = "# [END] my dotfiles init"
    script_template = """{start_marker}
# Auto-generated block for my dotfiles, do not edit
if (Test-Path "{config}") {{
    . "{config}"
}}
{end_marker}
"""
    update_config_file(
        pwsh_profile_path, config, start_marker, end_marker, script_template
    )


def init_fish(config):
    fish_config_path = os.path.expanduser("~/.config/fish/config.fish")
    start_marker = "# [START] my dotfiles init"
    end_marker = "# [END] my dotfiles init"
    script_template = """{start_marker}
# Auto-generated block for my dotfiles, do not edit
if test -f "{config}"
    source "{config}"
end
{end_marker}
"""
    update_config_file(
        fish_config_path, config, start_marker, end_marker, script_template
    )


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: init.py <bash|pwsh|fish>")
        sys.exit(1)

    action = sys.argv[1].lower()
    dotfiles_root = os.path.dirname(os.path.realpath(__file__)).replace("\\", "/")

    if action == "bash":
        bash_source_file = os.path.join(dotfiles_root, "bash/init_bash.sh").replace(
            "\\", "/"
        )
        init_bash(bash_source_file)
    elif action == "pwsh":
        pwsh_source_file = os.path.join(dotfiles_root, "pwsh/init_pwsh.ps1").replace(
            "\\", "/"
        )
        init_pwsh(pwsh_source_file)
    elif action == "fish":
        fish_source_file = os.path.join(dotfiles_root, "fish/init_fish.fish").replace(
            "\\", "/"
        )
        init_fish(fish_source_file)
    else:
        print("Invalid option. Use 'bash', 'pwsh', or 'fish'.")
        sys.exit(1)
