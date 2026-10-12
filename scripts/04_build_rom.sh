#!/bin/bash
# ==============================================================================
# Script 04: Compile Custom Android 17 ROM for Nothing Phone (2a) Plus
# ==============================================================================
set -e

WORKDIR="${AOSP_DIR:-$HOME/android/aosp-17}"

if [ ! -f "${WORKDIR}/build/envsetup.sh" ]; then
    echo "[!] AOSP source tree not found at ${WORKDIR}."
    echo "[!] Please run scripts/02_sync_source.sh first."
    exit 1
fi

cd "${WORKDIR}"

echo "=== [1/4] Initializing Build Environment ==="
source build/envsetup.sh

echo "=== [2/4] Selecting Lunch Target ==="
# Target: aosp_pacmanpro with userdebug build type
lunch aosp_pacmanpro-userdebug

echo "=== [3/4] Configuring Build Acceleration ==="
export USE_CCACHE=1
export CCACHE_EXEC=$(which ccache)
export WITHOUT_CHECK_API=true

# Determine CPU core count for parallel Ninja execution
CORES=$(nproc)
echo "[*] Building with ${CORES} parallel threads..."

echo "=== [4/4] Starting Compilation Target ==="
START_TIME=$(date +%s)

# Compile boot image, vendor_boot, dynamic partitions, and OTA package
m -j"${CORES}" otatools target-files-package

END_TIME=$(date +%s)
DURATION=$(( (END_TIME - START_TIME) / 60 ))

echo "================================================================================"
echo "  Build Completed Successfully in ${DURATION} minutes!"
echo "  Output artifacts located in: ${WORKDIR}/out/target/product/pacmanpro/"
echo "================================================================================"
ls -lh out/target/product/pacmanpro/*.img || true
