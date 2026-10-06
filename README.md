# dotfiles

Neovim, tmux, lazygit, and gh config. The repo mirrors `$HOME`: everything at
the top level gets copied into the directory the repo is cloned into.

## Setup

```sh
git clone https://github.com/CCShoop/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh`:

1. Runs `copy.sh`, which copies `.config/` and `.tmux.conf` into `~`
   (overwriting existing files).
2. Sets up GitHub SSH access if it doesn't work yet: creates
   `~/.ssh/id_ed25519` if there isn't one, prints the public key, copies it to
   the clipboard, opens GitHub's "new SSH key" page (on WSL), and waits until
   you've added it. Then it switches this repo's `origin` from HTTPS to SSH.
3. Runs `apt-get update` (on apt systems).
4. Installs the GitHub CLI (`gh`) from GitHub's apt repo, or downloads the
   newest release to `~/.local/bin/gh` elsewhere. Skipped if `gh` is already
   installed.
5. Installs `python3-venv` (apt) and makes sure a `python3.13` is on PATH for
   Mason, since some of its pypi packages don't support Python 3.14 yet. If the
   distro doesn't provide one, it installs `uv` and uses it to install a
   standalone Python 3.13 into `~/.local/bin`.
6. Installs lazygit from apt if the distro packages it, otherwise downloads the
   newest release to `~/.config/lazygit/lazygit`.
7. Downloads the newest `tree-sitter` CLI to `~/.local/bin/tree-sitter`
   (nvim-treesitter uses it to build parsers).
8. Installs Claude Code with the native installer (`~/.local/bin/claude`).
   Skipped if `claude` is already installed; it auto-updates from then on.
9. Builds and installs Neovim **v0.12.5** from the `neovim` submodule into
   `/usr/local`, installing the build dependencies with apt first if any are
   missing. Skipped if that version is already installed.

`claude`, `tree-sitter` (and gh, lazygit and `python3.13`, when downloaded) are symlinked into `/usr/local/bin`,
which is on PATH by default, so everything works in the same shell right after
the script finishes, with no `.bashrc` changes. On a fresh WSL Ubuntu the only
input it needs is your `sudo` password and adding the SSH key on GitHub.

After changing config in the repo, run `./copy.sh` to copy it into `~`
without the rest of setup.

Re-running `setup.sh` is safe; lazygit, tree-sitter and Neovim are only rebuilt when out of date.

### Build dependencies

On apt systems the script installs these itself. Elsewhere, install the
equivalents of `ninja-build gettext cmake curl build-essential unzip git`
before running it.

### First Neovim launch

Plugins are managed by packer, which clones itself on first start. Then run
`:PackerSync` and restart.

### Claude Code

Run `claude` once to log in. To install it by hand instead:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

`claude doctor` checks the install and `claude update` updates it on demand.

### gh

Only `config.yml` is tracked. `hosts.yml` holds the auth token and is
gitignored, so run `gh auth login` on a new machine.

## Layout

| Path | What |
| --- | --- |
| `.config/nvim/` | Neovim config (`init.lua`, plugins in `lua/shoop/packer.lua`, per-plugin setup in `after/plugin/`) |
| `.config/lazygit/` | lazygit config |
| `.config/gh/` | GitHub CLI config (SSH protocol) |
| `.config/pycodestyle` | pycodestyle settings |
| `.tmux.conf` | tmux config (prefix `C-a`, `M-hjkl` to move between panes) |
| `neovim/` | Neovim source, submodule pinned to v0.12.5 |
| `setup.sh` | Install script |
| `copy.sh` | Copies the config into `~` (run by `setup.sh`) |

## Updating Neovim

Change `NVIM_VERSION` in `setup.sh`, then move the submodule to match:

```sh
git -C neovim fetch --tags && git -C neovim checkout vX.Y.Z
git add neovim setup.sh && git commit -m "Bump neovim to vX.Y.Z"
```
