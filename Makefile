# Makefile for aichat-installer development

.PHONY: help test test-structure test-docker verify install clean

# Default target
help:
	@echo "aichat-installer development commands:"
	@echo ""
	@echo "  make test           - Run all tests"
	@echo "  make test-structure - Test project organization"
	@echo "  make test-docker    - Run Docker-based tests"
	@echo "  make verify         - Run installation verification"
	@echo "  make install        - Install aichat locally"
	@echo "  make clean          - Clean up test artifacts"
	@echo "  make help           - Show this help"

# Run all tests
test:
	@echo "🧪 Running complete test suite..."
	@./tests/test-suite.sh

# Test project structure
test-structure:
	@echo "📁 Testing project structure..."
	@./tests/test-structure.sh

# Run Docker tests
test-docker:
	@echo "🐳 Running Docker-based tests..."
	@./tests/test-docker.sh

# Run installation verification
verify:
	@echo "✅ Running installation verification..."
	@./scripts/verify-installation.sh

# Install aichat locally
install:
	@echo "📦 Installing aichat..."
	@./install-aichat

# Clean up test artifacts
clean:
	@echo "🧹 Cleaning up test artifacts..."
	@rm -rf /tmp/aichat-*test* /tmp/config-only-test* /tmp/final-test*
	@echo "✅ Cleanup complete"

# Quick development setup
dev-setup:
	@echo "🛠️  Setting up development environment..."
	@chmod +x install-aichat scripts/* tests/*
	@echo "✅ All scripts are now executable"