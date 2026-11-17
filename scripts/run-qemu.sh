#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

exec ./qemu-11.1.3/build/qemu-system-aarch64 \
  -M virt \
  -cpu cortex-a57 \
  -m 1024 \
  -nographic \
  -kernel linux-6.12.117/arch/arm64/boot/Image \
  -initrd rootfs.cpio.gz \
  -append "console=ttyAMA0 rdinit=/init"