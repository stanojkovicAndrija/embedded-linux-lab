#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_VERSION="6.12.117"
SOURCE_DIR="$PROJECT_DIR/linux-$KERNEL_VERSION"
CONFIG_FILE="$PROJECT_DIR/configs/kernel.config"
JOBS=4

if [[ $# -gt 0 ]]; then
    if [[ $# -ne 1 || ! "$1" =~ ^-j([1-9][0-9]*)$ ]]; then
        echo "Usage: $0 [-j<number>]" >&2
        exit 1
    fi

    JOBS="${BASH_REMATCH[1]}"
fi
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Kernel source directory not found: $SOURCE_DIR" >&2
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Saved configuration not found: $CONFIG_FILE" >&2
    exit 1
fi

cd "$SOURCE_DIR"

# Restore the saved configuration.
cp "$CONFIG_FILE" .config

# Update the configuration and compile the kernel.
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j"$JOBS" Image

# Check the output.
test -s arch/arm64/boot/Image
file arch/arm64/boot/Image

echo "Kernel build completed: $SOURCE_DIR/arch/arm64/boot/Image"