#!/usr/bin/env python3

import platform
import subprocess
import json
import os
import sys
import logging
import argparse


LOG_COLORS = {
    "DEBUG": "\033[0m",  # 白色
    "INFO": "\033[0m",  # 白色
    "WARNING": "\033[33m",  # 黄色
    "ERROR": "\033[31m",  # 红色
    "CRITICAL": "\033[41m",  # 白色背景红色字体
}


class ColoredFormatter(logging.Formatter):
    def format(self, record):
        color = LOG_COLORS.get(record.levelname, "\033[0m")
        return f"{color}{super().format(record)}\033[0m"


# 配置日志
handler = logging.StreamHandler()
handler.setFormatter(ColoredFormatter("%(message)s"))
logger = logging.getLogger()
logger.addHandler(handler)


def truncate_output(output, verbose):
    if not verbose:
        return output.strip().split("\n")[0]  # Only show the first line

    lines = output.strip().split("\n")
    if len(lines) > 6:
        return "\n".join(lines[:3] + ["..."] + lines[-3:])
    else:
        return output.strip()


def execute_commands(software, commands, verbose):
    logger.info(f"\033[32m- {software}\033[0m")

    for command in commands:
        if verbose:
            logger.warning(f"  * {command}")

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

            output = truncate_output(result.stdout, verbose)
            logger.info(output)

        except subprocess.CalledProcessError as e:
            logger.error("Catch a CalledProcessError")
            return e.returncode

    return 0


def read_config(file_path):
    """Read JSON configuration file and return a dictionary of commands."""
    if not os.path.exists(file_path):
        logging.error(f"Configuration file {file_path} does not exist.")
        sys.exit(1)

    with open(file_path, "r") as f:
        config = json.load(f)
    return config


def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description="Script to check and execute commands from a config file."
    )
    parser.add_argument("--verbose", action="store_true", help="Enable verbose output")
    parser.add_argument(
        "--config",
        type=str,
        default="check-config.json",
        help="Path to the configuration file",
    )
    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    else:
        logging.getLogger().setLevel(logging.INFO)

    logging.debug("dotfiles check started.")

    script_root_dir = os.path.dirname(os.path.realpath(__file__))
    logging.debug(f"Script root directory: {script_root_dir}")

    config_file_path = args.config
    logging.debug(f"Loading configuration from '{config_file_path}'")
    commands_config = read_config(config_file_path)

    failed_results = []
    for software, commands in commands_config.items():
        if execute_commands(software, commands, args.verbose) != 0:
            failed_results.append(f"- [x] {software}")

    if len(failed_results) == 0:
        logging.info("Ok!")
    else:
        logging.error("\nFailed:")
        for result in failed_results:
            logging.error(result)


if __name__ == "__main__":
    main()
