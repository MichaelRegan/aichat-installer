#!/usr/bin/env bash
# Test script to verify the latest version detection fix

set -euo pipefail

echo "🧪 Testing latest version detection fix..."

# Test the GitHub API call directly
echo "1. Testing direct API call:"
VERSION=$(curl -fsSL "https://api.github.com/repos/sigoden/aichat/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": *"v?([^"]+)".*/\1/' 2>/dev/null)
echo "   Direct API result: $VERSION"

# Test version validation
echo "2. Testing version validation:"
validate_version() {
    local version="$1"
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "❌ Invalid version format. Expected format: X.Y.Z (e.g., 0.30.0)"
        return 1
    fi
    return 0
}

if validate_version "$VERSION"; then
    echo "   ✅ Version $VERSION is valid"
else
    echo "   ❌ Version $VERSION is invalid"
fi

# Test get_latest_version function simulation
echo "3. Testing get_latest_version logic:"
get_latest_version_test() {
    local latest_url="https://api.github.com/repos/sigoden/aichat/releases/latest"
    local version
    
    # Show progress to stderr so it doesn't interfere with version output
    echo "🔍 Fetching latest aichat release..." >&2
    
    # Try to get version from GitHub API
    if command -v curl >/dev/null 2>&1; then
        version=$(curl -fsSL "$latest_url" | grep '"tag_name":' | sed -E 's/.*"tag_name": *"v?([^"]+)".*/\1/' 2>/dev/null)
    fi
    
    # Validate the version format and return only the version
    if [[ -n "$version" ]] && validate_version "$version"; then
        echo "$version"
        return 0
    else
        echo "❌ Failed to fetch latest version from GitHub API" >&2
        return 1
    fi
}

RESULT=$(get_latest_version_test)
echo "   Function result: '$RESULT'"

echo "✅ Version detection fix verified!"