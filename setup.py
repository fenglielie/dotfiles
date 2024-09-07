#!/usr/bin/env python3

import os
import json
import platform
import logging
import shutil

# Configure logging to output to the console
logging.basicConfig(level=logging.INFO, format="[%(levelname)s] %(message)s")


def create_symlink(src, dest):
    if os.path.exists(dest):
        logging.error(
            f"File or directory '{dest}' already exists. Please remove it and try again."
        )
    else:
        user_input = (
            input("Do you want to proceed with symlink? (y/n): ").strip().lower()
        )
        if user_input == "y":
            try:
                if os.path.isdir(src):
                    os.symlink(src, dest, target_is_directory=True)
                else:
                    os.symlink(src, dest)
                logging.info("Symlink created successfully.")
            except Exception as e:
                logging.error(f"Failed to create symlink: {e}")
        else:
            logging.info("Operation skipped by user.")


def copy_item(src, dest):
    if os.path.exists(dest):
        logging.error(
            f"File or directory '{dest}' already exists. Please remove it and try again."
        )
    else:
        user_input = input("Do you want to proceed with copy? (y/n): ").strip().lower()
        if user_input == "y":
            try:
                if os.path.isdir(src):
                    shutil.copytree(src, dest)
                else:
                    shutil.copy2(src, dest)
                logging.info("Copied successfully.")
            except Exception as e:
                logging.error(f"Failed to copy item: {e}")
        else:
            logging.info("Operation skipped by user.")


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
        action = entry.get("action", "symlink")  # Default action is 'symlink'

        logging.info(f"Source: '{src}'")
        logging.info(f"Dest:   '{dest}'")
        logging.info(f"Action: '{action}'")

        # Check if destination directory exists, create if it doesn't
        dest_dir = os.path.dirname(dest)
        if not os.path.exists(dest_dir):
            logging.info(f"Directory '{dest_dir}' does not exist. Creating it now.")
            os.makedirs(dest_dir)
            logging.info(f"Created directory: {dest_dir}")

        # Perform the specified action (symlink or copy)
        if action == "symlink":
            create_symlink(src, dest)
        elif action == "copy":
            copy_item(src, dest)
        else:
            logging.error(f"Unknown action '{action}' specified for '{src}'.")


def main():
    logging.info("dotfiles setup started.")

    # Get root dir
    script_root_dir = os.path.dirname(os.path.realpath(__file__))
    logging.info(f"Script root directory: {script_root_dir}")

    # Load configuration from JSON file
    config_file_path = os.path.join(script_root_dir, "config.json")
    logging.info(f"Loading configuration from '{config_file_path}'")

    if not os.path.exists(config_file_path):
        logging.error(f"Configuration file '{config_file_path}' not found.")
        return

    with open(config_file_path, "r") as config_file:
        config = json.load(config_file)

    system_platform = platform.system().lower()
    logging.info(f"Detected platform: {system_platform}")

    for group in config["groups"]:
        if system_platform in group["destination_root"]:
            destination_root = expand_path(group["destination_root"][system_platform])
            logging.info(f"Processing group with destination root: {destination_root}")
            handle_config(script_root_dir, destination_root, group["entries"])
        else:
            logging.info(
                f"Skipping group due to unsupported platform: {system_platform}"
            )

    logging.info("dotfiles setup completed.")


if __name__ == "__main__":
    main()
