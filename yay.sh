#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No color

# Exit immediately if a command exits with a non-zero status
set -e

# Check if yay is installed
if command -v yay &> /dev/null; then
    echo -e "${GREEN}yay is already installed!${NC}"
    exit 0
fi

# Install yay
echo -e "${YELLOW}Updating system...${NC}"
sudo pacman -Syu --noconfirm

echo -e "${YELLOW}Installing dependencies...${NC}"
sudo pacman -S --needed --noconfirm git base-devel

echo -e "${YELLOW}Cloning yay repository...${NC}"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay  # Cleanup

echo -e "${GREEN}yay has been installed successfully!${NC}"