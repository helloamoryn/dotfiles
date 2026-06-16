#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

AVATAR_PATH="assets/avatar/amoryn-profile.png"
TARGET_USER="${USER:?USER is not set}"

if [[ ! -f "$AVATAR_PATH" ]]; then
  echo "Avatar image not found: $AVATAR_PATH"
  exit 1
fi

if ! command -v sips >/dev/null 2>&1; then
  echo "sips is required to convert the avatar image."
  exit 1
fi

if ! command -v dscl >/dev/null 2>&1; then
  echo "dscl is required to set the macOS user picture."
  exit 1
fi

if ! command -v xxd >/dev/null 2>&1; then
  echo "xxd is required to encode the avatar image."
  exit 1
fi

TMP_JPEG="$(mktemp "${TMPDIR:-/tmp}/amoryn-profile.XXXXXX.jpg")"
trap 'rm -f "$TMP_JPEG"' EXIT

echo "Preparing profile picture..."
sips -Z 512 -s format jpeg "$AVATAR_PATH" --out "$TMP_JPEG" >/dev/null

echo "Setting macOS user picture for $TARGET_USER..."
sudo dscl . delete "/Users/$TARGET_USER" Picture >/dev/null 2>&1 || true
sudo dscl . delete "/Users/$TARGET_USER" JPEGPhoto >/dev/null 2>&1 || true
sudo dscl . create "/Users/$TARGET_USER" JPEGPhoto "$(xxd -p "$TMP_JPEG" | tr -d '\n')"

echo "macOS user picture updated."
