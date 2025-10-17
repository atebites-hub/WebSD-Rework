# Lightweight Ubuntu-based image for web-stable-diffusion agent/build machines
# - Provides Python dev tooling, Node.js, build essentials and emsdk skeleton
# - Intended for development, CI jobs, and local builds. Heavy TVM full builds
#   should be done in dedicated builder images or CI runners.

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

ARG CACHEBUST=1
LABEL cachebust=$CACHEBUST

# Set non-root user
ARG AGENT_USER=agent
ARG AGENT_UID=1000

ENV TZ=UTC

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       git \
       build-essential \
       cmake \
       pkg-config \
       libssl-dev \
       libffi-dev \
       python3-distutils \
       python3-venv \
       python3-pip \
       wget \
       unzip \
       clang \
       lsb-release \
       gnupg \
       sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS (18.x)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g corepack \
    && corepack enable \
    && rm -rf /var/lib/apt/lists/*

# Create agent user and workspace
RUN groupadd --gid ${AGENT_UID} ${AGENT_USER} || true \
    && useradd --uid ${AGENT_UID} --gid ${AGENT_UID} -m -s /bin/bash ${AGENT_USER} \
    && echo "${AGENT_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${AGENT_USER} \
    && chmod 0440 /etc/sudoers.d/${AGENT_USER}

WORKDIR /workspace

# Install pipx / upgrade pip
RUN python3 -m pip install --upgrade pip setuptools wheel pipx && pipx ensurepath

# Install/upgrade pip tools and ensure venv support
RUN python3 -m pip install --upgrade pip setuptools wheel pipx && pipx ensurepath

# Install Python deps from project path (no /tmp copy). This uses the files
# at build-time from the repository working directory.
COPY web-stable-diffusion/requirements.txt web-stable-diffusion/setup.py ./
RUN if [ -s ./web-stable-diffusion/requirements.txt ]; then python3 -m pip install --no-cache-dir -r ./web-stable-diffusion/requirements.txt; fi \
    && if [ -f ./web-stable-diffusion/setup.py ]; then python3 -m pip install --no-cache-dir ./web-stable-diffusion; fi \
    && rm -f ./web-stable-diffusion/requirements.txt ./web-stable-diffusion/setup.py

# Install emsdk (lightweight enlistment without full toolchain by default)
# Users can run `/workspace/emsdk_install.sh` inside container to install full emsdk
RUN mkdir -p /opt/emsdk && chown ${AGENT_USER}:${AGENT_USER} /opt/emsdk
COPY --chown=${AGENT_USER}:${AGENT_USER} web-stable-diffusion/scripts/prep_deps.sh /opt/emsdk/emsdk_install.sh
RUN chmod +x /opt/emsdk/emsdk_install.sh

# Expose common ports used by local dev (change if needed)
EXPOSE 8080 8000

USER ${AGENT_USER}

ENV PATH=/home/${AGENT_USER}/.local/bin:/opt/emsdk:$PATH

# Default command: drop into bash in workspace
CMD ["/bin/bash"]


