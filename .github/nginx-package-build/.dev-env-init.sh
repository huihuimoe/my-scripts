#!/bin/bash

# docker run -v $(pwd):/work -it --rm debian bash
# or
# docker run -v $(pwd):/work -it --rm quay.io/huihuimoe/ubuntu-ci-base:20.04 bash
# bash /work/.github/nginx-package-build/.dev-env-init.sh DIR

set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <nginx-build-dir>"
  exit 1
fi
if [[ ! -d "/work/$1" ]]; then
  echo "Usage: $0 <nginx-build-dir>"
  exit 1
fi

apt-get update
apt-get install -y fish unzip curl gawk wget git perl bison lsb-release wget software-properties-common gnupg debhelper cmake pkg-config \
  vim tree \
  --no-install-recommends

# LLVM
. $(dirname $0)/../../nginx-base/config.sh
curl -sSL https://apt.llvm.org/llvm.sh | bash -s -- ${clang_version}
update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/lld-${clang_version}" 20
update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10
update-alternatives --install "/usr/bin/ar" "ar" "/usr/bin/llvm-ar-${clang_version}" 20
#update-alternatives --install "/usr/bin/ar" "ar" "/usr/bin/x86_64-linux-gnu-ar" 10

# Rust (not need anymore)
# curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
# source "$HOME/.cargo/env"

# Golang
curl -sSL https://git.io/g-install | sh -s -- fish bash -y
source ~/.bashrc

DIR=$1
export CI=1
mkdir /ci-build
cd /ci-build
bash /work/.github/nginx-package-build/get-deps.sh
rm -rf /ci-build/deps
cd /work
# bash /work/.github/nginx-package-build/pack.sh $DIR
cd $DIR
bash ./require.sh
bash ./build.sh
cd ..
bash /work/.github/nginx-package-build/show-info.sh $DIR
