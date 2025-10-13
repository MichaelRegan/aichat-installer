# aichat Installation Script

A comprehensive installation script for [aichat](https://github.com/sigoden/aichat) - the all-in-one LLM CLI tool. This script provides a complete setup with advanced features, shell integration, and system context awareness.

## 🌟 Features

### 📦 Complete Installation
- **Automatic binary installation** with architecture detection (x86_64, aarch64, armv7)
- **Version validation** and GitHub release integration
- **Cross-platform support** (Ubuntu, Debian, Fedora, and more)

### 🐚 Shell Integration
- **Alt+E Enhancement**: Press Alt+E (or Esc+E) to enhance any command with AI
- **Multi-shell support**: bash, zsh, and fish
- **Tab completions** for all supported shells
- **Automatic shell detection** and configuration

### ⚙️ Comprehensive Configuration
- **Production-ready defaults** with 20+ configuration options
- **Function calling enabled** with file system tools (cat, ls, mkdir, rm, write)
- **Local system context** automatically applied to all interactions
- **Ollama integration template** ready to uncomment for local models
- **Session management** with compression and server configuration

### 🎯 System Context Awareness
- **Automatic local role generation** with system information
- **Hardware detection** (CPU, GPU, memory, network)
- **Platform identification** (OS, virtualization, containerization)
- **Fresh context** regenerated on each aichat run

## 🚀 Installation

There are two main ways to install: **Full Installation** (recommended for all features) and **Basic Installation** (for the binary only).

### Method 1: Full Installation (Recommended)

This is the best way to get all features, including the **default local system role**.

```bash
# 1. Clone the repository
git clone https://github.com/MichaelRegan/aichat-installer.git

# 2. Navigate into the directory
cd aichat-installer

# 3. Run the script
./install-aichat
```
This method ensures that all helper scripts (like `gen-aichat-role`) are available, giving you the complete, feature-rich experience.

### Method 2: Basic Installation (Binary Only)

This method is for quick, automated setups and only installs the `aichat` binary. It **does not** include the system context role or other advanced features.

```bash
# Install latest version (binary only)
curl -fsSL https://raw.githubusercontent.com/MichaelRegan/aichat-installer/main/install-aichat | bash

# Install a specific version (binary only)
curl -fsSL https://raw.githubusercontent.com/MichaelRegan/aichat-installer/main/install-aichat | AICHAT_VERSION=0.30.0 bash
```

> **Warning:** The automated method will fail if it encounters a prompt that requires user input (e.g., if aichat is already installed). For true automation, you may need to add flags to the script to pre-approve all actions.

### 🔍 Dry-Run Mode (Plan Changes Without Writing)

Use dry-run to preview exactly what the installer *would* do—no files are modified, no downloads performed:

```bash
./install-aichat --dry-run                 # or -n (human friendly summary)
./install-aichat --dry-run --json          # machine readable JSON plan (stdout = ONLY the JSON)
AICHAT_DRY_RUN=1 ./install-aichat          # environment alternative
AICHAT_DRY_RUN=1 AICHAT_JSON=1 ./install-aichat  # env-based JSON plan
```

Dry-run output includes:
- Target version & currently installed version (if any)
- Architecture & download URL
- Whether wrapper & role generator would be installed
- Planned shell integration & completions
- Whether config.yaml would be created or augmented
- Backup policy summary

Use this in CI to validate planned operations or during audits.

#### JSON Plan Output

When you add `--json` to a dry-run, the script prints a single JSON object to **stdout** and sends all progress / status lines to **stderr**. This makes parsing reliable:

```jsonc
{
    "mode": "dry-run",
    "target_version": "0.30.0",
    "current_version": "0.29.0",
    "architecture": "linux-x86_64",
    "download_url": "https://github.com/sigoden/aichat/releases/download/v0.30.0/aichat-v0.30.0-x86_64-unknown-linux-musl.tar.gz",
    "binary_target": "/usr/local/bin/aichat",
    "wrapper": {"planned": true, "skip_reason": null},
    "role_generator": {"planned": true, "skip_reason": null},
    "shell": {"detected": "zsh", "integration_planned": true},
    "completions": ["bash","zsh","fish"],
    "config": {"path": "~/.config/aichat/config.yaml", "action": "create_or_augment"},
    "backups": {"shell_rc": "on-change", "config": "on-modify"},
    "flags": {"dry_run": true, "json": true, "no_wrapper": false, "skip_role": false}
}
```

Quick extraction examples:
```bash
plan=$(./install-aichat --dry-run --json latest 2>/dev/null)
echo "$plan" | jq '.download_url'
```

### Minimal / Selective Installation Flags

These flags let you tailor what the installer sets up:

| Flag | Env Var | Effect |
|------|---------|--------|
| `--no-wrapper` | `AICHAT_NO_WRAPPER=1` | Do not rename the binary to `aichat.real` or create the auto-refresh wrapper. The installed file remains `/usr/local/bin/aichat`. |
| `--skip-role` | `AICHAT_SKIP_ROLE=1` | Skip installing `gen-aichat-role` and skip configuring the local system context role. |
| `--dry-run` / `-n` | `AICHAT_DRY_RUN=1` | Plan-only mode; no filesystem changes (can combine with `--json`). |
| `--json` (with dry-run) | `AICHAT_JSON=1` | Emit machine-readable plan JSON to stdout (suppresses chatter on stdout). |

Combine for a minimal preview:
```bash
./install-aichat --dry-run --json --no-wrapper --skip-role latest
```

Or for a minimal real installation (binary only):
```bash
./install-aichat --no-wrapper --skip-role latest
```

> Tip: In CI you can assert policy decisions (e.g. wrapper required) by inspecting the JSON plan before allowing a real install to proceed.

## 📋 Installation Options

The script will guide you through several configuration options:

### 1. Version Selection
- Enter the aichat version you want to install (e.g., `0.30.0`)
- Latest version recommendations are provided

### 2. Shell Integration
Choose whether to install shell integration that allows you to:
- Press **Alt+E** (or **Esc+E**) to enhance commands with AI
- Transform natural language into shell commands
- Get AI assistance for complex operations

### 3. Tab Completions
Select completion installation:
- **All shells** (bash, zsh, fish)
- **Current shell only**
- **Choose specific shells**
- **Skip completions**

### 4. System Context
The script automatically:
- Installs the `gen-aichat-role` system context generator
- Creates an intelligent wrapper that refreshes local system context
- Configures aichat to use local role by default

## 🔧 What Gets Installed

### Binary and Scripts
- `aichat` binary installed to `/usr/local/bin/aichat`
- `gen-aichat-role` script for system context generation
- Intelligent wrapper that auto-refreshes system context

### Configuration
- **Comprehensive config** at `~/.config/aichat/config.yaml`
- **Local role** configured as default for both REPL and CLI
- **Function calling** enabled with file system tools
- **Ollama template** ready for local models

### Shell Integration
- **Completions** installed to system directories
- **Key bindings** added to shell configuration files
- **Integration functions** for AI command enhancement

### Directory Structure
```
~/.config/aichat/
├── config.yaml          # Comprehensive configuration
├── roles/               # Role directory
├── sessions/            # Session storage
├── rags/               # RAG documents
├── macros/             # Custom macros
└── functions/          # Custom functions
```

## 💡 Usage Examples

### Basic Usage
```bash
# Start interactive REPL (with local system context)
aichat

# One-shot command (with local system context)
aichat "Help me find large files in my home directory"

# The local role provides context about your system automatically
aichat "What's the current memory usage?"
```

### Shell Integration
```bash
# Type a command and press Alt+E to enhance it
find . -name "*.log" | head -10
# Press Alt+E → transforms to more efficient command

# Natural language to commands
list files modified today
# Press Alt+E → becomes: find . -mtime 0 -type f
```

### Function Calling
```bash
# File system operations work automatically
aichat "Show me the contents of package.json and create a backup"

# List and analyze directories  
aichat "What's in my Downloads folder and how much space does it use?"
```

## 🛠️ Advanced Configuration

### Customizing the Config
Edit `~/.config/aichat/config.yaml` to customize:

```yaml
# Change the default model
model: gpt-4

# Enable Ollama for local models (uncomment)
# clients:
# - type: openai-compatible
#   name: ollama
#   api_base: http://localhost:11434/v1

# Customize function calling
mapping_tools:
  fs: 'fs_cat,fs_ls,fs_mkdir,fs_rm,fs_write'
  custom: 'my_custom_tool'
```

### Environment Variables
```bash
# Set OpenAI API key
export OPENAI_API_KEY="your-api-key"

# Use different config directory
export AICHAT_CONFIG_DIR="$HOME/my-aichat-config"
```

### Local Models with Ollama
1. Install [Ollama](https://ollama.ai/)
2. Pull a model: `ollama pull llama2`
3. Uncomment the Ollama section in `config.yaml`
4. Update the model name in the configuration

## 🔍 System Context Features

The script automatically configures aichat with comprehensive system awareness:

### Hardware Information
- CPU architecture and specifications
- Memory (RAM) configuration
- GPU information (NVIDIA, AMD)
- Storage and disk usage

### Platform Detection
- Operating system and distribution
- Kernel version and architecture
- Virtualization environment (Docker, KVM, etc.)
- Network configuration

### Real-time Context
- Current working directory
- Active processes and services
- Environment variables
- User and permission context

## 🐚 Shell Integration Details

### Bash Integration
```bash
# Added to ~/.bashrc
_aichat_bash() {
    # AI enhancement function
}
bind '"\e[E":_aichat_bash'  # Alt+E binding
```

### Zsh Integration
```bash
# Added to ~/.zshrc
_aichat_zsh() {
    # AI enhancement function  
}
bindkey '^[E' _aichat_zsh  # Alt+E binding
```

### Fish Integration
```fish
# Added to ~/.config/fish/config.fish
function _aichat_fish
    # AI enhancement function
end
bind \eE _aichat_fish  # Alt+E binding
```

## 🔧 Troubleshooting

### Installation Issues
```bash
# Check if aichat is installed
which aichat

# Verify version
aichat --version

# Check configuration
aichat --info
```

### Shell Integration Not Working
```bash
# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc

# Check if integration is loaded
type _aichat_bash  # or _aichat_zsh
```

### Permissions Issues
```bash
# Fix binary permissions
sudo chmod +x /usr/local/bin/aichat

# Fix config permissions
chmod 644 ~/.config/aichat/config.yaml
```

### Local Role Not Working
```bash
# Regenerate local role
gen-aichat-role

# Check role file
cat ~/.config/aichat/roles/local.md

# Test local role
aichat --role local "Tell me about this system"
```

## 📚 Configuration Reference

### Default Settings
The script creates a comprehensive configuration with these defaults:

```yaml
model: gpt-4o-mini              # Balanced model choice
stream: true                    # Real-time responses
function_calling: true          # Enable tool usage
save_shell_history: true       # Track commands
compress_threshold: 4000        # Session compression
serve_addr: 127.0.0.1:8000     # Local server
repl_prelude: "role:local"      # System context in REPL
cmd_prelude: "role:local"       # System context in CLI
```

### File System Tools
Pre-configured function calling tools:

- `fs_cat` - Read file contents
- `fs_ls` - List directory contents  
- `fs_mkdir` - Create directories
- `fs_rm` - Remove files/directories
- `fs_write` - Write to files

## 🎯 Best Practices

### Security
- Review the script before running: `curl -fsSL <url> | less`
- Use specific version numbers for reproducible installs
- Keep your API keys secure and never commit them

### Performance
- Use local models (Ollama) for privacy and speed
- Configure session compression for long conversations
- Use the `--no-stream` flag for scripting

### Productivity
- Learn the Alt+E enhancement workflow
- Create custom roles for specific tasks
- Use tab completion for faster command entry

## 🤝 Contributing

### Reporting Issues
- Use the GitHub issue tracker
- Include system information (`aichat --info`)
- Provide reproduction steps

### Feature Requests
- Check existing issues first
- Describe the use case clearly
- Consider contributing a PR

## 📄 License

This installation script is provided under the MIT License. See LICENSE file for details.

## 🔗 Related Projects

- [aichat](https://github.com/sigoden/aichat) - The main aichat project
- [llm-functions](https://github.com/sigoden/llm-functions) - Function calling tools
- [Ollama](https://ollama.ai/) - Local LLM runtime

## � Project Structure

This repository is organized into the following directories:

- **`install-aichat`** - Main installation script (start here!)
- **`scripts/`** - Utility scripts (`gen-aichat-role`, `verify-installation.sh`)
- **`docs/`** - Documentation ([Quick Reference](docs/QUICK_REFERENCE.md), [Changelog](docs/CHANGELOG.md))
- **`tests/`** - Comprehensive test suite for development

See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for detailed information.

## �📖 Additional Resources

- [Quick Reference Card](docs/QUICK_REFERENCE.md) - Essential commands and shortcuts
- [Changelog](docs/CHANGELOG.md) - Version history and features
- [aichat Documentation](https://github.com/sigoden/aichat/wiki)
- [OpenAI API Reference](https://platform.openai.com/docs)
- [Shell Integration Guide](https://github.com/sigoden/aichat/wiki/Shell-Integration)

---

**Made with ❤️ for the aichat community**

*Transform your command line experience with AI-powered assistance!*

---

## ♻️ Idempotent Re-run & Backup Behavior

The installer is designed to be safely re-runnable. A second (or subsequent) run will refresh binaries, wrapper scripts, completions, and shell integration without duplicating blocks or destroying user edits.

### What Happens on Re-run
| Component | Behavior |
|-----------|----------|
| `aichat` binary | Re-downloaded and reinstalled (overwrites in place) |
| `gen-aichat-role` | Reinstalled (timestamp advances) |
| Wrapper (`/usr/local/bin/aichat`) | Re-created to ensure latest role-generation logic |
| Completions | Reinstalled for selected shells (overwrites silently when `AICHAT_ASSUME_YES=1`) |
| Shell integration block | Replaced (not duplicated). Existing block is detected; when auto-approved it's refreshed and a backup of the shell rc file is taken |
| Config file (`config.yaml`) | Left untouched if already “complete” (so no noise). Only backed up when the installer needs to modify or create it |

### Backup Rules
- **Shell configuration backups**: A backup is created every time the integration block is reinstalled (e.g. `~/.zshrc.backup.<epoch>`). This guarantees you can diff or restore prior state.
- **Config file backups**: Created only when the installer adds or augments `~/.config/aichat/config.yaml` (e.g. adding missing prelude settings). If the existing config already contains the expected settings, no backup is created to avoid clutter.
- **Naming pattern**: `<original>.backup.<unix_epoch>` (monotonic & sortable).

### Verifying Idempotency
You can manually validate after a re-run:
```bash
ls -1 ~/.zshrc.backup.*        # At least one after second run
grep -c "# aichat shell integration" ~/.zshrc   # Should be exactly 1
stat -c %Y /usr/local/bin/gen-aichat-role        # Timestamp increases after re-run
grep aichat.real /usr/local/bin/aichat           # Wrapper still references real binary
```

### Non-interactive Automation
Set `AICHAT_ASSUME_YES=1` to auto-approve prompts (used in CI / scripted installs):
```bash
AICHAT_ASSUME_YES=1 ./install-aichat latest
```
This replaces fragile `yes |` style piping and avoids SIGPIPE (exit 141) under `set -o pipefail`.

### When to Manually Diff
If you maintain a custom `config.yaml`, consider putting customizations below a comment marker (e.g. `# --- custom overrides ---`). The installer never removes user-defined keys; it only adds missing defaults when first creating the file.

### Future Enhancements (Planned)
- Optional flag to force creation of a config backup even when unchanged (for strict auditing environments).
- Dry-run mode for CI validation without performing writes.

---