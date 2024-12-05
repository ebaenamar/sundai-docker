FROM debian:12

# install base dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes curl wget build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev dumb-init git vim less iputils-ping nginx postgresql-15 redis python3 python3-pip pipx apache2-utils sudo libsecret-1-0 command-not-found rsync man-db php php-pgsql netcat-openbsd python3-deepmerge python3-requests python3-ipython python3-dotenv dnsutils procps lsof git screen

# install anaconda
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh && \
  bash Anaconda3-2024.10-1-Linux-x86_64.sh -b -p /opt/conda && \
  rm Anaconda3-2024.10-1-Linux-x86_64.sh
ENV PATH=/opt/conda/bin:$PATH

# install node from nodesource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# set up the runner script
COPY run.sh /run.sh

CMD ["bash", "/run.sh"]
