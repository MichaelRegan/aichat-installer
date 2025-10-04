# Quick Reference Card

## 🚀 Installation
```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/aichat-install/main/install-aichat | bash
```

## ⌨️ Shell Integration
- **Alt+E** (or **Esc+E**) - Enhance current command with AI
- Works in bash, zsh, and fish shells
- Transforms natural language to shell commands

## 💬 Basic Usage
```bash
aichat                           # Start interactive REPL
aichat "your question"           # One-shot command
aichat --role local "question"   # Use local system context (default)
aichat --help                    # Show all options
```

## 🛠️ Built-in Tools
The configuration includes these file system tools:
- `fs_cat` - Read files
- `fs_ls` - List directories  
- `fs_mkdir` - Create directories
- `fs_rm` - Remove files
- `fs_write` - Write files

## 📁 Key Files
```
~/.config/aichat/
├── config.yaml          # Main configuration
├── roles/local.md        # System context role
└── sessions/            # Conversation history
```

## 🔧 Commands
```bash
aichat --info            # Show configuration
aichat --list-roles      # List available roles
aichat --list-sessions   # List conversation sessions
gen-aichat-role         # Regenerate system context
```

## ⚙️ Quick Config Changes
```bash
# Edit main config
nano ~/.config/aichat/config.yaml

# Change default model
sed -i 's/model: .*/model: gpt-4/' ~/.config/aichat/config.yaml

# Enable Ollama (after installing Ollama)
# Uncomment the clients section in config.yaml
```

## 🐚 Shell Integration Examples
```bash
# Type this and press Alt+E:
find large files in downloads
# → find ~/Downloads -type f -size +100M

# Type this and press Alt+E:  
show me disk usage by directory
# → du -sh */ | sort -hr

# Type this and press Alt+E:
list processes using most cpu
# → ps aux --sort=-%cpu | head -10
```

## 🔍 System Context Examples
```bash
# These work automatically with local role:
aichat "What's my current disk usage?"
aichat "Show me network configuration"  
aichat "What processes are using the most memory?"
aichat "Help me clean up log files"
```

## 🆘 Troubleshooting
```bash
# Reload shell config
source ~/.bashrc        # or ~/.zshrc

# Check installation
which aichat
aichat --version

# Fix permissions
sudo chmod +x /usr/local/bin/aichat

# Regenerate system context
gen-aichat-role
```

---
**💡 Tip**: Press Alt+E on any command to enhance it with AI!