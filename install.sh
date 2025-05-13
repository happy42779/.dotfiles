#!/bin/bash
#
# ZSH Setup Script
# Installs Oh My Zsh and popular plugins with custom Homebrew setup
# Compatible with macOS, Debian, Ubuntu, Arch Linux, and more

set -e # Exit immediately if a command exits with a non-zero status

# Text formatting
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RED=$(tput setaf 1)

# Print formatted messages
print_info() { echo "${BLUE}${BOLD}INFO:${NORMAL} $1"; }
print_success() { echo "${GREEN}${BOLD}SUCCESS:${NORMAL} $1"; }
print_warning() { echo "${YELLOW}${BOLD}WARNING:${NORMAL} $1"; }
print_error() { echo "${RED}${BOLD}ERROR:${NORMAL} $1"; }

# Required packages
PACKS="curl git zsh tmux gpg pass wget fzf lazygit"

# Default Homebrew variables (will be overridden if found in .zshrc)
HOMEBREW_BREW_GIT_REMOTE="https://github.com/Homebrew/brew.git"
HOMEBREW_CORE_GIT_REMOTE="https://github.com/Homebrew/homebrew-core.git"
HOMEBREW_BOTTLE_DOMAIN="https://homebrew.bintray.com"
HOMEBREW_API_DOMAIN="https://formulae.brew.sh/api"

# Extract Homebrew configuration from existing .zshrc or .dotfiles/.zshrc
extract_homebrew_config() {
  print_info "Looking for Homebrew configuration in existing .zshrc files..."

  local config_files=("$HOME/.zshrc" "$HOME/.dotfiles/.zshrc")
  local found_config=false

  for config_file in "${config_files[@]}"; do
    if [ -f "$config_file" ]; then
      print_info "Checking $config_file for Homebrew configurations..."

      # Extract Homebrew variables if they exist
      if grep -q "HOMEBREW_BREW_GIT_REMOTE" "$config_file"; then
        export HOMEBREW_BREW_GIT_REMOTE=$(grep "HOMEBREW_BREW_GIT_REMOTE" "$config_file" | cut -d'"' -f2 || echo "$HOMEBREW_BREW_GIT_REMOTE")
        found_config=true
      fi

      if grep -q "HOMEBREW_CORE_GIT_REMOTE" "$config_file"; then
        export HOMEBREW_CORE_GIT_REMOTE=$(grep "HOMEBREW_CORE_GIT_REMOTE" "$config_file" | cut -d'"' -f2 || echo "$HOMEBREW_CORE_GIT_REMOTE")
        found_config=true
      fi

      if grep -q "HOMEBREW_BOTTLE_DOMAIN" "$config_file"; then
        export HOMEBREW_BOTTLE_DOMAIN=$(grep "HOMEBREW_BOTTLE_DOMAIN" "$config_file" | cut -d'"' -f2 || echo "$HOMEBREW_BOTTLE_DOMAIN")
        found_config=true
      fi

      if grep -q "HOMEBREW_API_DOMAIN" "$config_file"; then
        export HOMEBREW_API_DOMAIN=$(grep "HOMEBREW_API_DOMAIN" "$config_file" | cut -d'"' -f2 || echo "$HOMEBREW_API_DOMAIN")
        found_config=true
      fi

      if [ "$found_config" = true ]; then
        print_success "Found Homebrew configuration in $config_file"
        break
      fi
    fi
  done

  if [ "$found_config" = false ]; then
    print_warning "No Homebrew configuration found, using defaults"
  else
    print_info "Using the following Homebrew configuration:"
    echo "  HOMEBREW_BREW_GIT_REMOTE: $HOMEBREW_BREW_GIT_REMOTE"
    echo "  HOMEBREW_CORE_GIT_REMOTE: $HOMEBREW_CORE_GIT_REMOTE"
    echo "  HOMEBREW_BOTTLE_DOMAIN: $HOMEBREW_BOTTLE_DOMAIN"
    echo "  HOMEBREW_API_DOMAIN: $HOMEBREW_API_DOMAIN"
  fi
}

