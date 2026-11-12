#!/usr/bin/env bash
set -euo pipefail

# Find the project directory, regardless of where the script is launched.
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

KERNEL_VERSION="6.12.117"
DOCKER_IMAGE="embedded-linux-builder"
JOBS="${JOBS:-4}"

if [[ ! -f configs/kernel.config ]]; then
    echo "Missing configs/kernel.config. Save your kernel configuration first." >&2
    exit 1
fi

# Build or update the Docker environment.
docker build -t "$DOCKER_IMAGE" .

# Download, configure and compile inside Docker.
docker run --rm \
    --user "$(id -u):$(id -g)" \
    --mount "type=bind,source=$PROJECT_DIR,target=/workspace" \
    --env KERNEL_VERSION="$KERNEL_VERSION" \
    --env JOBS="$JOBS" \
    "$DOCKER_IMAGE" bash -euo pipefail -c '
        cd /workspace

        SOURCE_DIR="linux-${KERNEL_VERSION}"
        ARCHIVE="${SOURCE_DIR}.tar.xz"
        SOURCE_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/${ARCHIVE}"

        if [[ ! -d "$SOURCE_DIR" ]]; then
            curl --fail --location --retry 3 \
                "$SOURCE_URL" -o "${ARCHIVE}.part"
            mv "${ARCHIVE}.part" "$ARCHIVE"
            tar -xf "$ARCHIVE"
        fi

        cd "$SOURCE_DIR"

        cp /workspace/configs/kernel.config .config

        make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
        make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
            -j"$JOBS" Image

        test -s arch/arm64/boot/Image
        ls -lh arch/arm64/boot/Image
        file arch/arm64/boot/Image
    '

echo "Kernel build completed:"
echo "$PROJECT_DIR/linux-$KERNEL_VERSION/arch/arm64/boot/Image"