# Amoryn Dotfiles

<p align="center">
  <img src="./assets/avatar/amoryn-profile-rounded.png" width="120" alt="Amoryn avatar" />
</p>

<p align="center">
  macOS dotfiles for a focused black, red, and white developer setup.
</p>

This repository contains Amoryn's personal macOS configuration for the shell, terminal, window manager, prompt, Node.js tooling, and agent workflow. Dotfiles are managed with GNU Stow and bootstrapped through a single setup script.

## Stack

- Homebrew for packages and apps
- zsh for the shell
- Ghostty for the terminal
- Starship for the prompt
- AeroSpace for window management
- JankyBorders for focused window borders
- tmux for terminal multiplexing
- fnm and Corepack for Node.js tooling
- Raycast as a compact launcher
- Codex for agent workflows

Neovim/LazyVim is planned, but not configured yet.

## Setup

Clone the repository, then run the setup script:

```sh
git clone <repo-url> ~/Code/dotfiles
cd ~/Code/dotfiles
./setup.sh
```

`setup.sh` installs or checks system prerequisites, runs `brew bundle`, creates config directories, stows dotfiles into `$HOME`, sets up Node.js, starts user services, and applies macOS defaults.

Edit configs in this repository, then rerun `./setup.sh` or restow the relevant package. Do not edit generated symlinks directly in `$HOME` or `~/.config`.

## Structure

- `setup.sh` is the main bootstrap entry point.
- `Brewfile` defines Homebrew packages, casks, and taps.
- `zsh/`, `git/`, `tmux/`, `ghostty/`, `starship/`, and `aerospace/` are Stow packages.
- `macos/` contains macOS defaults.
- `scripts/` contains focused setup helpers.
- `assets/` stores profile and desktop images used by setup helpers.

## tmux

- Prefix: `Ctrl-Space`
- Reload config: `Ctrl-Space r`
- New window: `Ctrl-Space c`
- Split panes: `Ctrl-Space |` and `Ctrl-Space -`
- Move between panes: `Ctrl-Space h/j/k/l`
- Resize panes: `Ctrl-Space H/J/K/L`

## AeroSpace

- Open Ghostty: `Alt-Enter`
- Focus windows: `Alt-h/j/k/l`
- Move windows: `Alt-Shift-h/j/k/l`
- Toggle fullscreen: `Alt-f`
- Switch workspace: `Alt-1` through `Alt-9`
- Move window to workspace: `Alt-Shift-1` through `Alt-Shift-9`
- Enter service mode: `Alt-Shift-;`

In service mode, `r` reloads config, `f` flattens the workspace tree, `Space` toggles floating/tiling, and `Esc` exits.
