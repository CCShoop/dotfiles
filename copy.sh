#!/usr/bin/env bash
# Copy the contents of this repo (.config/, .tmux.conf, ...) into its parent
# directory, overwriting existing files. .bashrc is appended to ~/.bashrc
# instead, inside marker lines that are replaced on each run. setup.sh runs this
# first; run it on its own to apply config changes without the rest of setup.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="$(dirname "$repo_dir")"

shopt -s dotglob nullglob
for item in "$repo_dir"/*; do
    name="$(basename "$item")"
    case "$name" in
        .git | .gitignore | .gitmodules | README.md | neovim | setup.sh | copy.sh | .bashrc) continue ;;
    esac
    echo "Copying $name -> $target_dir/"
    cp -a "$item" "$target_dir/"
done

# Append .bashrc between markers, replacing the block a previous run added
bashrc="$target_dir/.bashrc"
bashrc_begin="# >>> dotfiles .bashrc >>>"
bashrc_end="# <<< dotfiles .bashrc <<<"
touch "$bashrc"
sed -i "/^$bashrc_begin\$/,/^$bashrc_end\$/d" "$bashrc"
{
    echo "$bashrc_begin"
    cat "$repo_dir/.bashrc"
    echo "$bashrc_end"
} >> "$bashrc"
echo "Appended .bashrc -> $bashrc"
