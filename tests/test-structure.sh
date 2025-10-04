#!/usr/bin/env bash
# Quick test to verify the organized project structure

set -euo pipefail

echo "🧪 Testing organized project structure..."

# Check main script exists
if [[ -f "install-aichat" ]]; then
    echo "✅ Main script: install-aichat found"
else
    echo "❌ Main script: install-aichat missing"
fi

# Check scripts directory
if [[ -d "scripts" ]]; then
    echo "✅ Scripts directory exists"
    if [[ -f "scripts/gen-aichat-role" ]]; then
        echo "✅ gen-aichat-role found in scripts/"
    else
        echo "❌ gen-aichat-role missing from scripts/"
    fi
    
    if [[ -f "scripts/verify-installation.sh" ]]; then
        echo "✅ verify-installation.sh found in scripts/"
    else
        echo "❌ verify-installation.sh missing from scripts/"
    fi
else
    echo "❌ Scripts directory missing"
fi

# Check docs directory
if [[ -d "docs" ]]; then
    echo "✅ Docs directory exists"
    if [[ -f "docs/CHANGELOG.md" ]]; then
        echo "✅ CHANGELOG.md found in docs/"
    else
        echo "❌ CHANGELOG.md missing from docs/"
    fi
    
    if [[ -f "docs/QUICK_REFERENCE.md" ]]; then
        echo "✅ QUICK_REFERENCE.md found in docs/"
    else
        echo "❌ QUICK_REFERENCE.md missing from docs/"
    fi
else
    echo "❌ Docs directory missing"
fi

# Check tests directory
if [[ -d "tests" ]]; then
    echo "✅ Tests directory exists"
    test_count=$(find tests -name "test-*.sh" | wc -l)
    echo "✅ Found $test_count test files in tests/"
else
    echo "❌ Tests directory missing"
fi

# Check core documentation
if [[ -f "README.md" ]]; then
    echo "✅ README.md found in root"
else
    echo "❌ README.md missing from root"
fi

if [[ -f "PROJECT_STRUCTURE.md" ]]; then
    echo "✅ PROJECT_STRUCTURE.md found in root"
else
    echo "❌ PROJECT_STRUCTURE.md missing from root"
fi

echo ""
echo "📁 Current directory structure:"
find . -type f -name "*.sh" -o -name "*.md" -o -name "install-aichat" -o -name "gen-aichat-role" | grep -v .git | sort

echo ""
echo "🎯 Structure organization complete!"