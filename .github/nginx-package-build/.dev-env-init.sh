#!/bin/bash

docker run -it --rm debian bash

apt-get update
apt-get install -y fish unzip curl gawk wget git perl bison lsb-release wget software-properties-common gnupg debhelper cmake pkg-config \
  --no-install-recommends
#  libexpat-dev libpcre3-dev libxml2-dev libxslt-dev libgeoip-dev libgd-dev libpam0g-dev libperl-dev libmaxminddb-dev uuid-dev libunwind-dev

# LLVM
curl -sSL https://apt.llvm.org/llvm.sh | bash -s -- 18

# Rust (not need anymore)
# curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
# source "$HOME/.cargo/env"

# Golang
curl -sSL https://git.io/g-install | sh -s -- fish bash -y
# source ~/.bashrc

fish
