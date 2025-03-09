#!/bin/bash

set -e

PACKAGE_LIST="packages.txt"
LOG_FILE="install.log"
declare -a palist

# Installing Yay...
./yay.sh

if [[ ! -f "$PACKAGE_LIST" ]]; then
	echo "Error: Package list file '$PACKAGE_LIST' not found!"
	exit 1
fi

# Read package names from the file and store them in the array
while IFS= read -r line; do
    # Ignore empty lines or lines that start with #
    if [[ ! "$line" =~ ^# && -n "$line" ]]; then
        # Extract the first column (package name) and add to the array
        pkg_name=$(echo "$line" | awk '{print $1}')
        palist+=("$pkg_name")  # Add the package name to the array
    fi
done < "$PACKAGE_LIST"

echo "Updating system..."
yay -Syu --noconfirm >> "$LOG_FILE" 2>&1


for pkg in "${palist[@]}"; do
    if yay -Qi "$pkg" &>/dev/null; then
			echo -e "\033[0;33m[skipping]\033[0m $pkg is already installed."
		else
			echo "Installing $pkg..."
			if yay -S --noconfirm --needed "$pkg"; then
				echo "Successfully installed $pkg"
			else
				echo "Failed to install $pkg. Check $LOG_FILE for details."
			fi
	fi
done

# creating dirs and copying config files
mkdir -p ~/scripts
cp scripts/wall.sh ~/scripts

# removing earlier config files
rm -r ~/.config/hypr
rm -r ~/.config/kitty
rm -r ~/.config/waybar

# placing our config files
cp  configs/hypr configs/kitty /configs/waybar ~/.config

#copying wallpapers
cp walls/ ~/.config

# systemctls for some programs
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable sddm

echo "Installation process completed :)"
echo "\n We suggeset you to reboot your pc :)"
sleep 15
sudo systemctl start sddm

