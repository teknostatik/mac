#!/usr/bin/env bash

# macOS Setup Script Using Nix Package Manager
# ===========================================
#
# This script sets up a new Mac with essential applications and development tools
# using Nix package manager instead of Homebrew. It provides the same functionality
# as the original Homebrew-based setup but leverages Nix's declarative and
# reproducible package management.
#
# What this script does:
# • Installs Nix package manager (if not already present)
# • Sets up nix-darwin for macOS-specific integrations
# • Installs applications through Nix packages and nixpkgs
# • Provides GUI applications via Nix on macOS
# • Offers both essential and optional software packages
# • Configures shell aliases and environment
# • Handles Apple Silicon compatibility automatically

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

highlight() {
    echo -e "${PURPLE}$1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ask for user input
ask_install() {
    local app_name="$1"
    local description="$2"
    echo ""
    info "Install $app_name? ($description) (y/N)"
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ] || [ "$response" = "yes" ] || [ "$response" = "Yes" ]; then
        return 0
    else
        return 1
    fi
}

# Function to install a Nix package
install_nix_package() {
    local package="$1"
    local name="$2"
    
    if nix-env -q | grep -q "^$package"; then
        echo "$name is already installed, skipping..."
    else
        log "Installing $name..."
        nix-env -iA nixpkgs.$package
    fi
}

# Display banner
echo ""
highlight "    ========================================================================"
highlight "    ███╗   ██╗██╗██╗  ██╗    ███╗   ███╗ █████╗  ██████╗ ██████╗  ███████╗"
highlight "    ████╗  ██║██║╚██╗██╔╝    ████╗ ████║██╔══██╗██╔════╝██╔═══██╗██╔════╝"
highlight "    ██╔██╗ ██║██║ ╚███╔╝     ██╔████╔██║███████║██║     ██║   ██║███████╗"
highlight "    ██║╚██╗██║██║ ██╔██╗     ██║╚██╔╝██║██╔══██║██║     ██║   ██║╚════██║"
highlight "    ██║ ╚████║██║██╔╝ ██╗    ██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝███████║"
highlight "    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝"
highlight "    ========================================================================"
echo ""
highlight "    Welcome to the Nix-based Mac Setup Script!"
echo ""
info "    This interactive script will help you set up a new Mac with essential"
info "    applications and development tools using Nix package manager."
echo ""
info "    What this script does:"
info "    • Installs Nix package manager with flakes support"
info "    • Sets up nix-darwin for macOS integration"
info "    • Offers essential applications (browsers, editors, terminal tools)"
info "    • Provides optional applications (creative tools, communication apps)"
info "    • Configures declarative package management"
info "    • Handles Apple Silicon compatibility automatically"
echo ""
info "    You'll be prompted for each application individually, so you can"
info "    pick and choose exactly what you need for your setup."
echo ""
warning "    Note: This approach uses Nix instead of Homebrew for package management."
echo ""
info "    Press Enter to continue, or Ctrl+C to exit..."
read -r

# Check for Nix installation
log "Checking for Nix installation..."

if ! command_exists nix; then
    log "Installing Nix package manager..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    
    # Source the Nix environment
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    
    log "Nix installation completed. You may need to restart your terminal."
else
    log "Nix is already installed."
fi

# Enable flakes and the new command interface
log "Configuring Nix with flakes support..."
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
auto-optimise-store = true
EOF

# Install nix-darwin for macOS integration
log "Setting up nix-darwin for macOS integration..."
if ! command_exists darwin-rebuild; then
    log "Installing nix-darwin..."
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer
else
    log "nix-darwin is already installed."
fi

