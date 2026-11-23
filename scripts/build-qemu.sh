#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
QEMU_DIR="$PROJECT_DIR/qemu-11.1.3"

if [[ ! -x "$QEMU_DIR/configure" ]]; then
    printf 'QEMU source missing: %s\n' "$QEMU_DIR" >&2
    exit 1
fi

mkdir -p "$QEMU_DIR/build"
cd "$QEMU_DIR/build"

../configure --target-list=aarch64-softmmu \
    --python=/opt/python-3.14.4/bin/python3.14
make -j"$(nproc)"

test -x ./qemu-system-aarch64
./qemu-system-aarch64 --version