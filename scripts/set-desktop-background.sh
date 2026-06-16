#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

BACKGROUND_PATH="$PWD/assets/background/amoryn-background.png"

if [[ ! -f "$BACKGROUND_PATH" ]]; then
  echo "Background image not found: $BACKGROUND_PATH"
  exit 1
fi

if ! command -v osascript >/dev/null 2>&1; then
  echo "osascript is required to set the macOS desktop background."
  exit 1
fi

echo "Setting macOS desktop background..."
osascript <<APPLESCRIPT
tell application "System Events"
  set picture of every desktop to "$BACKGROUND_PATH"
end tell
APPLESCRIPT

echo "macOS desktop background updated."
