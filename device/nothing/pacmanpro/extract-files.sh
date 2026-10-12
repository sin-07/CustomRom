#!/bin/bash
#
# Copyright (C) 2026 The Android Open Source Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=pacmanpro
VENDOR=nothing

# Source root directory
ANDROID_ROOT="$(pwd)/../../.."
VENDOR_DIR="${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}"
PROPRIETARY_LIST="proprietary-files.txt"

SOURCE="$1"

if [ -z "${SOURCE}" ]; then
    echo "Usage: $0 <path-to-extracted-system-or-vendor-dump | adb>"
    exit 1
fi

mkdir -p "${VENDOR_DIR}/proprietary"

echo "[*] Extracting proprietary blobs for ${DEVICE}..."

while IFS= read -r FILE || [ -n "$FILE" ]; do
    # Skip comments and empty lines
    [[ "$FILE" =~ ^#.*$ ]] && continue
    [[ -z "$FILE" ]] && continue

    DEST_FILE="${VENDOR_DIR}/proprietary/${FILE#vendor/}"
    mkdir -p "$(dirname "${DEST_FILE}")"

    if [ "${SOURCE}" = "adb" ]; then
        adb pull "/${FILE}" "${DEST_FILE}"
    else
        SRC_FILE="${SOURCE}/${FILE}"
        if [ -f "${SRC_FILE}" ]; then
            cp "${SRC_FILE}" "${DEST_FILE}"
        else
            echo "[!] Warning: Missing ${FILE} from source dump."
        fi
    fi
done < "${PROPRIETARY_LIST}"

echo "[*] Blob extraction finished. Generating vendor makefiles..."
bash ./setup-makefiles.sh
