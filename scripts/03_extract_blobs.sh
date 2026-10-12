#!/bin/bash
# ==============================================================================
# Script 03: Extract Proprietary Vendor Blobs from Stock Nothing OS Firmware
# ==============================================================================
set -e

FIRMWARE_DIR="$(pwd)/firmware"
DUMP_DIR="$(pwd)/firmware/extracted"
DEVICE_DIR="$(pwd)/device/nothing/pacmanpro"

echo "=== Nothing Phone (2a) Plus Blob Extractor ==="

if [ "$1" == "device" ]; then
    echo "[*] Extracting directly from connected USB device via ADB..."
    adb wait-for-device
    cd "${DEVICE_DIR}"
    bash ./extract-files.sh adb
    echo "[*] Extraction complete from live device!"
    exit 0
fi

# Firmware payload.bin flow
PAYLOAD_FILE="${FIRMWARE_DIR}/payload.bin"

if [ ! -f "${PAYLOAD_FILE}" ]; then
    echo "================================================================================"
    echo "[!] No payload.bin found in ${FIRMWARE_DIR}/"
    echo "    Please download the stock Nothing OS firmware for Phone (2a) Plus (PacmanPro),"
    echo "    extract 'payload.bin', and place it in:"
    echo "    ${FIRMWARE_DIR}/payload.bin"
    echo "    Alternatively, run: bash scripts/03_extract_blobs.sh device"
    echo "    with an ADB-enabled device connected."
    echo "================================================================================"
    exit 1
fi

echo "[*] Setting up payload-dumper..."
python3 -m pip install --upgrade payload-dumper-tree || pip3 install payload_dumper

mkdir -p "${DUMP_DIR}"
echo "[*] Unpacking payload.bin partitions..."
python3 -m payload_dumper.dumper --partitions vendor,odm,system,system_ext,product "${PAYLOAD_FILE}" --out "${DUMP_DIR}"

echo "[*] Extracting proprietary blobs from unpacked vendor partition..."
cd "${DEVICE_DIR}"
bash ./extract-files.sh "${DUMP_DIR}"

echo "=== Vendor Blobs successfully extracted and makefiles generated ==="
