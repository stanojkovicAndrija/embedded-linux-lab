#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_VERSION="6.12.117"
SOURCE_DIR="$PROJECT_DIR/linux-$KERNEL_VERSION"
CONFIG_FILE="$PROJECT_DIR/configs/kernel.config"
JOBS=4
CLEAN=false

usage() {
    echo "Usage: $0 [--clean] [-j<number>]"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --clean)
            CLEAN=true
            ;;
        -j*)
            if [[ "$1" =~ ^-j([1-9][0-9]*)$ ]]; then
                JOBS="${BASH_REMATCH[1]}"
            else
                usage >&2
                exit 1
            fi
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Kernel source directory not found: $SOURCE_DIR" >&2
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Saved configuration not found: $CONFIG_FILE" >&2
    exit 1
fi

cd "$SOURCE_DIR"

if [[ "$CLEAN" == true ]]; then
    echo "Cleaning kernel build..."
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
fi

cp "$CONFIG_FILE" .config

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j"$JOBS" Image dtbs

test -s arch/arm64/boot/Image
file arch/arm64/boot/Image

echo "Kernel build completed: $SOURCE_DIR/arch/arm64/boot/Image"