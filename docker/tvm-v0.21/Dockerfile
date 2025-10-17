# Dockerfile to build Apache TVM v0.21 and produce tvmjs runtime bundles
# Base on Ubuntu LTS
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git cmake ninja-build python3 python3-dev python3-pip curl wget ca-certificates \
    gcc g++ libc6-dev libnuma-dev clang llvm lld libncurses5 libedit-dev libssl-dev \
    libtinfo-dev pkg-config libxml2-dev libffi-dev libz-dev unzip autoconf automake libtool \
    cmake-curses-gui python3-venv virtualenv python3-setuptools python3-wheel \
    curl ca-certificates git pkg-config libglib2.0-dev libexpat1-dev \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create a workspace
WORKDIR /workspace

# Install Python tooling
RUN python3 -m pip install --upgrade pip setuptools wheel
RUN pip install cython numpy

# Install emscripten (required for wasm/tvmjs builds)
RUN git clone https://github.com/emscripten-core/emsdk.git /opt/emsdk && \
    /opt/emsdk/emsdk install latest && \
    /opt/emsdk/emsdk activate latest && \
    echo "source /opt/emsdk/emsdk_env.sh" >> /etc/profile.d/emsdk.sh

ENV PATH="/opt/emsdk:/opt/emsdk/node/bin:/opt/emsdk/llvm/bin:${PATH}"

# Build TVM v0.21
# We will clone the v0.21 tag and perform an out-of-source build with CMake
ARG TVM_REPO="https://github.com/apache/tvm.git"
ARG TVM_TAG="v0.21.0"

RUN git clone ${TVM_REPO} tvm && \
    cd tvm && git checkout ${TVM_TAG} && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DUSE_LLVM=ON -DUSE_PYTHON=ON -DUSE_RPC=OFF -DUSE_METAL=OFF -DUSE_OPENCL=OFF -DUSE_CUDA=OFF -DUSE_VULKAN=OFF -DUSE_WASM=ON -DUSE_LLVM_RUNTIME=ON .. && \
    make -j$(nproc)

# Install TVM Python package
RUN cd tvm/python && python3 -m pip install -e .

# Create a directory for scripts
RUN mkdir -p /workspace/docker/tvm-v0.21

COPY docker/tvm-v0.21/build-tvmjs.sh /workspace/docker/tvm-v0.21/build-tvmjs.sh
RUN chmod +x /workspace/docker/tvm-v0.21/build-tvmjs.sh

# Entrypoint: run build script by default
ENTRYPOINT ["/workspace/docker/tvm-v0.21/build-tvmjs.sh"]
