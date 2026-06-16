#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

echo "Starting dotfiles installation..."

###############################################################################
# Helpers
###############################################################################

backup_if_regular_file() {
  local target="$1"

  if [[ -f "$target" && ! -L "$target" ]]; then
    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up $target to $backup"
    mv "$target" "$backup"
  fi
}

load_homebrew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    echo "Homebrew was not found."
    exit 1
  fi
}

run_if_exists() {
  local script="$1"

  if [[ -x "$script" ]]; then
    "$script"
  else
    echo "Skipping $script because it does not exist or is not executable."
  fi
}

confirm_and_run_user_picture_setup() {
  local script="./scripts/set-user-picture.sh"

  if [[ ! -x "$script" ]]; then
    echo "Skipping user picture setup because $script does not exist or is not executable."
    return
  fi

  if [[ ! -t 0 ]]; then
    echo "Skipping user picture setup because this shell is non-interactive."
    return
  fi

  echo ""
  read -r -p "Set macOS user picture from assets/avatar/amoryn-profile.png? [y/N] " reply

  case "$reply" in
    [Yy] | [Yy][Ee][Ss])
      "$script"
      ;;
    *)
      echo "Skipping user picture setup."
      ;;
  esac
}

stow_if_exists() {
  local package="$1"

  if [[ -d "$package" ]]; then
    echo "Stowing $package..."
    stow --dir="$PWD" --target="$HOME" --restow "$package"
  else
    echo "Skipping $package because directory does not exist."
  fi
}

###############################################################################
# Xcode Command Line Tools
###############################################################################

echo "Checking Xcode Command Line Tools..."
run_if_exists "./scripts/install-xcode-tools.sh"

###############################################################################
# Homebrew
###############################################################################

echo "Checking Homebrew..."
run_if_exists "./scripts/install-homebrew.sh"

# Important:
# scripts/install-homebrew.sh runs in a child process.
# So we must load Homebrew again inside this install.sh process.
load_homebrew

echo "Homebrew loaded: $(brew --version | head -n 1)"

###############################################################################
# Homebrew trust
###############################################################################

# AeroSpace is distributed through a third-party Homebrew tap.
# Trust only the specific AeroSpace cask, not the whole tap.
brew tap nikitabobko/tap
brew trust --cask nikitabobko/tap/aerospace || true

###############################################################################
# Homebrew packages
###############################################################################

echo "Installing Homebrew packages from Brewfile..."
brew bundle

###############################################################################
# Directories
###############################################################################

echo "Creating config directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/bin"

###############################################################################
# Backup existing config files before stow
###############################################################################

backup_if_regular_file "$HOME/.zshrc"
backup_if_regular_file "$HOME/.zprofile"
backup_if_regular_file "$HOME/.hushlogin"
backup_if_regular_file "$HOME/.tmux.conf"

###############################################################################
# Stow dotfiles
###############################################################################

echo "Stowing dotfiles..."

stow_if_exists "zsh"
stow_if_exists "git"
stow_if_exists "starship"
stow_if_exists "ghostty"
stow_if_exists "aerospace"
stow_if_exists "tmux"

###############################################################################
# Node.js
###############################################################################

echo "Setting up Node.js..."
run_if_exists "./scripts/setup-node.sh"

###############################################################################
# User services
###############################################################################

echo "Starting user services..."
run_if_exists "./scripts/start-services.sh"

###############################################################################
# macOS defaults
###############################################################################

echo ""
echo "Applying macOS defaults..."
run_if_exists "./macos/setup-macos.sh"

###############################################################################
# User picture
###############################################################################

confirm_and_run_user_picture_setup

###############################################################################
# Done
###############################################################################

echo ""
echo "Dotfiles installation complete."
echo "Open a new terminal window so zsh, Homebrew, fnm, Starship, and other shell changes reload cleanly."
