#!/usr/bin/env bash
# Copy the contents of this repo (.config/, .tmux.conf, ...) into its parent
# directory, overwriting existing files. setup.sh runs this first; run it on its
# own to apply config changes without the rest of setup.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="$(dirname "$repo_dir")"

shopt -s dotglob nullglob
for item in "$repo_dir"/*; do
    name="$(basename "$item")"
    case "$name" in
        .git | .gitignore | .gitmodules | README.md | neovim | setup.sh | copy.sh) continue ;;
    esac
    echo "Copying $name -> $target_dir/"
    cp -a "$item" "$target_dir/"
done
