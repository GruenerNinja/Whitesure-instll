#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update and install required dependencies
echo "Updating package lists and installing dependencies..."
apt update && apt upgrade -y
apt install -y git gnome-shell-extensions gnome-tweaks gnome-shell-extension-prefs wget build-essential dkms linux-headers-$(uname -r)

# Clone WhiteSur GTK Theme repository
echo "Cloning WhiteSur GTK Theme..."
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
cd WhiteSur-gtk-theme

# Install the GTK theme with default settings
echo "Installing WhiteSur GTK Theme..."
./install.sh

# Install Dash-to-Dock GNOME Shell extension
echo "Installing Dash-to-Dock extension..."
gnome-extensions install https://extensions.gnome.org/extension-data/dash-to-dockdatrh.gnome-shell-extension.zip
gnome-extensions enable dash-to-dock@micxgx.gmail.com

# Install WhiteSur icon theme
echo "Installing WhiteSur Icon Theme..."
cd ..
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git --depth=1
cd WhiteSur-icon-theme
./install.sh

# Apply the theme using gnome-tweaks and set Dash-to-Dock to default
echo "Applying WhiteSur GTK and icon theme..."
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# Optionally install additional recommended extensions
echo "Installing additional GNOME extensions..."
gnome-extensions install https://extensions.gnome.org/extension-data/userthemesgnome-shell-extensions.zip
gnome-extensions install https://extensions.gnome.org/extension-data/blur-my-shellyaleblue52.github.com.v1.shell-extension.zip
gnome-extensions enable user-themes@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable blur-my-shell@aunetx

# Install VirtualBox Guest Additions for screen resizing support
echo "Installing VirtualBox Guest Additions..."
if [ -f /media/cdrom/VBoxLinuxAdditions.run ]; then
  cd /media/cdrom
  ./VBoxLinuxAdditions.run
else
  echo "VirtualBox Guest Additions ISO not found. Please insert the Guest Additions CD."
  echo "You can mount it from the VirtualBox menu: Devices > Insert Guest Additions CD Image..."
fi

# Clean up and finalize
echo "Cleaning up..."
cd ..
rm -rf WhiteSur-gtk-theme WhiteSur-icon-theme

echo "Installation complete! Please log out and log back in for all changes to take effect."
