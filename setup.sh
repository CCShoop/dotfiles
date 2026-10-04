#!/usr/bin/env bash
# Copy the contents of this repo into its parent directory, install lazygit
# (apt if available, else the newest release onto the PATH), and build neovim
# from the submodule.
# Clone the repo into a folder in $HOME (e.g. ~/dotfiles) and run it there.
set -euo pipefail

NVIM_VERSION="v0.12.5"
NVIM_PREFIX="/usr/local"

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_dir="$(dirname "$repo_dir")"
script_name="$(basename "${BASH_SOURCE[0]}")"

shopt -s dotglob nullglob
for item in "$repo_dir"/*; do
    name="$(basename "$item")"
    case "$name" in
        .git | .gitignore | .gitmodules | README.md | neovim | "$script_name") continue ;;
    esac
    echo "Copying $name -> $target_dir/"
    cp -a "$item" "$target_dir/"
done

# Lazygit: from apt if the distro packages it, otherwise the newest release
if command -v apt-cache >/dev/null && [[ -n "$(apt-cache policy lazygit 2>/dev/null | awk '/Candidate:/ && $2 != "(none)"')" ]]; then
    echo "Installing lazygit from apt"
    sudo apt-get install -y lazygit
else
    lazygit_latest_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/jesseduffield/lazygit/releases/latest)"
    LAZYGIT_VERSION="${lazygit_latest_url##*/v}"
    lazygit_bin="$target_dir/.config/lazygit/lazygit"
    if [[ -x "$lazygit_bin" ]] && "$lazygit_bin" --version | grep -q "version=$LAZYGIT_VERSION,"; then
        echo "Lazygit $LAZYGIT_VERSION already installed, skipping"
    else
        case "$(uname -m)" in
            x86_64) lazygit_arch="x86_64" ;;
            aarch64 | arm64) lazygit_arch="arm64" ;;
            *) echo "Unsupported architecture for lazygit: $(uname -m)" >&2; exit 1 ;;
        esac
        lazygit_url="https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_${lazygit_arch}.tar.gz"
        echo "Downloading lazygit $LAZYGIT_VERSION"
        mkdir -p "$(dirname "$lazygit_bin")"
        curl -fsSL "$lazygit_url" | tar -xz -C "$(dirname "$lazygit_bin")" lazygit
        chmod +x "$lazygit_bin"
    fi
    link_path="$target_dir/.local/bin/lazygit"
    mkdir -p "$(dirname "$link_path")"
    ln -sfn "$lazygit_bin" "$link_path"
    echo "Linked $link_path -> $lazygit_bin"
    case ":$PATH:" in
        *":$target_dir/.local/bin:"*) ;;
        *) echo "Note: $target_dir/.local/bin is not on PATH; log out and back in (or add it in ~/.bashrc)" ;;
    esac
fi

# Neovim
if command -v nvim >/dev/null && [[ "$(nvim --version | head -n1)" == "NVIM $NVIM_VERSION" ]]; then
    echo "Neovim $NVIM_VERSION already installed, skipping build"
    exit 0
fi

missing=()
for dep in git make cmake gcc gettext curl unzip ninja; do
    command -v "$dep" >/dev/null || missing+=("$dep")
done
if (( ${#missing[@]} )); then
    echo "Missing neovim build dependencies: ${missing[*]}" >&2
    echo "On Debian/Ubuntu: sudo apt-get install ninja-build gettext cmake curl build-essential unzip" >&2
    exit 1
fi

nvim_dir="$repo_dir/neovim"
git -C "$repo_dir" submodule update --init neovim
git -C "$nvim_dir" fetch --tags origin
git -C "$nvim_dir" checkout --quiet "$NVIM_VERSION"

echo "Building neovim $NVIM_VERSION"
make -C "$nvim_dir" CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$NVIM_PREFIX"

if [[ -w "$NVIM_PREFIX/bin" ]]; then
    make -C "$nvim_dir" install
else
    sudo make -C "$nvim_dir" install
fi
nvim --version | head -n1
