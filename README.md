# Linux Setup Scripts for i3 Window Manager

A comprehensive setup package for configuring a fresh Linux installation with i3 window manager support and development tools.

## Overview

This package contains scripts and configuration files to automate the setup of a Linux development environment with:
- i3 tiling window manager
- Zsh shell with oh-my-zsh and Powerlevel10k theme
- Development tools (Docker, Node.js, Composer, etc.)
- Popular development applications (VS Code, Cursor, DBeaver, etc.)
- System utilities and configurations

## Prerequisites

- Ubuntu/Debian-based Linux distribution
- sudo/root access
- Internet connection
- The setup files must be extracted in `~/Downloads/linuxsetup/` directory

## ⚠️ Important: Hardcoded Username

**CRITICAL:** The `linux-setup/zshrc_config` file contains hardcoded references to the username `your-own-username`. 

**Before using this package, you MUST:**
1. Open `linux-setup/zshrc_config` in a text editor
2. Search and replace all instances of `your-own-username` with your own username
3. The affected lines are:
   - Line 12: `export ZSH="/home/your-own-username/.oh-my-zsh"`
   - Line 133: `export PATH="$PATH:/home/your-own-username/.local/bin"`
   - Line 137: `__conda_setup="$('/home/your-own-username/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"`
   - Line 141: `if [ -f "/home/your-own-username/anaconda3/etc/profile.d/conda.sh" ]; then`
   - Line 144: `export PATH="/home/your-own-username/anaconda3/bin:$PATH"`

**Note:** The main setup script (`linux-setup.sh`) also expects the home directory to be `/home/your-own-username/`. If your username is different, you'll need to modify the script or ensure the paths are updated accordingly.

## Installation Instructions

1. **Extract the package:**
   ```bash
   cd ~/Downloads
   # Extract the linuxsetup folder here
   ```

2. **Update the zshrc_config file:**
   - Open `linux-setup/zshrc_config`
   - Replace all instances of `your-own-username` with your username (see Important section above)

3. **Run the main setup script:**
   ```bash
   cd ~/Downloads/linuxsetup
   chmod +x linux-setup.sh
   ./linux-setup.sh
   ```

4. **Follow the prompts:**
   - The script will install packages and applications
   - You may be prompted to run `p10k configure` at the end
   - Log out and log back in (or restart) to apply all changes

## What Gets Installed

### Window Manager & Desktop Environment
- **i3** - Tiling window manager with custom configuration

### Shell & Terminal
- **zsh** - Z shell
- **oh-my-zsh** - Zsh configuration framework
- **Powerlevel10k** - Zsh theme
- **Plugins:**
  - fzf (fuzzy finder)
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - git, tig, sudo, web-search, copypath, copyfile, dirhistory

### Development Tools
- **Git** - Version control
- **Vim** - Text editor
- **Node.js & npm** - JavaScript runtime and package manager
- **nvm** - Node Version Manager (v0.40.1)
- **Yarn** - JavaScript package manager
- **Docker** - Container platform
- **Docker Compose** - Multi-container Docker applications
- **Composer** - PHP dependency manager
- **fd-find** - Fast file finder

### Applications
- **Google Chrome** - Web browser
- **Sublime Text** - Text editor (via snap)
- **Postman** - API testing tool (via snap)
- **VS Code** - Code editor (via snap)
- **Cursor** - AI-powered code editor (AppImage)
- **DBeaver** - Database management tool
- **MySQL Workbench** - MySQL database administration
- **Beyond Compare** - File comparison tool

### System Utilities
- **pavucontrol** - PulseAudio volume control
- **blueman** - Bluetooth management
- **snapd** - Snap package manager
- **htop** - Process monitor
- **wget, curl** - Download utilities

## Script Documentation

### Main Installation Scripts

