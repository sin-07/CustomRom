#!/bin/bash
# ==============================================================================
# Script 05: Preflight Diagnostic & Sanity Verification
# ==============================================================================

echo "=== System & Environment Diagnostic Audit ==="
echo ""

# 1. Operating System & Kernel
echo "[*] OS: $(uname -s) $(uname -r) ($(uname -m))"

# 2. Disk Space Audit
FREE_KB=$(df -k . | tail -1 | awk '{print $4}')
FREE_GB=$((FREE_KB / 1024 / 1024))
echo "[*] Free Disk Space: ${FREE_GB} GB"
if [ "$FREE_GB" -lt 150 ]; then
    echo "    [!] WARNING: Free space is under 150 GB. Full AOSP build tree typically requires ~300 GB."
else
    echo "    [+] Disk space adequate for compilation."
fi

# 3. RAM and Swap
TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
TOTAL_RAM_GB=$((TOTAL_RAM_KB / 1024 / 1024))
TOTAL_SWAP_KB=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
TOTAL_SWAP_GB=$((TOTAL_SWAP_KB / 1024 / 1024))
COMBINED_MEM=$((TOTAL_RAM_GB + TOTAL_SWAP_GB))

echo "[*] Total RAM: ${TOTAL_RAM_GB} GB | Total Swap: ${TOTAL_SWAP_GB} GB (Combined: ${COMBINED_MEM} GB)"
if [ "$COMBINED_MEM" -lt 32 ]; then
    echo "    [!] WARNING: Combined RAM + Swap is under 32 GB. Metalava/Clang linker may trigger OOM killer."
    echo "    [TIP] Create a swapfile: sudo fallocate -l 32G /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile"
else
    echo "    [+] Memory capacity verified."
fi

# 4. Critical Build Tooling
echo ""
echo "=== Toolchain Verification ==="
for cmd in python3 git repo java ccache flex bison m4 lz4; do
    if command -v "$cmd" &> /dev/null; then
        echo "    [+] $cmd: $(which "$cmd")"
    else
        echo "    [-] $cmd: NOT FOUND (Run scripts/01_setup_env.sh)"
    fi
done

# 5. Device Tree Syntax Validation
echo ""
echo "=== Device Tree Makefiles Verification ==="
DEVICE_DIR="$(dirname "$0")/../device/nothing/pacmanpro"
for mk in BoardConfig.mk device.mk AndroidProducts.mk aosp_pacmanpro.mk; do
    if [ -f "${DEVICE_DIR}/${mk}" ]; then
        echo "    [+] ${mk}: Present"
    else
        echo "    [-] ${mk}: MISSING!"
    fi
done

echo ""
echo "=== Preflight Diagnostic Completed ==="
