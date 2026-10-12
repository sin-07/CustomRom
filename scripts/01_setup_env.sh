#!/bin/bash
# ==============================================================================
# Script 01: Setup Android AOSP Build Environment (Ubuntu 22.04 / 24.04 / WSL2)
# ==============================================================================
set -e

echo "=== [Step 1/5] Updating Package Repositories ==="
sudo apt update && sudo apt upgrade -y

echo "=== [Step 2/5] Installing Android Build Dependencies ==="
sudo apt install -y \
    bc bison build-essential ccache curl flex g++-multilib gcc-multilib git \
    git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev \
    liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 \
    libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip \
    zlib1g-dev python3 python3-pip openjdk-17-jdk libarchive-tools erofs-utils \
    android-sdk-platform-tools adb fastboot

echo "=== [Step 3/5] Installing Google Repo Tool ==="
mkdir -p ~/bin
if ! command -v repo &> /dev/null; then
    curl -s https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo
fi

# Add ~/bin to PATH if not present
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
    export PATH=$HOME/bin:$PATH
fi

echo "=== [Step 4/5] Setting up CCache for Faster Compilation ==="
export USE_CCACHE=1
export CCACHE_EXEC=$(which ccache)
ccache -M 50G
echo "CCache configured to 50 GB maximum storage."

echo "=== [Step 5/5] Configuring Android USB udev Rules ==="
if [ -d "/etc/udev/rules.d" ]; then
    sudo tee /etc/udev/rules.d/51-android.rules > /dev/null << 'EOF'
# MediaTek Devices
SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", MODE="0666", GROUP="plugdev"
# Google / Fastboot
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
# Nothing Phone
SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", MODE="0666", GROUP="plugdev"
EOF
    sudo udevadm control --reload-rules || true
fi

echo "=== Environment Setup Completed Successfully! ==="
