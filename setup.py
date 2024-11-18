#!/usr/bin/env python3

import platform
import subprocess
import json
import os
import sys
import shutil
import logging
import argparse


LOG_COLORS = {
    "DEBUG": "\033[0m",  # reset
    "INFO": "\033[0m",  # reset
    "WARNING": "\033[33m",  # yellow
    "ERROR": "\033[31m",  # red
}


class ColoredFormatter(logging.Formatter):
    def format(self, record):
        color = LOG_COLORS.get(record.levelname, "\033[0m")
        return f"{color}{super().format(record)}\033[0m"


handler = logging.StreamHandler()
handler.setFormatter(ColoredFormatter("%(message)s"))
logging.getLogger().addHandler(handler)


def path_expand(path):
    path = path.replace("${HOME}", os.path.expanduser("~"))
    return os.path.expandvars(path).replace("\\", "/")


def create_symlink(src, dest):

    if os.path.exists(dest) and not os.path.islink(dest):
        logging.error(
            f"'{dest}' exists and is not a symlink. Please remove it manually."
        )
        return False

    create_symlink_flag = False

    if os.path.exists(dest) and os.path.islink(dest):
        logging.warning(f"'{dest}' (symlink) already exists. Remove it.")
        os.remove(dest)
        create_symlink_flag = True
    else:
        user_input = input(f"Create '{dest}' (symlink) ? (y/n): ").strip().lower()
        create_symlink_flag = user_input == "y"

    if create_symlink_flag:
        try:
            dest_dir = os.path.dirname(dest)
            if not os.path.exists(dest_dir):
                logging.debug(f"'{dest_dir}' (dir) does not exist. Creating it now.")
                os.makedirs(dest_dir)
                logging.debug(f"Create '{dest_dir}' (dir)")

            os.symlink(src, dest, target_is_directory=os.path.isdir(src))
            logging.debug("Create symlink successfully.")
            return True
        except Exception as e:
            logging.error(f"Failed to create symlink '{dest}': {e}")
    else:
        logging.info("Skip.")

    return False


def copy_item(src, dest):
    if os.path.exists(dest):
        logging.error(f"'{dest}' already exists. Please remove it manually.")
        return False

    user_input = input("Copy '{dest}' ? (y/n): ").strip().lower()
    copy_item_flag = user_input == "y"

    if copy_item_flag:
        try:
            dest_dir = os.path.dirname(dest)
            if not os.path.exists(dest_dir):
                logging.debug(f"'{dest_dir}' (dir) does not exist. Creating it now.")
                os.makedirs(dest_dir)
                logging.debug(f"Create '{dest_dir}' (dir)")

            if os.path.isdir(src):
                shutil.copytree(src, dest)
            else:
                shutil.copy2(src, dest)
            logging.debug("Copy successfully.")
            return True
        except Exception as e:
            logging.error(f"Failed to copy item '{dest}': {e}")
    else:
        logging.info("Skip.")

    return False


def exec_check(software, commands, verbose):

    def truncate(output, verbose):
        if not verbose:
            return output.strip().split("\n")[0]  # only show the first line

        lines = output.strip().split("\n")
        if len(lines) > 6:
            return "\n".join(lines[:3] + ["..."] + lines[-3:])
        else:
            return output.strip()

    logging.info(f"\033[32m- {software}\033[0m")  # green

    for command in commands:
        if verbose:
            logging.warning(f"  * {command}")

        try:
            if platform.system() == "Windows":
                result = subprocess.run(
                    ["pwsh", "-Command", command],  # pwsh
                    capture_output=True,
                    text=True,
                    shell=True,
                    check=True,
                )
            else:
                result = subprocess.run(
                    command,
                    capture_output=True,
                    text=True,
                    shell=True,
                    check=True,
                )

            logging.info(truncate(result.stdout, verbose))

            if result.returncode != 0:
                logging.error(f"Command failed with return code {result.returncode}.")
                return result.returncode

            if not result.stdout.strip():
                logging.error("Command output is empty.")
                return 1

        except subprocess.CalledProcessError as e:
            logging.error("Catch a CalledProcessError")
            return e.returncode if e.returncode != 0 else 1

    return 0


def exec_setup(dotfiles_root, dest_prefix, entries, verbose):

    for entry in entries:
        source = path_expand(os.path.join(dotfiles_root, entry["source"]))
        dest = path_expand(os.path.join(dest_prefix, entry["dest"]))
        action = entry.get("action", "symlink")  # Default 'symlink'

        if action == "symlink":
            if create_symlink(source, dest):
                logging.info(f"\033[34m'{dest}'\033[0m --> \033[32m'{source}'\033[0m")
        elif action == "copy":
            if copy_item(source, dest):
                logging.info(f"\033[35m'{dest}'\033[0m >>> \033[32m'{source}'\033[0m")
        else:
            logging.error(f"Unknown action: {action}'.")


def setup(config, verbose):
    system_platform = platform.system().lower()
    logging.debug(f"Detected platform: {system_platform}")

    dotfiles_root = os.path.dirname(os.path.realpath(__file__)).replace("\\", "/")
    logging.debug(f"dotfiles_root = {dotfiles_root}")

    for group in config["setup_groups"]:
        if system_platform not in group["dest_prefix"]:  # skip
            continue

        dest_prefix = path_expand(group["dest_prefix"][system_platform])
        logging.debug(f"dest_prefix = {dest_prefix}")
        exec_setup(dotfiles_root, dest_prefix, group["entries"], verbose)


def check(config, verbose):
    failed_results = []
    for software, commands in config["check_groups"].items():
        if exec_check(software, commands, verbose) != 0:
            failed_results.append(f"- [x] {software}")

    if len(failed_results) == 0:
        logging.info("[Check success]")
    else:
        logging.info("\n[Check failed]")
        for result in failed_results:
            logging.error(result)


def load_config(config_file_path):
    """Read JSON configuration file and return a dictionary of commands."""
    if not os.path.exists(config_file_path):
        logging.error(f"Configuration file {config_file_path} does not exist.")
        sys.exit(1)

    logging.debug(f"Loading configuration from '{config_file_path}'")
    with open(config_file_path, "r") as f:
        config = json.load(f)
    return config


def parse_args():
    parser = argparse.ArgumentParser(
        description="Script to check and execute commands from a config file."
    )
    parser.add_argument("--verbose", action="store_true", help="Enable verbose output")
    parser.add_argument(
        "--config",
        type=str,
        default="config.json",
        help="Path to the configuration file",
    )
    parser.add_argument(
        "--check", action="store_true", help="Perform checks without setting up"
    )
    return parser.parse_args()


def main():
    args = parse_args()

    logging.getLogger().setLevel(logging.DEBUG if args.verbose else logging.INFO)

    config = load_config(args.config)

    if args.check:
        logging.debug("Check mode enabled.")
        check(config, args.verbose)
    else:
        logging.debug("Setup mode enabled.")
        setup(config, args.verbose)


if __name__ == "__main__":
    main()
