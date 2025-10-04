# Project Structure

This document describes the organization of the aichat-installer project.

## 📁 Directory Layout

```
aichat-installer/
├── install-aichat              # Main installation script
├── README.md                   # Primary documentation
├── PROJECT_STRUCTURE.md        # This file
├── docs/                       # Documentation files
│   ├── CHANGELOG.md            # Version history and changes
│   └── QUICK_REFERENCE.md      # Quick reference card
├── scripts/                    # Utility scripts
│   ├── gen-aichat-role         # System context generator
│   └── verify-installation.sh  # Post-install verification
└── tests/                      # Test suite
    ├── test-config-only.sh     # Config-only installation test
    ├── test-docker.sh          # Basic Docker testing
    ├── test-docker-enhanced.sh # Enhanced Docker tests
    ├── test-docker-simple.sh   # Simple Docker validation
    ├── test-docker-comprehensive.sh # Comprehensive Docker suite
    ├── test-final.sh           # Final integration test
    ├── test-final-integration.sh # Complete feature integration test
    ├── test-fresh-install.sh   # Fresh installation testing
    └── test-suite.sh           # Main test orchestrator
```

## 📋 File Descriptions

### Core Files
- **`install-aichat`** - The main installation script (772+ lines)
  - Downloads and installs aichat binary
  - Configures comprehensive production-ready settings
  - Sets up shell integration and tab completions
  - Integrates system context awareness

### Scripts Directory (`scripts/`)
- **`gen-aichat-role`** - System context generator (193 lines)
  - Detects hardware, OS, and environment details
  - Creates intelligent local role for aichat
  - Provides system-aware AI assistance

- **`verify-installation.sh`** - Post-installation verification
  - Validates all installation components
  - Tests configuration files and features
  - Provides installation health check

### Documentation (`docs/`)
- **`CHANGELOG.md`** - Version history and feature evolution
- **`QUICK_REFERENCE.md`** - Quick start guide and essential commands

### Test Suite (`tests/`)
All test files are prefixed with `test-` and cover different aspects:
- **Docker-based tests** - Cross-platform validation
- **Integration tests** - Feature interaction testing  
- **Config tests** - Configuration validation
- **Fresh install tests** - New user experience testing

## 🚀 Usage

### Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/MichaelRegan/aichat-installer/main/install-aichat | bash
```

### Development/Testing
```bash
# Run main test suite
./tests/test-suite.sh

# Run specific tests
./tests/test-docker.sh
./tests/test-fresh-install.sh

# Verify installation
./scripts/verify-installation.sh
```

### Documentation
- Start with `README.md` for complete setup guide
- Use `docs/QUICK_REFERENCE.md` for essential commands
- See `docs/CHANGELOG.md` for version history

## 📦 Distribution

The main installation script (`install-aichat`) is designed to be the single entry point that users download. It automatically handles:
- Latest version detection
- Multi-architecture support
- Shell integration setup
- Comprehensive configuration
- Helper script installation

All other files support development, testing, and documentation but are not required for end-user installation.