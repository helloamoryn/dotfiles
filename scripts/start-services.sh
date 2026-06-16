#!/usr/bin/env bash

set -euo pipefail

echo "Starting user services..."

###############################################################################
# AeroSpace
###############################################################################

# AeroSpace manages windows and should be available immediately after install.
# Opening it is best-effort so a launch failure does not break the bootstrap.
if [[ -d /Applications/AeroSpace.app ]]; then
  echo "Starting AeroSpace..."
  open -a AeroSpace || echo "Skipping AeroSpace because it could not be opened."
else
  echo "Skipping AeroSpace because /Applications/AeroSpace.app was not found."
fi

###############################################################################
# Raycast
###############################################################################

# Raycast is used as a compact launcher.
# Set Cmd-Space and compact appearance manually in Raycast settings.
if [[ -d /Applications/Raycast.app ]]; then
  echo "Starting Raycast..."
  open -a Raycast || echo "Skipping Raycast because it could not be opened."
else
  echo "Skipping Raycast because /Applications/Raycast.app was not found."
fi

echo "User services started."
