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

## 🚀 Quick Start

### One-Line Installation
```bash
curl -fsSL https://raw.githubusercontent.com/your-repo/aichat-install/main/install-aichat | bash
```

### Manual Installation
```bash
# Download the script
wget https://raw.githubusercontent.com/your-repo/aichat-install/main/install-aichat
chmod +x install-aichat

# Run the installation
./install-aichat
```

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

## 📖 Additional Resources

- [aichat Documentation](https://github.com/sigoden/aichat/wiki)
- [OpenAI API Reference](https://platform.openai.com/docs)
- [Shell Integration Guide](https://github.com/sigoden/aichat/wiki/Shell-Integration)

---

**Made with ❤️ for the aichat community**

*Transform your command line experience with AI-powered assistance!*