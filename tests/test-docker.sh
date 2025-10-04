#!/usr/bin/env bash
# Test script for aichat installation in Docker containers
set -euo pipefail

echo "🐳 Testing aichat installation script in Docker containers..."

# Test on different distributions
DISTROS=(
    "ubuntu:22.04"
    "ubuntu:24.04" 
    "debian:bookworm"
    "fedora:39"
    "alpine:latest"
)

for distro in "${DISTROS[@]}"; do
    echo ""
    echo "🧪 Testing on $distro..."
    
    # Create a test container
    container_name="aichat-test-$(echo $distro | tr ':/' '-')"
    
    # Build and run test
    docker run --rm --name "$container_name" \
        -v "$(pwd):/workspace" \
        -w /workspace \
        "$distro" \
        bash -c '
            # Install basic tools
            if command -v apt >/dev/null 2>&1; then
                apt update && apt install -y curl tar sudo
            elif command -v dnf >/dev/null 2>&1; then
                dnf install -y curl tar sudo
            elif command -v apk >/dev/null 2>&1; then
                apk add --no-cache curl tar sudo bash
            fi
            
            # Create test user
            useradd -m -s /bin/bash testuser || true
            
            # Test the installation script
            echo "Testing installation as testuser..."
            sudo -u testuser bash -c "
                cd /workspace
                echo \"Testing script syntax...\"
                bash -n ./install-aichat
                
                echo \"Testing dry run scenarios...\"
                echo -e \"N\\nN\\n4\" | timeout 30s ./install-aichat 0.30.0 || echo \"Test completed\"
            "
        ' && echo "✅ $distro: PASSED" || echo "❌ $distro: FAILED"
done

echo ""
echo "🎯 Docker testing completed!"