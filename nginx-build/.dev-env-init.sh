#!/bin/bash

apt-get update
apt-get install -y fish unzip curl gawk wget git perl bison lsb-release wget software-properties-common gnupg mercurial \
  libexpat-dev libpcre3-dev libxml2-dev libxslt-dev libgeoip-dev libgd-dev libpam0g-dev libperl-dev libmaxminddb-dev uuid-dev debhelper cmake libunwind-dev

# LLVM
curl -sSL https://apt.llvm.org/llvm.sh | bash -s -- 15

# Rust
curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
source "$HOME/.cargo/env"

# Golang
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source /root/.gvm/scripts/gvm
gvm install go1.19.2 -B
gvm use go1.19.2 --default

fish