# Install Homebrew with custom configuration
install_homebrew() {
  if [[ "$(uname)" != "Darwin" && "$(uname)" != "Linux" ]]; then
    print_warning "Homebrew installation is only supported on macOS and Linux"
    return
  fi

  if command -v brew &>/dev/null; then
    print_success "Homebrew is already installed"
    return
  fi

  print_info "Installing Homebrew with custom configuration..."

  # Export Homebrew variables for the installation
  export HOMEBREW_BREW_GIT_REMOTE
  export HOMEBREW_CORE_GIT_REMOTE
  export HOMEBREW_BOTTLE_DOMAIN
  export HOMEBREW_API_DOMAIN

  # Create a temporary installation script with the custom configuration
  BREW_INSTALL_SCRIPT=$(mktemp)

  # Download the official install script
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh >"$BREW_INSTALL_SCRIPT"

  # Make it executable
  chmod +x "$BREW_INSTALL_SCRIPT"

  # Run the installation script (it will use our exported variables)
  /bin/bash -c "$BREW_INSTALL_SCRIPT" || {
    print_error "Failed to install Homebrew"
    rm -f "$BREW_INSTALL_SCRIPT"
    exit 1
  }

  # Clean up
  rm -f "$BREW_INSTALL_SCRIPT"

  # Add Homebrew to PATH for the current session if on Linux
  if [[ "$(uname)" == "Linux" ]]; then
    if [[ -d /home/linuxbrew/.linuxbrew ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ -d "$HOME/.linuxbrew" ]]; then
      eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    fi
  elif [[ "$(uname)" == "Darwin" ]]; then
    # Add Homebrew to PATH on macOS if necessary
    if [[ -d /opt/homebrew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d /usr/local/Homebrew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  # Verify Homebrew installation
  if command -v brew &>/dev/null; then
    print_success "Homebrew installed successfully"
  else
    print_error "Homebrew installation completed but 'brew' command is not available"
    print_info "You may need to restart your shell or manually add Homebrew to your PATH"
  fi
}

# Detect package manager
detect_package_manager() {
  print_info "Detecting package manager..."

  if [[ "$(uname)" == "Darwin" ]]; then
    # First extract Homebrew config and install it if needed
    extract_homebrew_config
    install_homebrew

    PACKMANAGER="brew install"
    print_success "Using Homebrew package manager"
  elif command -v apt &>/dev/null; then
    PACKMANAGER="sudo apt install -y"
    print_success "Using apt package manager"
  elif command -v apt-get &>/dev/null; then
    PACKMANAGER="sudo apt-get install -y"
    print_success "Using apt-get package manager"
  elif command -v dnf &>/dev/null; then
    PACKMANAGER="sudo dnf install -y"
    print_success "Using dnf package manager"
  elif command -v yum &>/dev/null; then
    PACKMANAGER="sudo yum install -y"
    print_success "Using yum package manager"
  elif command -v pacman &>/dev/null; then
    PACKMANAGER="sudo pacman -S --noconfirm"
    print_success "Using pacman package manager"
  elif command -v zypper &>/dev/null; then
    PACKMANAGER="sudo zypper install -y"
    print_success "Using zypper package manager"
  else
    print_warning "Unknown package manager."
    echo "Please specify your package manager command (e.g., 'apt install'):"
    read -r user_packmanager
    PACKMANAGER="sudo $user_packmanager"
    print_info "Using custom package manager: $PACKMANAGER"
  fi
}

# Install dependencies
install_dependencies() {
  print_info "Checking and installing dependencies..."

  for PACK in $PACKS; do
    if ! command -v "$PACK" &>/dev/null; then
      print_info "Installing $PACK..."
      $PACKMANAGER "$PACK" || {
        print_error "Failed to install $PACK"
        exit 1
      }
      print_success "$PACK installed"
    else
      print_success "$PACK is already installed"
    fi
  done
}

# Install Oh My Zsh
install_oh_my_zsh() {
  print_info "Checking for Oh My Zsh installation..."

  if [ -d "$HOME/.oh-my-zsh" ]; then
    print_success "Oh My Zsh is already installed"
  else
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
      print_error "Failed to install Oh My Zsh"
      exit 1
    }
    print_success "Oh My Zsh installed"
  fi
}

# Install zsh plugins
install_plugins() {
  print_info "Installing zsh plugins..."

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  # Install zsh-autosuggestions
  if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_success "zsh-autosuggestions already installed"
  else
    print_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || {
      print_error "Failed to install zsh-autosuggestions"
      exit 1
    }
    print_success "zsh-autosuggestions installed"
  fi

  # Install zsh-syntax-highlighting
  if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_success "zsh-syntax-highlighting already installed"
  else
    print_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || {
      print_error "Failed to install zsh-syntax-highlighting"
      exit 1
    }
    print_success "zsh-syntax-highlighting installed"
  fi

  # Install zsh-completions
  if [ -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    print_success "zsh-completions already installed"
  else
    print_info "Installing zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions" || {
      print_error "Failed to install zsh-completions"
      exit 1
    }
    print_success "zsh-completions installed"
  fi
}

# Setup configuration files
setup_config_files() {
  print_info "Setting up configuration files..."

  # Check for .dotfiles directory
  if [ ! -d "$HOME/.dotfiles" ]; then
    print_warning ".dotfiles directory not found in your home directory."
    echo "Do you want to create the .dotfiles directory? (y/n)"
    read -r create_dotfiles

    if [[ "$create_dotfiles" =~ ^[Yy]$ ]]; then
      mkdir -p "$HOME/.dotfiles"
      print_success "Created .dotfiles directory"
    else
      print_warning "Skipping symlink creation for configuration files"
      return
    fi
  fi

  # Configure .zshrc
  if [ -f "$HOME/.dotfiles/.zshrc" ]; then
    print_info "Creating symlink for .zshrc..."
    ln -sf "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
    print_success ".zshrc symlink created"
  else
    print_warning ".dotfiles/.zshrc not found, creating a basic one..."

    # Create a basic .zshrc that enables the plugins and includes Homebrew configuration
    cat >"$HOME/.dotfiles/.zshrc" <<EOL
# Path to your oh-my-zsh installation.
export ZSH="\$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="robbyrussell"

# Homebrew configuration
export HOMEBREW_BREW_GIT_REMOTE="$HOMEBREW_BREW_GIT_REMOTE"
export HOMEBREW_CORE_GIT_REMOTE="$HOMEBREW_CORE_GIT_REMOTE"
export HOMEBREW_BOTTLE_DOMAIN="$HOMEBREW_BOTTLE_DOMAIN"
export HOMEBREW_API_DOMAIN="$HOMEBREW_API_DOMAIN"

# Add Homebrew to PATH if it exists in non-standard locations
if [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d \$HOME/.linuxbrew ]]; then
  eval "\$(\$HOME/.linuxbrew/bin/brew shellenv)"
elif [[ -d /opt/homebrew ]]; then
  eval "\$(/opt/homebrew/bin/brew shellenv)"
fi

# Add plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

# Load completions
fpath=(\${ZSH_CUSTOM:-\${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src \$fpath)
autoload -U compinit && compinit

# Source Oh My Zsh
source \$ZSH/oh-my-zsh.sh
EOL

    ln -sf "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
    print_success "Created basic .zshrc with Homebrew configuration and symlink"
  fi

  # Configure tmux if files exist
  if [ -f "$HOME/.dotfiles/.tmux.conf" ]; then
    print_info "Creating symlink for .tmux.conf..."
    ln -sf "$HOME/.dotfiles/.tmux.conf" "$HOME/.tmux.conf"
    print_success ".tmux.conf symlink created"
  else
    print_warning ".dotfiles/.tmux.conf not found, skipping"
  fi

  if [ -f "$HOME/.dotfiles/.tmux.conf.local" ]; then
    print_info "Creating symlink for .tmux.conf.local..."
    ln -sf "$HOME/.dotfiles/.tmux.conf.local" "$HOME/.tmux.conf.local"
    print_success ".tmux.conf.local symlink created"
  else
    print_warning ".dotfiles/.tmux.conf.local not found, skipping"
  fi

  # Handle optional .xinitrc for X11 window manager
  if [ "$1" = "--dwm" ] && [ -f "$HOME/.dotfiles/.xinitrc" ]; then
    print_info "Creating symlink for .xinitrc (DWM option detected)..."
    ln -sf "$HOME/.dotfiles/.xinitrc" "$HOME/.xinitrc"
    print_success ".xinitrc symlink created"
  fi
}

# Change shell to zsh
change_shell() {
  print_info "Checking current shell..."

  if [[ "$SHELL" == *"zsh"* ]]; then
    print_success "zsh is already your default shell"
  else
    echo "Do you want to set zsh as your default shell? (y/n)"
    read -r change_to_zsh

    if [[ "$change_to_zsh" =~ ^[Yy]$ ]]; then
      zsh_path=$(which zsh)

      if chsh -s "$zsh_path"; then
        print_success "Default shell changed to zsh"
      else
        print_error "Failed to change shell. Try running: chsh -s $(which zsh)"
      fi
    else
      print_warning "Shell unchanged. You can manually change it later with: chsh -s $(which zsh)"
    fi
  fi
}

# Main function
main() {
  clear
  echo "${BOLD}${BLUE}=============================================${NORMAL}"
  echo "${BOLD}${BLUE}  ZSH Setup with Custom Homebrew & Plugins  ${NORMAL}"
  echo "${BOLD}${BLUE}=============================================${NORMAL}"
  echo

  # First extract Homebrew config before detecting package manager
  # (This step is also done inside detect_package_manager for macOS,
  # but we need it here to make the variables available early)
  if [[ "$(uname)" == "Darwin" ]] || [[ "$(uname)" == "Linux" ]]; then
    extract_homebrew_config
  fi

  detect_package_manager
  install_dependencies
  install_oh_my_zsh
  install_plugins
  setup_config_files "$@"
  change_shell

  echo
  echo "${BOLD}${GREEN}==============================================${NORMAL}"
  echo "${BOLD}${GREEN}  Installation Complete!                     ${NORMAL}"
  echo "${BOLD}${GREEN}==============================================${NORMAL}"
  echo
  echo "To start using zsh right now, run: ${BOLD}exec zsh${NORMAL}"
  echo "Or simply restart your terminal."
  echo

  if [[ "$(uname)" == "Darwin" ]] || [[ "$(uname)" == "Linux" ]]; then
    echo "Homebrew configuration:"
    echo "  HOMEBREW_BREW_GIT_REMOTE: $HOMEBREW_BREW_GIT_REMOTE"
    echo "  HOMEBREW_CORE_GIT_REMOTE: $HOMEBREW_CORE_GIT_REMOTE"
    echo "  HOMEBREW_BOTTLE_DOMAIN: $HOMEBREW_BOTTLE_DOMAIN"
    echo "  HOMEBREW_API_DOMAIN: $HOMEBREW_API_DOMAIN"
    echo
  fi
}

# Run the main function with all provided arguments
main "$@"
