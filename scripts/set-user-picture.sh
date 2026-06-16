#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

AVATAR_PATH="assets/avatar/amoryn-profile.png"
INSTALL_DIR="$HOME/Library/Application Support/Amoryn"
INSTALL_PATH="$INSTALL_DIR/profile-picture.jpg"
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

set_user_picture_record() {
  if sudo -n true >/dev/null 2>&1 || [[ -t 0 ]]; then
    sudo dscl . delete "/Users/$TARGET_USER" Picture >/dev/null 2>&1 || true
    sudo dscl . delete "/Users/$TARGET_USER" JPEGPhoto >/dev/null 2>&1 || true
    sudo dscl . create "/Users/$TARGET_USER" Picture "$INSTALL_PATH"
    return
  fi

  if command -v osascript >/dev/null 2>&1; then
    local admin_script
    admin_script="$(mktemp "${TMPDIR:-/tmp}/set-user-picture.XXXXXX.applescript")"
    trap 'rm -f "$admin_script"' RETURN

    cat >"$admin_script" <<'APPLESCRIPT'
on run argv
  set targetUser to item 1 of argv
  set picturePath to item 2 of argv
  set userPath to "/Users/" & targetUser
  set commandText to "/usr/bin/dscl . delete " & quoted form of userPath & " Picture >/dev/null 2>&1 || true; "
  set commandText to commandText & "/usr/bin/dscl . delete " & quoted form of userPath & " JPEGPhoto >/dev/null 2>&1 || true; "
  set commandText to commandText & "/usr/bin/dscl . create " & quoted form of userPath & " Picture " & quoted form of picturePath
  do shell script commandText with administrator privileges
end run
APPLESCRIPT
    osascript "$admin_script" "$TARGET_USER" "$INSTALL_PATH"
    return
  fi

  echo "Administrator privileges are required to update the macOS user picture."
  echo "Run this script from Terminal so sudo can prompt for a password."
  exit 1
}

echo "Preparing profile picture..."
mkdir -p "$INSTALL_DIR"
sips -Z 512 -s format jpeg "$AVATAR_PATH" --out "$INSTALL_PATH" >/dev/null

echo "Setting macOS user picture for $TARGET_USER..."
set_user_picture_record

killall cfprefsd >/dev/null 2>&1 || true

echo "macOS user picture updated."
echo "If System Settings still shows the old picture, log out and back in."
