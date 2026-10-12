#
# BoardConfig for Universal Generic System Image (GSI)
# Compatible with all ARM64 Treble-compliant devices
#

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_VARIANT := generic

# System only image build
TARGET_NO_KERNEL := true
TARGET_NO_BOOTLOADER := true
TARGET_NO_RECOVERY := true
BOARD_USES_GENERIC_AUDIO := true

# Pure Treble compliant system image
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_EROFS_COMPRESSOR := lz4
BOARD_EROFS_PCLUSTER_SIZE := 262144

# Dynamic Partitions
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
BOARD_USES_DYNAMIC_PARTITIONS := true

# SELinux
BOARD_SEPOLICY_DIRS += system/sepolicy/reqd_mask
