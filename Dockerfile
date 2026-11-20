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
        ninja-build \
        libglib2.0-dev \
        libpixman-1-dev \
        libfdt-dev \
        libffi-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && curl -fsSLO https://www.python.org/ftp/python/3.14.4/Python-3.14.4.tar.xz \
    && echo 'd923c51303e38e249136fc1bdf3568d56ecb03214efdef48516176d3d7faaef8  Python-3.14.4.tar.xz' | sha256sum -c - \
    && tar -xf Python-3.14.4.tar.xz \
    && cd Python-3.14.4 \
    && ./configure --prefix=/opt/python-3.14.4 --with-ensurepip=install \
    && make -j"$(nproc)" \
    && make install \
    && cd /tmp \
    && rm -rf Python-3.14.4 Python-3.14.4.tar.xz

WORKDIR /workspace

CMD ["/bin/bash"]