# Amoryn's Dotfiles

macOS dotfiles for Amoryn's shell, terminal, window manager, tmux, Node.js tooling, and Codex setup. Configs are managed with GNU Stow from this repository.

## Setup

From the repo root:

```sh
./setup.sh
```

The setup script installs or checks Xcode Command Line Tools, Homebrew packages from `Brewfile`, creates common config directories, stows dotfiles into `$HOME`, sets up Node.js through `fnm`, starts user services, and applies macOS defaults.

During interactive setup, it can also set the macOS user picture from `assets/avatar/amoryn-profile.png`. To run that step directly:

```sh
./scripts/set-user-picture.sh
```

Edit configs in this repo, then rerun `./setup.sh` or restow the relevant package. Do not edit the generated symlinks directly in `$HOME` or `~/.config`.

## Current Stack

- Homebrew for packages and apps
- zsh for the shell
- Ghostty for the terminal
- Starship for the prompt
- AeroSpace for window management
- tmux for terminal multiplexing
- fnm and Corepack for Node.js tooling
- Codex for agent workflows

Neovim/LazyVim is planned, but not set up yet.

## tmux Basics

- Prefix: `Ctrl-Space`
- Reload config: `Ctrl-Space r`
- New window: `Ctrl-Space c`
- Horizontal split: `Ctrl-Space |`
- Vertical split: `Ctrl-Space -`
- Move between panes: `Ctrl-Space h/j/k/l`
- Resize panes: `Ctrl-Space H/J/K/L`

To reload manually:

```sh
tmux source-file ~/.tmux.conf
```

## AeroSpace Basics

- Open Ghostty: `Alt-Enter`
- Focus windows: `Alt-h/j/k/l`
- Move windows: `Alt-Shift-h/j/k/l`
- Toggle fullscreen: `Alt-f`
- Switch workspace: `Alt-1` through `Alt-9`
- Move window to workspace: `Alt-Shift-1` through `Alt-Shift-9`
- Enter service mode: `Alt-Shift-;`
- In service mode: `r` reloads config, `f` flattens the workspace tree, `Space` toggles floating/tiling, and `Esc` exits.
