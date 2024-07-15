FROM docker.io/ubuntu:18.04

# docker buildx create --use
# docker buildx build --platform linux/amd64,linux/arm64 -t quay.io/huihuimoe/ubuntu-ci-base:18.04 --push .

# ENV CI=1
SHELL ["/bin/bash", "-c"]
RUN apt-get update \
  && env DEBIAN_FRONTEND=noninteractive TZ=Asia/Tokyo \
    apt-get dist-upgrade -y --no-install-recommends \
  && env DEBIAN_FRONTEND=noninteractive TZ=Asia/Tokyo \
    apt-get install -y sudo binutils unzip curl gawk wget ca-certificates \
    git perl debhelper pkg-config nasm build-essential lsb-release \
    wget software-properties-common gnupg xz-utils --no-install-recommends \
  && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg \
  && source /etc/os-release \
  && echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/kitware.list \
  && apt-get update \
  && apt-get install -y cmake --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*
