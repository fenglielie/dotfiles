#!/usr/bin/env python3

import os
import json
import platform

# ANSI color codes
RESET = "\033[0m"
INFO_COLOR = "\033[94m"
ERROR_COLOR = "\033[91m"


def print_info(message):
    print(f"{INFO_COLOR}[INFO]{RESET} {message}")


def print_error(message):
    print(f"{ERROR_COLOR}[ERROR]{RESET} {message}")


def create_symlink(src, dest):
    if os.path.exists(dest):
        print_error(
            f"File or directory '{dest}' already exists. Please remove it and try again."
        )
    else:
        # print_info(f"Preparing to create symlink from '{src}' to '{dest}'.")
        user_input = input("Do you want to proceed? (y/n): ").strip().lower()
        if user_input == "y":
            try:
                if os.path.isdir(src):
                    os.symlink(src, dest, target_is_directory=True)
                else:
                    os.symlink(src, dest)
                print_info("Symlink created successfully.")
            except Exception as e:
                print_error(f"Failed to create symlink': {e}")
        else:
            print_info("Operation skipped by user.")


def expand_path(path):
    path = path.replace("@HOME", os.path.expanduser("~"))

    ps_module_path = os.environ.get("PSModulePath", "")
    if ps_module_path:
        ps_home = ps_module_path.split(";")[0]
        path = path.replace("@PSHOME", ps_home)

    path = os.path.expandvars(path)
    path = path.replace("\\", "/")

    return path


def handle_config(script_root_dir, destination_root, entries):
    for entry in entries:
        src = expand_path(os.path.join(script_root_dir, entry["source"]))
        dest = expand_path(os.path.join(destination_root, entry["destination"]))

        dest_dir = os.path.dirname(dest)
        print_info(f"Source: '{src}'")
        print_info(f"Dest:   '{dest}'")
        if not os.path.exists(dest_dir):
            print_info(f"Directory '{dest_dir}' does not exist. Creating it now.")
            os.makedirs(dest_dir)
            print_info(f"Created directory: {dest_dir}")

        create_symlink(src, dest)


def main():
    print_info("dotfiles setup started.")

    # Get root dir
    script_root_dir = os.path.dirname(os.path.realpath(__file__))
    print_info(f"Script root directory: {script_root_dir}")

    # Load configuration from JSON file
    config_file_path = os.path.join(script_root_dir, "config.json")
    print_info(f"Loading configuration from '{config_file_path}'")

    if not os.path.exists(config_file_path):
        print_error(f"Configuration file '{config_file_path}' not found.")
        return

    with open(config_file_path, "r") as config_file:
        config = json.load(config_file)

    system_platform = platform.system().lower()
    print_info(f"Detected platform: {system_platform}")

    for group in config["groups"]:
        if system_platform in group["destination_root"]:
            destination_root = expand_path(group["destination_root"][system_platform])
            print_info(f"Processing group with destination root: {destination_root}")
            handle_config(script_root_dir, destination_root, group["entries"])
        else:
            print_info(f"Skipping group due to unsupported platform: {system_platform}")

    print_info("dotfiles setup completed.")


if __name__ == "__main__":
    main()
