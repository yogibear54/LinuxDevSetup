# Misc Scripts

Collection of utility scripts for Linux system management and application automation.

## Main Scripts

| Script | Description |
|--------|-------------|
| **printer-manager.sh** | Interactive menu-driven tool for managing CUPS print jobs. Features: view print queue, list configured printers, cancel/remove print jobs |
| **set-brightness.sh** | Adjust screen brightness using brightnessctl. Accepts percentage (e.g., `50%`) or absolute values |
| **desktop-startup.sh** | Launch multiple applications on i3 workspace 1: Google Chrome, Cursor IDE, DBeaver, Sublime Text, Nautilus, and Brave Browser |
| **audio-settings.sh** | Open PulseAudio Volume Control (pavucontrol) GUI |
| **bluetooth-settings.sh** | Launch Blueman Bluetooth manager applet |
| **docker-volume-size.sh** | Calculate and display total Docker volume size in GB |

## OBS Screen Recording

| Script | Description |
|--------|-------------|
| **obs/start.sh** | Launch OBS Studio via Flatpak |
| **screenkey/start.sh** | Launch Screenkey (displays keystrokes on screen) |
| **screenkey/settings.sh** | Open Screenkey settings dialog |

## Usage

Run scripts directly:
```bash
./script-name.sh [arguments]
```

Most scripts require appropriate permissions (e.g., `set-brightness.sh` requires sudo for brightnessctl).
