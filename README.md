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

Interactive macOS setup and system maintenance scripts.

## Contents

## Scripts

### `setup`

Interactive Homebrew setup for a new or existing Mac. Choose which themes to review, then respond to individual install prompts. Already-installed formulae and casks are skipped.

The installer can install Homebrew if needed, configure taps, handle Rosetta for selected apps, and optionally configure shell aliases, Linux-style terminal colors, and global Git identity. Ollama can optionally be started as a service with a starter model downloaded. The script can also download `updateall_macos` into `/usr/local/bin`.

Available themes and applications:

- **Browsers**: Firefox, Google Chrome, Ungoogled Chromium
- **Development**: Visual Studio Code, Node.js, Asana
- **Terminal Tools**: GitHub CLI, fastfetch, UnixBench, byobu, htop, iTerm2, ripgrep, eza, tldr
- **Cloud and Sync**: Dropbox, Proton Drive, ZeroTier One
- **Security and Privacy**: ProtonVPN, Proton Pass
- **Media and Creative**: Spotify, VLC, ImageMagick, GIMP, Audacity, HandBrake, Calibre, Last.fm, bandcamp-dl, Transmission
- **Communication**: Zoom, Microsoft Teams, WhatsApp, Slack
- **Virtualization**: Container, Multipass, UTM, macpine
- **AI Tools**: Ollama, AnythingLLM, Claude, Claude Code, LM Studio, LM Studio Bionic, OpenCode, llama.cpp, Osaurus
- **Keyboards and Input**: Vial, VIA, QMK and QMK Toolbox, HRM
- **Utilities**: Pandoc, Homebrew App, Geekbench, Geekbench AI, Raspberry Pi Imager, mas, RemoveMacAI, DisplayLink Manager, Deskflow, Wireshark, Caffeine, Muzzle, Burn, MacTracker, VoodooPad

Container remains in the installer catalog, but its Homebrew cask was unavailable when checked on 2026-10-05.

Run from this directory:

```bash
./setup
```

### `updateall`

Runs macOS software updates, upgrades Mac App Store apps with `mas`, and updates and upgrades Homebrew packages. If Nix is installed, it updates Nix channels and packages and collects garbage.

This script makes system-wide changes and invokes `sudo`. It assumes Homebrew is installed and installs `mas` with Homebrew when the `mas` command is missing.

Run from this directory:

```bash
./updateall
```

## Requirements

- macOS and an internet connection
- Administrator access for software updates and selected setup steps
- Homebrew for `updateall`; `setup` installs it if missing
- Homebrew for installing `mas` when needed for Mac App Store updates
- Nix is optional for corresponding `updateall` steps

## License

See [LICENSE](LICENSE) file for details.
