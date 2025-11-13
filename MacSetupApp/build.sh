#!/bin/bash

# Build script for Mac Setup App

echo "Building Mac Setup App..."

# Navigate to the app directory
cd "$(dirname "$0")"

# Build the app using swiftc
swiftc -o MacSetupApp MacSetupApp.swift \
    -framework SwiftUI \
    -framework Foundation \
    -framework AppKit \
    -target arm64-apple-macos12.0

if [ $? -eq 0 ]; then
    echo "✓ Build successful!"
    echo ""
    echo "Run the app with: ./MacSetupApp"
    echo ""
    echo "Or create an app bundle with: ./create_app_bundle.sh"
else
    echo "✗ Build failed"
    exit 1
fi
