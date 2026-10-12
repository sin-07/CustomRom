#!/bin/bash
# ==============================================================================
# Script: Build Universal Android 17 Generic System Image (GSI) for Whole Devices
# ==============================================================================
set -e

WORKDIR="${AOSP_DIR:-$HOME/android/aosp-17}"

if [ ! -f "${WORKDIR}/build/envsetup.sh" ]; then
    echo "[!] AOSP source tree not found at ${WORKDIR}."
    echo "[!] Run scripts/02_sync_source.sh first."
    exit 1
fi

cd "${WORKDIR}"

echo "=== [1/3] Sourcing Build Environment ==="
source build/envsetup.sh

echo "=== [2/3] Setting Lunch Target for Universal GSI ==="
lunch aether_gsi_arm64-userdebug

export USE_CCACHE=1
export CCACHE_EXEC=$(which ccache)
export WITHOUT_CHECK_API=true
CORES=$(nproc)

echo "=== [3/3] Compiling Universal Treble System Image (system.img) ==="
m -j"${CORES}" systemimage

echo "================================================================================"
echo "  Universal GSI Compilation Succeeded!"
echo "  Output system.img: ${WORKDIR}/out/target/product/generic_arm64/system.img"
echo "  This image can be flashed onto ANY Project Treble compatible Android device!"
echo "================================================================================"
