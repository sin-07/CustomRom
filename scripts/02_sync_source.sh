#!/bin/bash
# ==============================================================================
# Script 02: Download Android 17 (AOSP) Source Code & Device Manifests
# ==============================================================================
set -e

# Target AOSP branch (Android 17)
AOSP_BRANCH="android-latest-release"
WORKDIR="${AOSP_DIR:-$HOME/android/aosp-17}"

echo "=== Target Build Directory: ${WORKDIR} ==="
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Check available disk space before syncing
FREE_KB=$(df -k . | tail -1 | awk '{print $4}')
FREE_GB=$((FREE_KB / 1024 / 1024))
echo "[*] Available Disk Space in ${WORKDIR}: ${FREE_GB} GB"

if [ "$FREE_GB" -lt 150 ]; then
    echo "[!] WARNING: AOSP requires at least 250-350 GB for source + build tree."
    echo "[!] Proceeding with shallow clone (--depth=1) to minimize storage footprint."
fi

# Configure Git user if not set
if ! git config --get user.email &> /dev/null; then
    echo "[*] Setting temporary Git identity..."
    git config --global user.name "AOSP Builder"
    git config --global user.email "builder@localhost"
fi

echo "=== Initializing AOSP Repository ==="
if [ ! -d ".repo" ]; then
    repo init -u https://android.googlesource.com/platform/manifest -b "${AOSP_BRANCH}" --depth=1
fi

echo "=== Copying Local Device Manifests for Nothing Phone (2a) Plus ==="
mkdir -p .repo/local_manifests
MANIFEST_SOURCE="$(dirname "$0")/../manifests/pacmanpro_aosp17.xml"
if [ -f "${MANIFEST_SOURCE}" ]; then
    cp "${MANIFEST_SOURCE}" .repo/local_manifests/pacmanpro.xml
    echo "[*] Copied pacmanpro.xml to .repo/local_manifests/"
fi

echo "=== Synchronizing Source Repositories ==="
# -c: current branch only
# -j$(nproc): parallel threads
# --no-clone-bundle: avoid downloading large multi-branch git bundles
repo sync -c -j$(nproc) --no-clone-bundle --no-tags --force-sync

echo "=== Sync complete! Copying device tree into tree ==="
mkdir -p device/nothing/pacmanpro
cp -r "$(dirname "$0")/../device/nothing/pacmanpro/"* device/nothing/pacmanpro/
mkdir -p custom
cp -r "$(dirname "$0")/../custom/"* custom/

echo "=== Source tree is ready for compilation ==="
