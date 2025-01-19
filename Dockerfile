FROM arm64v8/debian:12

# Install base dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    curl wget build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
    dumb-init git vim less iputils-ping nginx postgresql-15 redis python3 python3-pip pipx \
    apache2-utils sudo libsecret-1-0 command-not-found rsync man-db php php-pgsql netcat-openbsd \
    python3-deepmerge python3-requests python3-ipython python3-dotenv dnsutils procps lsof git \
    screen libstdc++6 libgcc1 libglib2.0-0 libxext6 libsm6 libxrender1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniforge (ARM-compatible Miniconda)
RUN curl -O https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh && \
    bash Miniforge3-Linux-aarch64.sh -b -p /opt/conda && \
    rm Miniforge3-Linux-aarch64.sh
ENV PATH=/opt/conda/bin:$PATH

# Install Node.js from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up the runner script
COPY run.sh /sundai/run.sh
RUN chmod +x /sundai/run.sh

# Default command
CMD ["bash", "/sundai/run.sh"]