# Create a basic configuration directory
log "Setting up Nix configuration..."
mkdir -p ~/.config/nix-darwin
if [ ! -f ~/.config/nix-darwin/flake.nix ]; then
    cat > ~/.config/nix-darwin/flake.nix << 'EOF'
{
  description = "macOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";  # Change to x86_64-darwin for Intel Macs
    };
  in
  {
    darwinConfigurations."$(scutil --get LocalHostName)" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
EOF
fi

# Essential Applications Section
log "Starting installation of essential applications..."

# Command line tools that are direct Nix equivalents
if ask_install "fastfetch" "system information tool"; then
    install_nix_package "fastfetch" "fastfetch"
fi

if ask_install "byobu" "terminal multiplexer"; then
    install_nix_package "byobu" "byobu"
fi

if ask_install "htop" "system monitor"; then
    install_nix_package "htop" "htop"
    # Add alias to shell configuration
    echo 'alias top="htop"' >> ~/.zshrc
    log "Alias added: 'top' will now use htop"
fi

if ask_install "ripgrep" "fast text search tool"; then
    install_nix_package "ripgrep" "ripgrep"
fi

if ask_install "eza" "modern ls replacement"; then
    install_nix_package "eza" "eza"
    if ask_install "eza alias" "alias 'ls' to 'eza -l'"; then
        echo 'alias ls="eza -l"' >> ~/.zshrc
        log "Alias added: 'ls' will now use 'eza -l'"
    fi
fi

if ask_install "pandoc" "document converter"; then
    install_nix_package "pandoc" "pandoc"
fi

# Development tools
if ask_install "Git" "version control system"; then
    install_nix_package "git" "Git"
fi

if ask_install "Vim" "text editor"; then
    install_nix_package "vim" "Vim"
fi

if ask_install "Neovim" "modern text editor"; then
    install_nix_package "neovim" "Neovim"
fi

if ask_install "Python 3" "Python programming language"; then
    install_nix_package "python3" "Python 3"
fi

if ask_install "Node.js" "JavaScript runtime"; then
    install_nix_package "nodejs" "Node.js"
fi

if ask_install "Go" "Go programming language"; then
    install_nix_package "go" "Go"
fi

if ask_install "Rust" "Rust programming language"; then
    install_nix_package "rustc" "Rust compiler"
    install_nix_package "cargo" "Cargo package manager"
fi

# GUI Applications (Note: GUI apps on macOS with Nix require special handling)
log "Setting up GUI applications..."

warning "Note: GUI applications require special handling with Nix on macOS."
warning "Some applications may need to be installed via nixpkgs or built from source."

# Create a shell script to install GUI apps via Nix when possible
cat > ~/install_gui_apps.sh << 'EOF'
#!/bin/bash

# This script installs GUI applications that are available in nixpkgs
# Some applications may require additional configuration

echo "Installing GUI applications via Nix..."

# Firefox
if nix-env -q | grep -q firefox; then
    echo "Firefox is already installed"
else
    echo "Installing Firefox..."
    nix-env -iA nixpkgs.firefox
fi

# VS Code (code-server for now, or use the macOS app)
if nix-env -q | grep -q code-server; then
    echo "VS Code server is already installed"
else
    echo "Installing VS Code server..."
    nix-env -iA nixpkgs.code-server
fi

# VLC
if nix-env -q | grep -q vlc; then
    echo "VLC is already installed"
else
    echo "Installing VLC..."
    nix-env -iA nixpkgs.vlc
fi

# GIMP
if nix-env -q | grep -q gimp; then
    echo "GIMP is already installed"
else
    echo "Installing GIMP..."
    nix-env -iA nixpkgs.gimp
fi

echo "GUI application installation completed."
echo "Note: Some applications may require additional configuration for proper macOS integration."
EOF

chmod +x ~/install_gui_apps.sh

if ask_install "GUI Applications" "install available GUI applications via Nix"; then
    log "Running GUI application installer..."
    ~/install_gui_apps.sh
fi

# For applications not available in Nix, provide alternative installation methods
log "Setting up alternative installation methods for macOS-specific applications..."

cat > ~/install_macos_apps.sh << 'EOF'
#!/bin/bash

# Alternative installation script for macOS-specific applications
# These applications are not easily available through Nix on macOS

echo "=== macOS-Specific Applications ==="
echo "The following applications are recommended to be installed manually:"
echo ""
echo "Essential Applications:"
echo "• Visual Studio Code: https://code.visualstudio.com/"
echo "• Spotify: https://www.spotify.com/download/"
echo "• Dropbox: https://www.dropbox.com/install"
echo "• Google Chrome: https://www.google.com/chrome/"
echo ""
echo "Optional Applications:"
echo "• Zoom: https://zoom.us/download"
echo "• Microsoft Teams: https://teams.microsoft.com/downloads"
echo "• UTM (Virtual Machines): https://mac.getutm.app/"
echo "• Multipass: https://multipass.run/"
echo "• ProtonVPN: https://protonvpn.com/download"
echo "• Vial: https://get.vial.today/"
echo "• VIA: https://www.caniusevia.com/"
echo "• QMK Toolbox: https://github.com/qmk/qmk_toolbox"
echo ""
echo "Development Tools:"
echo "• Ollama: Available via 'nix-env -iA nixpkgs.ollama'"
echo "• LM Studio: https://lmstudio.ai/"
echo ""
echo "You can also try installing some of these via:"
echo "• MacPorts: https://www.macports.org/"
echo "• Direct downloads from official websites"
echo "• Homebrew (if you prefer to use both package managers)"
EOF

chmod +x ~/install_macos_apps.sh

# Development environment setup
log "Setting up development environment..."

if ask_install "Development Environment" "install comprehensive development tools"; then
    # Install common development tools
    install_nix_package "gcc" "GCC compiler"
    install_nix_package "gnumake" "GNU Make"
    install_nix_package "cmake" "CMake build system"
    install_nix_package "pkg-config" "pkg-config"
    install_nix_package "curl" "curl"
    install_nix_package "wget" "wget"
    install_nix_package "jq" "JSON processor"
    install_nix_package "tree" "directory tree viewer"
    install_nix_package "unzip" "unzip utility"
    install_nix_package "zip" "zip utility"
    install_nix_package "openssl" "OpenSSL"
fi

# Shell configuration
log "Setting up shell configuration..."

if ask_install "Enhanced Shell Configuration" "add useful aliases and functions"; then
    cat >> ~/.zshrc << 'EOF'

# Nix-managed environment aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'
alias free='vm_stat'
alias ps='ps aux'
alias ports='netstat -tulanp'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Nix-specific aliases
alias nix-search='nix search nixpkgs'
alias nix-install='nix-env -iA nixpkgs.'
alias nix-list='nix-env -q'
alias nix-update='nix-channel --update && nix-env -u'
alias nix-gc='nix-collect-garbage -d'

# macOS specific
alias show-hidden='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
alias hide-hidden='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'

# Quick system info
alias sysinfo='fastfetch 2>/dev/null || neofetch 2>/dev/null || system_profiler SPSoftwareDataType'
alias myip='curl -s ifconfig.me'

# Add Nix to PATH if not already there
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
    source ~/.nix-profile/etc/profile.d/nix.sh
fi
EOF

    log "Shell aliases and functions added to ~/.zshrc"
fi

# Nix channels and updates
log "Setting up Nix channels..."
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update

log "Creating Nix management script..."
cat > ~/nix-maintenance.sh << 'EOF'
#!/bin/bash

# Nix system maintenance script

echo "=== Nix System Maintenance ==="

echo "1. Updating Nix channels..."
nix-channel --update

echo "2. Upgrading installed packages..."
nix-env -u

echo "3. Collecting garbage (removing old packages)..."
nix-collect-garbage -d

echo "4. Optimizing Nix store..."
nix-store --optimise

echo "Maintenance completed!"
EOF

chmod +x ~/nix-maintenance.sh

# Final setup
log "Finalizing setup..."

# Create a system configuration update script
cat > ~/update-darwin-config.sh << 'EOF'
#!/bin/bash

# Script to rebuild the darwin configuration

cd ~/.config/nix-darwin
darwin-rebuild switch --flake .
EOF

chmod +x ~/update-darwin-config.sh

# Completion message
echo ""
log "============================================"
log "Nix-based Mac Setup Complete!"
log "============================================"
echo ""
info "What was installed:"
echo "• Nix package manager with flakes support"
echo "• nix-darwin for macOS integration"
echo "• Essential command-line tools"
echo "• Development environment tools"
echo "• Enhanced shell configuration"
echo ""
warning "Important next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. For GUI applications, run: ~/install_macos_apps.sh"
echo "3. Regular maintenance: ~/nix-maintenance.sh"
echo "4. Update system config: ~/update-darwin-config.sh"
echo ""
info "Useful Nix commands:"
echo "• Search packages: nix search nixpkgs <package-name>"
echo "• Install package: nix-env -iA nixpkgs.<package-name>"
echo "• List installed: nix-env -q"
echo "• Update all: nix-channel --update && nix-env -u"
echo "• Garbage collect: nix-collect-garbage -d"
echo ""
highlight "Your Mac is now set up with Nix package management!"
echo ""
log "Note: Some GUI applications work better when installed via their official"
log "      installers. The install_macos_apps.sh script provides guidance for these."
