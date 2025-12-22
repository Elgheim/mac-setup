# Mac Setup

Personal mac configuration for new machine setup.

## Quick Start

```bash
# Install Xcode Command Line Tools (required for git)
xcode-select --install

# Clone and run
git clone https://github.com/Elgheim/mac-setup.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

## What's Included

### CLI Tools (via Homebrew)
- `ast-grep` - structural code search
- `bat` - better cat
- `eza` - better ls
- `fd` - better find
- `fzf` - fuzzy finder
- `gh` - GitHub CLI
- `jq/yq` - JSON/YAML processing
- `neovim` - editor
- `ripgrep` - fast grep
- `starship` - prompt
- `zoxide` - smart cd

### Apps (via Homebrew Cask)
- 1Password, Beeper, Claude, CleanShot X, Cursor
- Discord, Figma, Firefox, Ghostty, Google Chrome
- Google Drive, Granola, Linear, Notion, Raycast
- Slack, Spotify, Superhuman, Superwhisper

### Shell
- Oh My Zsh with autosuggestions + syntax highlighting
- Starship prompt
- Modern aliases (eza, bat, zoxide)
- Shortcuts (p=pnpm, b=bun, v=nvim, oc=opencode)

### Git
- Aliases (lg, undo, cleanup, etc.)
- Performance optimizations
- Global gitignore

## Files

| Path | Description |
|------|-------------|
| `Brewfile` | Homebrew packages and apps |
| `zsh/zshrc` | Shell configuration |
| `ghostty/config` | Terminal configuration |
| `git/config` | Git configuration |
| `git/ignore` | Global gitignore |
| `secrets/.secrets.example` | API keys template |

## Secrets

Store API keys in `~/.secrets` (sourced by zshrc, never committed):

```bash
export GITHUB_TOKEN="xxx"
export ANTHROPIC_API_KEY="xxx"
```

## Machine Migration

Before migrating, save current packages:

```bash
brewsave
```

This updates the Brewfile with your current packages.
