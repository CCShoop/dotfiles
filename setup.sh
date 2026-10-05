#!/usr/bin/env bash
# Copy the contents of this repo into its parent directory, install lazygit
# (apt if available, else the newest release), install Claude Code, and build
# neovim from the submodule. Tools land in /usr/local/bin, which is already on
# PATH, so they work in the current shell as soon as this finishes.
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

# Run as root only when /usr/local isn't writable
as_root() {
    if [[ -w /usr/local/bin ]]; then "$@"; else sudo "$@"; fi
}

# Symlink a binary into /usr/local/bin so it's on PATH without shell config
link_into_path() {
    local dest="/usr/local/bin/$(basename "$1")"
    as_root ln -sfn "$1" "$dest"
    echo "Linked $dest -> $1"
}

# GitHub SSH key: walk through creating one and adding it to GitHub, then move
# this repo's remote from HTTPS to SSH. Skipped once SSH auth already works.
github_ssh_ok() {
    local out
    out="$(ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com 2>&1 || true)"
    [[ "$out" == *"successfully authenticated"* ]]
}
if github_ssh_ok; then
    echo "GitHub SSH access already works, skipping key setup"
elif [[ ! -t 0 ]]; then
    echo "GitHub SSH access not set up; re-run setup.sh in a terminal to set it up"
else
    ssh_key="$target_dir/.ssh/id_ed25519"
    if [[ ! -f "$ssh_key" ]]; then
        echo "Creating an SSH key for GitHub (a passphrase is optional; Enter skips it)"
        mkdir -p "$(dirname "$ssh_key")" && chmod 700 "$(dirname "$ssh_key")"
        ssh-keygen -t ed25519 -C "$(git config --global user.email || echo "$USER@$(hostname)")" -f "$ssh_key"
    fi
    github_key_url="https://github.com/settings/ssh/new"
    echo
    echo "Add this public key to GitHub at $github_key_url"
    echo
    cat "$ssh_key.pub"
    echo
    # WSL: copy to the Windows clipboard and open the page in the Windows browser
    if command -v clip.exe >/dev/null; then
        clip.exe < "$ssh_key.pub" && echo "(Copied to the clipboard)"
    fi
    if command -v explorer.exe >/dev/null; then
        explorer.exe "$github_key_url" || true
    elif command -v xdg-open >/dev/null; then
        xdg-open "$github_key_url" >/dev/null 2>&1 || true
    fi
    until github_ssh_ok; do
        read -rp "Press Enter once the key is added (or type s to skip): " reply
        [[ "$reply" == s ]] && break
    done
    if github_ssh_ok; then
        echo "GitHub SSH access works"
    else
        echo "Skipped GitHub SSH setup; re-run setup.sh to finish it"
    fi
fi
origin_url="$(git -C "$repo_dir" remote get-url origin 2>/dev/null || true)"
if [[ "$origin_url" == https://github.com/* ]] && github_ssh_ok; then
    ssh_url="git@github.com:${origin_url#https://github.com/}"
    git -C "$repo_dir" remote set-url origin "$ssh_url"
    echo "Switched origin to $ssh_url"
fi

# Fresh images ship with stale or empty package lists
if command -v apt-get >/dev/null; then
    echo "Updating apt package lists"
    sudo apt-get update -qq
fi

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
    link_into_path "$lazygit_bin"
fi

# Claude Code: native installer, which keeps itself up to date afterwards.
# It installs to ~/.local/bin/claude (a symlink it re-points on each update),
# so linking to that path keeps /usr/local/bin/claude current.
claude_bin="$target_dir/.local/bin/claude"
if [[ -x "$claude_bin" ]] || command -v claude >/dev/null; then
    echo "Claude Code already installed, skipping"
else
    echo "Installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
fi
if [[ -e "$claude_bin" ]]; then
    link_into_path "$claude_bin"
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
    if command -v apt-get >/dev/null; then
        echo "Installing neovim build dependencies (missing: ${missing[*]})"
        sudo apt-get install -y ninja-build gettext cmake curl build-essential unzip git
    else
        echo "Missing neovim build dependencies: ${missing[*]}" >&2
        exit 1
    fi
fi

nvim_dir="$repo_dir/neovim"
git -C "$repo_dir" submodule update --init neovim
git -C "$nvim_dir" fetch --tags origin
git -C "$nvim_dir" checkout --quiet "$NVIM_VERSION"

echo "Building neovim $NVIM_VERSION"
make -C "$nvim_dir" CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$NVIM_PREFIX"

as_root make -C "$nvim_dir" install
nvim --version | head -n1
