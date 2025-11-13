# Mac Setup App

A native macOS application built with SwiftUI to run the Mac setup script interactively.

## Features

- Clean, modern macOS interface
- Real-time output display
- Interactive prompt handling
- Terminal-style output with monospaced font
- Auto-scrolling output view

## Building the Application

### Option 1: Using Xcode (Recommended)

1. Open Xcode
2. Create a new macOS App project:
   - File → New → Project
   - macOS → App
   - Product Name: `MacSetupApp`
   - Interface: SwiftUI
   - Language: Swift
3. Replace the contents of `MacSetupApp.swift` and `ContentView.swift` with the provided code
4. Build and run (⌘R)

### Option 2: Using Command Line

```bash
# Create an Xcode project from the command line
cd MacSetupApp
xcodebuild -project MacSetupApp.xcodeproj -scheme MacSetupApp -configuration Release build
```

### Option 3: Using Swift Package Manager

```bash
swift build -c release
```

## Usage

1. Launch the application
2. Click "Start Setup"
3. The script will run and prompt you for each application
4. Type your responses in the input field and press Enter or click Submit
5. Monitor the progress in the terminal-style output view

## Requirements

- macOS 12.0 or later
- Xcode 13.0 or later (for building)

## Notes

The script path is hardcoded to:
```
/Users/andy/Library/CloudStorage/Dropbox/Scripts/github/mac/setup
```

If you need to change this, update the `scriptPath` variable in the `ScriptRunner.startScript()` method.
