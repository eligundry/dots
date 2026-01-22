# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Dotfiles managed by [yadm](https://yadm.io/). Primary tools: fish shell, neovim, tmux, Ghostty terminal.

## Commands

```bash
yadm list              # List all tracked files
yadm status            # Check dotfile changes
yadm bootstrap         # Install/update dependencies
brew bundle --global   # Install Homebrew packages from ~/.Brewfile
man dots               # Keybinding reference
```

## Key Files

- `~/.config/fish/` - Fish shell configs
- `~/.config/nvim/init.lua` - Neovim config (lazy.nvim, leader=`,`)
- `~/.tmux.conf` - tmux config (prefix=`C-a`)
- `~/.Brewfile` - Homebrew packages
- `~/.local/share/man/man7/dots.7` - Man page for keybindings (update when changing bindings)

## Notes

- Platform-specific files use `##os.<OS>` suffix (e.g., `.Brewfile##os.Darwin`)
- Base16 theming syncs across terminal/neovim via `~/.local/bin/base16 <theme>`
