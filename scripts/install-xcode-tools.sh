#!/usr/bin/env bash

set -euo pipefail

echo "Checking Xcode Command Line Tools..."

if ! command -v xcode-select >/dev/null 2>&1; then
  echo "xcode-select was not found. This script only runs on macOS."
  exit 1
fi

if xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools already installed: $(xcode-select -p)"
  exit 0
fi

echo "Xcode Command Line Tools not found. Starting Apple installer..."
xcode-select --install

echo "Waiting for Xcode Command Line Tools installation to complete..."
echo "Finish the installer window that just opened."

until xcode-select -p >/dev/null 2>&1; do
  sleep 20
done

echo "Xcode Command Line Tools installed: $(xcode-select -p)"
