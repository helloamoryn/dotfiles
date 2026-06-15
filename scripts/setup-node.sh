#!/usr/bin/env bash

set -euo pipefail

echo "Setting up Node.js with fnm..."

if ! command -v fnm >/dev/null 2>&1; then
  echo "fnm is not installed. Run brew bundle first."
  exit 1
fi

eval "$(fnm env --use-on-cd)"

fnm install --lts
fnm use --lts
fnm default lts-latest

corepack enable
corepack prepare pnpm@latest --activate

echo "Node: $(node -v)"
echo "npm:  $(npm -v)"
echo "pnpm: $(pnpm -v)"

echo "Node.js setup complete."
