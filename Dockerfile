FROM ubuntu:24.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        gcc-aarch64-linux-gnu \
        libc6-dev-arm64-cross \
        binutils-aarch64-linux-gnu \
        bc \
        bison \
        flex \
        libssl-dev \
        libelf-dev \
        libncurses-dev \
        pkg-config \
        python3 \
        perl \
        git \
        ca-certificates \
        wget \
        curl \
        xz-utils \
        bzip2 \
        gzip \
        cpio \
        file \
        rsync \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["/bin/bash"]