#### `linux-setup.sh`
The main installation script that orchestrates the entire setup process:
- Updates system packages
- Installs i3 window manager
- Copies i3 configuration to `~/.config/i3/config`
- Installs all development tools and applications
- Sets up zsh with oh-my-zsh and plugins
- Configures mouse settings
- Copies keyboard detection scripts
- Installs and configures zsh theme and plugins
- Copies zsh configuration to `~/.zshrc`

**Usage:**
```bash
./linux-setup.sh
```

#### `install-cursor.sh`
Installs Cursor IDE as an AppImage:
- Downloads Cursor AppImage to `/opt/cursor/cursor.appimage`
- Downloads Cursor icon
- Creates desktop entry for application menu
- Installs libfuse2 dependency if needed

**Usage:**
```bash
./install-cursor.sh
```

#### `desktop-startup.sh`
Launches multiple applications in i3 workspace 1:
- Google Chrome
- Cursor IDE
- DBeaver
- Sublime Text
- Nautilus (file manager)
- Brave Browser (if installed)

**Usage:**
```bash
./desktop-startup.sh
```

#### `i3mouse.sh`
Mouse sensitivity and speed adjustment utility for i3:
- `fast` - Increases mouse speed (3.2x horizontal, 1.8x vertical)
- `slow` - Decreases mouse speed (0.4x both axes)
- `enable/disable` - Enables or disables the mouse
- `toggle` - Toggles between fast and slow modes

**Usage:**
```bash
./i3mouse.sh fast    # Fast mouse movement
./i3mouse.sh slow    # Slow mouse movement
./i3mouse.sh toggle # Toggle between fast/slow
./i3mouse.sh enable  # Enable mouse
./i3mouse.sh disable # Disable mouse
```

### Configuration Files

#### `linux-setup/i3config`
i3 window manager configuration file:
- Key bindings (Mod1/Alt key as modifier)
- Workspace management (10 workspaces)
- Window management shortcuts
- Application launchers (Control+1-6, Control+9-0)
- Screenshot bindings (Print key combinations)
- Audio controls (volume keys)
- Network manager applet
- Screen lock on suspend

**Location:** Copied to `~/.config/i3/config` during installation

#### `linux-setup/zshrc_config`
Zsh configuration file with:
- oh-my-zsh setup
- Powerlevel10k theme
- Plugin configurations
- Custom aliases and functions
- PATH configurations
- Conda initialization (if installed)
- Custom `bat()` function for file browsing with fzf
- Cursor IDE function
- System suspend/sleep functions

**⚠️ Contains hardcoded username - see Important section above**

**Location:** Copied to `~/.zshrc` during installation

#### `linux-setup/picom.conf`
Compositor configuration for screen tearing prevention:
- GLX backend
- VSync enabled
- Unredirect disabled

**Note:** Picom installation is commented out in the main script. Uncomment if needed for machines with screen tearing issues.

#### `linux-setup/40-libinput.conf`
X11 input configuration for mouse acceleration:
- Configured for Logitech G400s Optical Gaming Mouse
- Flat acceleration profile
- Low acceleration speed (0.1)

**Location:** Copied to `/etc/X11/xorg.conf.d/40-libinput.conf` during installation

### Utility Scripts

#### `linux-setup/detect_usb_keyboard.sh`
Automatically detects if a USB keyboard is connected and switches the i3 modifier key accordingly:
- If USB keyboard detected: sets `$mod` to `Mod1` (Alt key)
- If no USB keyboard: sets `$mod` to `Mod4` (Super/Windows key)
- Automatically restarts i3 to apply changes

**Usage:**
```bash
~/.config/i3/detect_usb_keyboard.sh
# or
~/detect_usb_keyboard.sh
```

**Location:** Copied to both `~/.config/i3/` and `~/` during installation

#### `linux-setup/switch_keyboard.sh`
Manually switches i3 modifier key between USB and built-in keyboard modes:
- `./switch_keyboard.sh usb` - Sets modifier to Mod1 (Alt)
- `./switch_keyboard.sh` (no argument) - Sets modifier to Mod4 (Super)

