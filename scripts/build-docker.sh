#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DOCKER_IMAGE="embedded-linux-builder:1.0"

cd "$PROJECT_DIR"

if ! sudo docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
    echo "Image not found. Building..."
    sudo docker build -t "$DOCKER_IMAGE" .
fi

sudo docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    --mount "type=bind,source=$PROJECT_DIR,target=/workspace" \
    "$DOCKER_IMAGE" bash