#!/usr/bin/env bash

set -euo pipefail

echo "Checking Homebrew..."

if command -v brew >/dev/null 2>&1; then
  echo "Homebrew already installed: $(brew --version | head -n 1)"
  exit 0
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "Homebrew found at /opt/homebrew/bin/brew"
  exit 0
fi

if [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
  echo "Homebrew found at /usr/local/bin/brew"
  exit 0
fi

echo "Homebrew not found. Installing Homebrew..."

# Official Homebrew install script.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo "Homebrew installation finished, but brew was not found."
  echo "Open a new terminal and try again."
  exit 1
fi

echo "Homebrew installed: $(brew --version | head -n 1)"