**Usage:**
```bash
~/.config/i3/switch_keyboard.sh usb  # USB keyboard mode
~/.config/i3/switch_keyboard.sh       # Built-in keyboard mode
```

**Location:** Copied to both `~/.config/i3/` and `~/` during installation

### Miscellaneous Scripts

Located in `misc-scripts/` directory:

#### `misc-scripts/audio-settings.sh`
Opens pavucontrol (PulseAudio volume control GUI).

**Usage:**
```bash
./misc-scripts/audio-settings.sh
```

#### `misc-scripts/bluetooth-settings.sh`
Launches blueman-applet (Bluetooth management GUI) in the background.

**Usage:**
```bash
./misc-scripts/bluetooth-settings.sh
```

#### `misc-scripts/desktop-startup.sh`
Same as root-level `desktop-startup.sh` - launches multiple applications in i3 workspace 1.

#### `misc-scripts/docker-volume-size.sh`
Calculates and displays the total size of all Docker volumes in GB. Parses `docker system df -v` output and converts all volume sizes to a single GB total.

**Usage:**
```bash
./misc-scripts/docker-volume-size.sh
```

## Post-Installation

After running the setup script:

1. **Configure Powerlevel10k:**
   - The script will prompt you to run `p10k configure`
   - Follow the interactive prompts to customize your prompt

2. **Set zsh as default shell:**
   ```bash
   chsh -s $(which zsh)
   ```
   Log out and log back in for this to take effect.

3. **Configure i3:**
   - The i3 config is already copied, but you may want to customize it
   - Edit `~/.config/i3/config` to suit your preferences

4. **Docker group:**
   - You've been added to the docker group
   - Log out and log back in for group changes to take effect
   - Or run: `newgrp docker`

5. **Keyboard detection:**
   - If you use a USB keyboard, run `~/.config/i3/detect_usb_keyboard.sh` to auto-detect and configure

6. **Optional - Install picom:**
   - If you experience screen tearing, uncomment the picom installation lines in `linux-setup.sh`
   - The config file is already prepared at `linux-setup/picom.conf`

## Customization

### i3 Configuration
Edit `~/.config/i3/config` to customize:
- Key bindings
- Workspace names
- Application launchers
- Window management behavior

### Zsh Configuration
Edit `~/.zshrc` to customize:
- Plugins
- Aliases
- PATH variables
- Custom functions

### Mouse Settings
Edit `/etc/X11/xorg.conf.d/40-libinput.conf` to adjust:
- Mouse acceleration profile
- Acceleration speed
- Device matching (if using a different mouse)

## Troubleshooting

### zshrc not working
- Ensure you replaced all instances of `your-own-username` with your username
- Check that oh-my-zsh is installed: `ls ~/.oh-my-zsh`

### i3 not starting applications
- Check i3 config syntax: `i3-config-wizard`
- Verify application paths in `~/.config/i3/config`
- Check i3 logs: `i3-dump-log`

### Docker permission denied
- Ensure you're in the docker group: `groups | grep docker`
- Log out and log back in after being added to the group

### Keyboard detection not working
- Manually run `~/.config/i3/detect_usb_keyboard.sh`
- Or use `switch_keyboard.sh` to manually set the modifier key

## Additional Resources

The setup script provides links to documentation for:
- [oh-my-zsh plugins](https://ohmyz.sh/#install)
- [Powerlevel10k documentation](https://github.com/romkatv/powerlevel10k)
- [NVM documentation](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [FZF configurations](https://www.linode.com/docs/guides/how-to-use-fzf/)
- [Docker installation guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
- [Docker Compose installation guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04)

## License

This is a personal setup script collection. Use at your own risk and modify as needed for your environment.

## Notes

- This setup is optimized for Ubuntu 22.04 LTS but should work on other Debian-based distributions
- Some applications (like Brave Browser) are referenced but not installed by the main script
- The setup assumes a standard desktop environment before switching to i3
- Screen tearing fixes (picom) are commented out but can be enabled if needed
