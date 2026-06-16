#!/usr/bin/env bash

set -euo pipefail

echo "Applying macOS settings..."

###############################################################################
# General UI
###############################################################################

# Dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' ||
  echo "Skipping dark mode because System Events was not available."

# Graphite / neutral accent
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool false
defaults write NSGlobalDomain AppleAccentColor -int -1

# Disable press-and-hold for keys, useful for coding
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable automatic text corrections
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

###############################################################################
# Trackpad / Mouse
###############################################################################

# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Reverse scroll direction
# false = traditional scrolling
# true = natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Faster tracking
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.0

###############################################################################
# Dock
###############################################################################

# Auto-hide Dock
defaults write com.apple.dock autohide -bool true

# Make Dock smaller
defaults write com.apple.dock tilesize -int 42

# Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Faster Dock animation
defaults write com.apple.dock autohide-time-modifier -float 0.25

# Don’t show recent apps
defaults write com.apple.dock show-recents -bool false

# Minimize windows into app icon
defaults write com.apple.dock minimize-to-application -bool true

# Remove all pinned/default Dock apps
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

###############################################################################
# Menu bar
###############################################################################

# Automatically hide and show the menu bar.
defaults write NSGlobalDomain _HIHideMenuBar -bool true

###############################################################################
# Mission Control / Spaces
###############################################################################

# Don’t automatically rearrange Spaces based on recent use
defaults write com.apple.dock mru-spaces -bool false

# Don’t group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool false

# Keep separate Spaces per display
# Better if you use an external monitor.
defaults write com.apple.spaces spans-displays -bool false

###############################################################################
# Hot Corners
###############################################################################

# Disable all hot corners
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1

defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Finder
###############################################################################

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show ~/Library
chflags nohidden ~/Library

###############################################################################
# Desktop
###############################################################################

# Hide all desktop icons/files
defaults write com.apple.finder CreateDesktop -bool false

###############################################################################
# Screenshots
###############################################################################

mkdir -p "$HOME/Pictures/Screenshots"

# Save screenshots to Pictures/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# Use PNG screenshots
defaults write com.apple.screencapture type -string "png"

# Disable screenshot shadow
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Activity Monitor
###############################################################################

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Terminal
###############################################################################

# Use UTF-8 only
defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# Restart affected apps
###############################################################################

echo "Restarting affected apps..."

killall Dock || true
killall Finder || true
killall SystemUIServer || true
killall cfprefsd || true

echo "macOS config applied. Some settings may require logout/restart."
