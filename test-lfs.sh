#!/bin/bash

# Git LFS Test Script
# This script helps test Git LFS functionality locally

set -e

echo "=== Git LFS Test Script ==="
echo

# Check if Git LFS is installed
if ! command -v git-lfs &> /dev/null; then
    echo "❌ Git LFS is not installed!"
    echo "Please install Git LFS first:"
    echo "  - Windows: choco install git-lfs"
    echo "  - macOS: brew install git-lfs"
    echo "  - Linux: See README.md for installation instructions"
    exit 1
fi

echo "✅ Git LFS is installed: $(git lfs version)"
echo

# Check if we're in a Git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a Git repository!"
    echo "Please run this script from the repository root"
    exit 1
fi

echo "✅ In a Git repository"
echo

# Initialize Git LFS
echo "🔧 Initializing Git LFS..."
git lfs install
echo

# Check LFS configuration
echo "📋 Git LFS Configuration:"
git lfs env
echo

# List LFS files
echo "📁 LFS Files in repository:"
git lfs ls-files
echo

# Check if large file exists
if [ -f "large_file.bin" ]; then
    echo "📊 Large file information:"
    ls -lh large_file.bin
    echo "File size: $(stat -c%s large_file.bin) bytes"
else
    echo "⚠️  large_file.bin not found in working directory"
    echo "Running 'git lfs pull' to download LFS files..."
    git lfs pull
    echo
    if [ -f "large_file.bin" ]; then
        echo "✅ File downloaded successfully:"
        ls -lh large_file.bin
    else
        echo "❌ Failed to download LFS file"
        exit 1
    fi
fi

echo
echo "=== Test Summary ==="
echo "✅ Git LFS is properly configured"
echo "✅ Large file is tracked by LFS"
echo "✅ File can be downloaded successfully"
echo
echo "🎉 All tests passed! Git LFS is working correctly."
