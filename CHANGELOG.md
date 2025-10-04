# Changelog

All notable changes to the aichat installation script are documented in this file.

## [2.0.0] - 2025-10-04

### 🎉 Major Enhancement Release

#### Added
- **Comprehensive Configuration System**
  - Production-ready config with 20+ options (vs 2 in minimal version)
  - Function calling enabled with file system tools (`fs_cat`, `fs_ls`, `fs_mkdir`, `fs_rm`, `fs_write`)
  - Session management with compression at 4000 tokens
  - Server configuration (127.0.0.1:8000)
  - Shell history saving enabled
  - Syntax highlighting and theme support
  - Custom REPL prompts configuration

- **Advanced Shell Integration**
  - Multi-shell support: bash, zsh, fish
  - Alt+E (Esc+E) key binding for command enhancement
  - Natural language to shell command transformation
  - Shell-specific integration functions
  - Automatic shell detection and configuration

- **Comprehensive Tab Completions**
  - Full completion support for bash, zsh, fish
  - System-wide installation in proper directories
  - Multiple installation options (all shells, current shell, specific shells)
  - Automatic completion activation

- **System Context Awareness**
  - `gen-aichat-role` script for dynamic system context generation
  - Hardware detection (CPU, GPU, memory, network)
  - Platform identification (OS, virtualization, containers)
  - Intelligent wrapper system that auto-refreshes context
  - Local role configured as default for both REPL and CLI

- **Ollama Integration Template**
  - Ready-to-uncomment Ollama configuration
  - Local model support templates
  - Embedding and reranker model examples
  - Multiple model type support (chat, embedding, reranker)

- **Enhanced Installation Features**
  - Cross-platform testing (Ubuntu, Debian, Fedora)
  - Docker-based validation system
  - Comprehensive error handling and validation
  - Backup and restore mechanisms for existing configs
  - Modular installation (can install features independently)

#### Enhanced
- **Configuration File Structure**
  - Expanded from 8 lines to 53+ lines
  - Increased from ~80 bytes to 2070+ bytes
  - Added educational comments explaining each feature
  - Professional production-ready defaults

- **Installation Process**
  - Interactive configuration options
  - Version validation with semantic versioning
  - Architecture detection (x86_64, aarch64, armv7)
  - Existing installation detection and handling
  - Comprehensive testing and validation

- **Error Handling**
  - Robust input validation
  - Graceful failure modes with rollback
  - Clear error messages and troubleshooting guidance
  - Backup creation before config modifications

#### Technical Improvements
- **Code Quality**
  - 772 lines of well-documented bash code
  - Comprehensive function library
  - Modular design for maintainability
  - Extensive testing suite

- **Testing Infrastructure**
  - Multi-distribution Docker testing
  - Feature integration testing
  - YAML validation testing
  - Cross-platform compatibility verification

#### Documentation
- **Comprehensive README.md**
  - Complete installation and usage guide
  - Feature documentation with examples
  - Troubleshooting section
  - Best practices and security guidelines

- **Quick Reference Card**
  - Essential commands and shortcuts
  - Shell integration examples
  - Key file locations and configuration tips

### Changed
- **Default Configuration Philosophy**
  - From minimal to comprehensive configuration approach
  - From basic role setup to full system integration
  - From single-feature to multi-feature installation

- **Installation Scope**
  - Expanded from simple binary installation to complete ecosystem setup
  - Added system context generation and management
  - Integrated shell enhancement capabilities

### Fixed
- **Shell Detection**
  - Improved shell detection using current process
  - Fixed zsh completion directory paths
  - Corrected asset naming patterns for GitHub releases

- **Cross-Platform Compatibility**
  - Resolved package manager differences
  - Fixed permission handling across distributions
  - Addressed shell-specific syntax variations

## [1.0.0] - Previous Version

### Features
- Basic aichat binary installation
- Simple version selection
- Minimal configuration with local role
- Basic shell integration
- Elementary completions support

---

## Version Comparison

| Feature | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| Config Lines | 8 | 53+ |
| Config Size | ~80 bytes | 2070+ bytes |
| Configuration Keys | 2 | 20+ |
| Shell Support | Basic | bash, zsh, fish |
| Function Calling | ❌ | ✅ |
| System Context | Basic | Comprehensive |
| Ollama Template | ❌ | ✅ |
| Testing | Manual | Docker + Multi-distro |
| Documentation | Minimal | Comprehensive |

## Migration Notes

### From v1.0.0 to v2.0.0
- Existing installations will be detected and preserved
- Config files are automatically backed up before modification
- All new features are additive and don't break existing functionality
- Users can choose which features to install (modular approach)

### Backward Compatibility
- All v1.0.0 functionality is preserved
- Existing configs are enhanced, not replaced
- New features can be disabled if desired
- Command-line interface remains unchanged

---

**Note**: This changelog follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.