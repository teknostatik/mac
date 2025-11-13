#!/bin/bash

# Create a proper .app bundle

echo "Creating Mac Setup.app bundle..."

APP_NAME="Mac Setup"
BUNDLE_DIR="$APP_NAME.app"
CONTENTS_DIR="$BUNDLE_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Clean up existing bundle
rm -rf "$BUNDLE_DIR"

# Create directory structure
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Build the executable
echo "Building executable..."
swiftc -o "$MACOS_DIR/MacSetupApp" MacSetupApp.swift \
    -framework SwiftUI \
    -framework Foundation \
    -framework AppKit \
    -target arm64-apple-macos12.0 \
    -parse-as-library

if [ $? -ne 0 ]; then
    echo "✗ Build failed"
    exit 1
fi

# Create Info.plist
cat > "$CONTENTS_DIR/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>MacSetupApp</string>
    <key>CFBundleIdentifier</key>
    <string>com.teknostatik.macsetup</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Mac Setup</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2025</string>
</dict>
</plist>
EOF

# Create PkgInfo
echo "APPL????" > "$CONTENTS_DIR/PkgInfo"

echo "✓ Build successful!"
echo ""
echo "Created: $BUNDLE_DIR"
echo ""
echo "You can now:"
echo "  1. Double-click '$BUNDLE_DIR' to run"
echo "  2. Copy it to /Applications"
echo "  3. Run: open '$BUNDLE_DIR'"
