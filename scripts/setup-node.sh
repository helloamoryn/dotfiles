#!/usr/bin/env bash

set -euo pipefail

NODE_MAJOR_VERSION="24"

echo "Setting up Node.js $NODE_MAJOR_VERSION with fnm..."

if ! command -v fnm >/dev/null 2>&1; then
  echo "fnm is not installed. Run brew bundle first."
  exit 1
fi

if ! command -v corepack >/dev/null 2>&1; then
  echo "corepack is not installed. Run brew bundle first."
  exit 1
fi

# Make fnm available in this non-interactive script.
eval "$(fnm env --use-on-cd --shell bash)"

# Install Node only if this major version is missing.
if fnm list | grep -qE "v?${NODE_MAJOR_VERSION}\."; then
  echo "Node.js $NODE_MAJOR_VERSION is already installed."
else
  echo "Installing Node.js $NODE_MAJOR_VERSION..."
  fnm install "$NODE_MAJOR_VERSION"
fi

# Use Node 24 in the current script.
fnm use "$NODE_MAJOR_VERSION"

# Set Node 24 as the default version.
fnm default "$NODE_MAJOR_VERSION"

# Enable Corepack shims for pnpm/yarn.
corepack enable

# Activate pnpm through Corepack.
corepack prepare pnpm@latest --activate

echo "Node:     $(node -v)"
echo "npm:      $(npm -v)"
echo "Corepack: $(corepack --version)"
echo "pnpm:     $(pnpm -v)"

echo "Node.js setup complete."
