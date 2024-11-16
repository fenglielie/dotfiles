#!/usr/bin/env python3

import os


def init_bash(config):
    bashrc_path = os.path.expanduser("~/.bashrc")

    # 检查 ~/.bashrc 是否存在
    if not os.path.exists(bashrc_path):
        print(f"Error: {bashrc_path} does not exist.")
        return

    # 标记文本
    start_marker = "# [START] my dotfiles init"
    end_marker = "# [END] my dotfiles init"
    script_text = f"""{start_marker}
# Auto-generated block for my dotfiles, do not edit
if [ -f "{config}" ]; then
    source "{config}"
fi
{end_marker}
"""

    # 读取当前 .bashrc 文件内容
    with open(bashrc_path, "r") as file:
        bashrc_content = file.readlines()

    # 查找标记所在行
    start_idx = None
    end_idx = None
    for idx, line in enumerate(bashrc_content):
        if start_marker in line:
            start_idx = idx
        if end_marker in line:
            end_idx = idx

    if start_idx is not None and end_idx is not None:
        # 如果找到首尾标记，替换掉中间的部分
        bashrc_content = (
            bashrc_content[: start_idx]
            + [script_text]
            + bashrc_content[end_idx + 1:]
        )

        print("Updated existing section in .bashrc.")
    else:
        # 如果没有找到标记，添加新的内容
        bashrc_content.append(f"\n{script_text.strip()}\n")

        print("Added new section to .bashrc.")

    # 将更新后的内容写回 .bashrc
    with open(bashrc_path, "w") as file:
        file.writelines(bashrc_content)

    print(f"Successfully updated {bashrc_path}.")


if __name__ == "__main__":
    dotfiles_root = os.path.dirname(os.path.realpath(__file__))
    source_file = os.path.join(dotfiles_root, "bash/init_bash.sh")
    init_bash(source_file)
