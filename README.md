# macOS Setup Scripts

```
    ███╗   ███╗ █████╗  ██████╗ ██████╗ ███████╗
    ████╗ ████║██╔══██╗██╔════╝██╔═══██╗██╔════╝
    ██╔████╔██║███████║██║     ██║   ██║███████╗
    ██║╚██╔╝██║██╔══██║██║     ██║   ██║╚════██║
    ██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝███████║
    ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
                                                 
    ███████╗███████╗████████╗██╗   ██╗██████╗   
    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗  
    ███████╗█████╗     ██║   ██║   ██║██████╔╝  
    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝   
    ███████║███████╗   ██║   ╚██████╔╝██║       
    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝       
```

Comprehensive installation and configuration scripts for macOS systems. This collection provides automated setup tools using both Homebrew and Nix package managers, QMK firmware build automation, and system maintenance utilities.

## Contents

### Main Setup Scripts

#### `setup`
Interactive setup script for a fresh macOS installation using Homebrew. Features include:
- **Homebrew Installation**: Automatically installs Homebrew if not present
- **Interactive Installation**: Prompts for each application individually, giving you full control
- **Essential Applications**: 
  - Browsers (Firefox, Safari alternatives)
  - Code editors (Visual Studio Code, Neovim, Emacs)
  - Terminal tools (GitHub CLI, fastfetch, htop, byobu)
- **Optional Applications**:
  - Creative tools (GIMP, Inkscape, Blender, Audacity)
  - Communication (Slack, Discord, Zoom)
  - Development tools (Docker, various programming languages)
  - Productivity apps
- **Apple Silicon Support**: Handles architecture-specific requirements automatically
- **Alias Configuration**: Optionally sets up helpful command aliases

Run with: `./setup`

#### `setup_nix.sh`
Alternative setup script using Nix package manager instead of Homebrew. Provides:
- **Declarative Package Management**: Uses Nix for reproducible installations
- **nix-darwin Integration**: macOS-specific Nix configurations
- **Same Application Coverage**: Mirrors the Homebrew setup functionality
- **Reproducibility**: Ensures consistent environments across machines
- **Enhanced Error Handling**: Color-coded output and detailed logging

Run with: `./setup_nix.sh`

### QMK Firmware Tools

#### `build_qmk_mac.sh`
Automated QMK firmware build script for mechanical keyboards. This script:
- Creates directory structure for all keyboard keymaps
- Syncs keymap files from the keyboards repository
- Compiles firmware for multiple keyboards including:
  - Planck (40% ortholinear)
  - Preonic (Planck with number row)
  - Corne/crkbd (split keyboard)
  - Ferris Sweep (34-key split)
  - HS60 (HHKB layout)
  - Gherkin (30-key)
  - unix60 (HHKB ISO)
  - Cantor (low-profile split)
  - Tidbit (programmable numpad)
  - ok60
- Handles multiple controller types (Elite-Pi, RP2040)
- Tests all builds to ensure firmware compiles correctly

Prerequisites: QMK CLI installed, keyboard repositories in `~/Dropbox/Scripts/github/keyboards/`

### System Maintenance

#### `updateall`
Comprehensive system update script that:
- Runs macOS software updates (`softwareupdate -i -a`)
- Updates all Homebrew packages (`brew update && brew upgrade`)
- Syncs QMK firmware keymaps from Dropbox to local QMK directory
- Updates all keyboard layouts automatically using rsync

Run regularly to keep your system and keyboard firmware up to date.

### AppleScript Launcher

#### `Mac Setup.applescript`
Native AppleScript launcher for the setup script. Provides:
- GUI dialog for confirmation before running
- Launches Terminal with the setup script
- User-friendly alternative to command-line execution

Run by double-clicking in Finder or using: `osascript "Mac Setup.applescript"`

### MacSetupApp (SwiftUI Application)

#### `MacSetupApp/`
Native macOS application built with SwiftUI for running the setup script. Features:
- **Modern macOS Interface**: Clean, native SwiftUI design
- **Real-time Output**: Terminal-style display with monospaced font
- **Interactive Prompts**: Handle script questions directly in the GUI
- **Auto-scrolling**: Output view automatically follows the script progress
- **Easy Building**: Includes instructions for Xcode, command-line, and Swift Package Manager

See [MacSetupApp/README.md](MacSetupApp/README.md) for build instructions.

## Quick Start

### Fresh macOS Installation

For a new Mac setup, run:

```bash
chmod +x setup
./setup
```

Or for a Nix-based setup:

```bash
chmod +x setup_nix.sh
./setup_nix.sh
```

### QMK Firmware Development

To build all keyboard firmware:

```bash
chmod +x build_qmk_mac.sh
./build_qmk_mac.sh
```

### Regular Updates

Keep your system and firmware up to date:

```bash
./updateall
```

## Requirements

- macOS (tested on recent versions)
- Internet connection for package downloads
- For QMK builds: QMK CLI and firmware repository
- Admin privileges for system updates

## Notes

- All scripts are designed to be safe to re-run
- The setup scripts check if applications are already installed before prompting
- QMK scripts assume specific directory structure matching the keyboards repository
- Update script can be run automatically via cron or LaunchAgents

## License

See [LICENSE](LICENSE) file for details.
