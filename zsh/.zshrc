# ~/.zshrc
#
# This file is loaded every time an interactive zsh shell starts.
# Keep it fast, readable, and focused on daily terminal workflow.

###############################################################################
# Homebrew
###############################################################################

# Load Homebrew into the shell.
# Apple Silicon Macs usually use /opt/homebrew.
# Intel Macs usually use /usr/local.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

###############################################################################
# Environment
###############################################################################

# Use Neovim as the default editor for terminal programs.
# Example: git commit will open nvim.
export EDITOR="nvim"
export VISUAL="nvim"

# Use less to scroll through long output.
# Example: git log, man pages, long command outputs.
export PAGER="less"

# Use UTF-8 so icons, accents, and symbols render correctly.
export LANG="en_US.UTF-8"

# Add personal script directories to PATH.
# This lets you run executables from ~/.local/bin and ~/bin directly.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

###############################################################################
# History
###############################################################################

# Store zsh command history in this file.
HISTFILE="$HOME/.zsh_history"

# Number of history entries kept in memory and saved to disk.
HISTSIZE=10000
SAVEHIST=10000

# Do not save duplicate commands typed one after another.
setopt HIST_IGNORE_DUPS

# Do not save commands that start with a space.
# Useful for one-off commands containing secrets/tokens.
setopt HIST_IGNORE_SPACE

# Remove unnecessary extra spaces before saving commands to history.
setopt HIST_REDUCE_BLANKS

# Share history between multiple terminal tabs/windows.
setopt SHARE_HISTORY

# Save commands to the history file immediately instead of waiting for shell exit.
setopt INC_APPEND_HISTORY

###############################################################################
# Shell behavior
###############################################################################

# Allow entering a directory by typing its path without "cd".
# Example: typing ~/Code acts like cd ~/Code.
setopt AUTO_CD

# Keep a directory stack when changing directories.
# Useful with dirs, pushd, and popd.
setopt AUTO_PUSHD

# Avoid duplicate entries in the directory stack.
setopt PUSHD_IGNORE_DUPS

# Allow tab completion from the middle of a word.
setopt COMPLETE_IN_WORD

# Move cursor to the end after completion.
setopt ALWAYS_TO_END

# Enable zsh's completion system.
# This powers better tab completion for commands, files, git, etc.
autoload -Uz compinit
compinit

###############################################################################
# JavaScript / TypeScript
###############################################################################

# Load fnm, the Node.js version manager.
# --use-on-cd automatically switches Node versions when entering projects
# with .node-version or .nvmrc files.
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

###############################################################################
# Aliases
###############################################################################

# Short convenience aliases.
alias c="clear"
alias q="exit"

# Make vim/vi open Neovim.
alias vim="nvim"
alias vi="nvim"

# Quick directory navigation.
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Highlight grep matches.
alias grep="grep --color=auto"

# Use eza as a modern replacement for ls when available.
# ls = normal listing
# ll = detailed listing with hidden files and git info
# la = all files
# lt = tree view, two levels deep
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias ll="eza -la --icons --git"
  alias la="eza -a --icons"
  alias lt="eza --tree --level=2 --icons"
else
  alias ll="ls -la"
  alias la="ls -a"
fi

# Use bat as a prettier cat with syntax highlighting.
# rawcat keeps access to the original system cat.
if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
  alias rawcat="/bin/cat"
fi

# Git shortcuts.
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate --all"

# Reload this file without opening a new terminal.
alias reload="source ~/.zshrc"

###############################################################################
# Functions
###############################################################################

# Create a directory and immediately cd into it.
# Example: take my-project
take() {
  mkdir -p "$1" && cd "$1"
}

###############################################################################
# zoxide
###############################################################################

# zoxide is a smarter cd.
# It learns your most-used directories.
# Example: z dotfiles
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

###############################################################################
# fzf
###############################################################################

# fzf adds fuzzy searching in the terminal.
# Common shortcuts:
# Ctrl+R  = search command history
# Ctrl+T  = search files
# Alt+C   = fuzzy cd into directories
if command -v fzf >/dev/null 2>&1 && command -v brew >/dev/null 2>&1; then
  FZF_BASE="$(brew --prefix)/opt/fzf"

  if [[ -f "$FZF_BASE/shell/completion.zsh" ]]; then
    source "$FZF_BASE/shell/completion.zsh"
  fi

  if [[ -f "$FZF_BASE/shell/key-bindings.zsh" ]]; then
    source "$FZF_BASE/shell/key-bindings.zsh"
  fi
fi

###############################################################################
# fzf-tab
###############################################################################

# fzf-tab replaces zsh's completion menu with an fzf-powered picker.
# This makes Tab fuzzy-search files, directories, git refs, command options, etc.
if command -v brew >/dev/null 2>&1; then
  FZF_TAB_PATH="$(brew --prefix)/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"

  if [[ -f "$FZF_TAB_PATH" ]]; then
    source "$FZF_TAB_PATH"
  fi
fi

###############################################################################
# Starship
###############################################################################

# Starship is the shell prompt.
# Keep this near the end so it initializes after tools like fnm and git.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
