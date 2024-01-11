#!/bin/bash

docker run -it --rm debian bash

apt-get update
apt-get install -y fish unzip curl gawk wget git perl bison lsb-release wget software-properties-common gnupg mercurial debhelper cmake pkg-config libpam-dev
#  libexpat-dev libpcre3-dev libxml2-dev libxslt-dev libgeoip-dev libgd-dev libpam0g-dev libperl-dev libmaxminddb-dev uuid-dev libunwind-dev

# LLVM
curl -sSL https://apt.llvm.org/llvm.sh | bash -s -- 16

# Rust
curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
source "$HOME/.cargo/env"

# Golang
curl -sSL https://git.io/g-install | sh -s -- fish bash -y
# source ~/.bashrc

fish
