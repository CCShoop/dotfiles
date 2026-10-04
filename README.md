# dotfiles

Neovim, tmux, lazygit, and gh config. The repo mirrors `$HOME`: everything at
the top level gets copied into the directory the repo is cloned into.

## Setup

```sh
git clone git@github.com:CCShoop/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh`:

1. Copies `.config/` and `.tmux.conf` into `~` (overwriting existing files).
2. Downloads the newest lazygit release to `~/.config/lazygit/lazygit` and
   links it into `~/.local/bin`.
3. Builds and installs Neovim **v0.12.5** from the `neovim` submodule into
   `/usr/local` (uses `sudo` if needed). Skipped if that version is already
   installed.

Re-running it is safe; lazygit and Neovim are only rebuilt when out of date.

### Build dependencies

On Debian/Ubuntu:

```sh
sudo apt-get install ninja-build gettext cmake curl build-essential unzip
```

### First Neovim launch

Plugins are managed by packer, which clones itself on first start. Then run
`:PackerSync` and restart.

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

## Updating Neovim

Change `NVIM_VERSION` in `setup.sh`, then move the submodule to match:

```sh
git -C neovim fetch --tags && git -C neovim checkout vX.Y.Z
git add neovim setup.sh && git commit -m "Bump neovim to vX.Y.Z"
```
