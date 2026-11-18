#!/bin/bash
set -ex

. $(dirname $0)/../../nginx-base/config.sh

mkdir -p deps
cd deps

export CXX=clang++-${clang_version}
export CC=clang-${clang_version}
export PKG_CONFIG="pkg-config --static"
export PREFIX="/usr"

# clone if not exsit
if [ ! -d "zlib-cf" ]; then
  git clone https://github.com/cloudflare/zlib zlib-cf
fi

cd zlib-cf
./configure --prefix=$PREFIX --static --64 
make -j
make install
cd ..

# https://github.com/tukaani-project/xz
wget https://github.com/tukaani-project/xz/releases/download/v5.8.4/xz-5.8.4.tar.gz
tar -xzf xz-5.8.4.tar.gz
cd xz-5.8.4
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

git clone --recursive https://github.com/google/brotli --depth=1
cd brotli
mkdir -p out && cd out
cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS="$CFLAGS -fPIC" \
  -DBUILD_SHARED_LIBS=off \
  -DCMAKE_INSTALL_LIBDIR=lib \
  ..
make -j
make install
cd ../..

# https://mirrors.edge.kernel.org/pub/linux/utils/util-linux
wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.42/util-linux-2.42.4.tar.gz
tar -xzf util-linux-2.42.4.tar.gz
cd util-linux-2.42.4
./configure --disable-all-programs --disable-shared --enable-libuuid --prefix=$PREFIX
make -j
make install
cd ..

# wget https://github.com/harfbuzz/harfbuzz/releases/download/15.1.0/harfbuzz-15.1.0.tar.xz
# tar -xvf harfbuzz-15.1.0.tar.xz
# cd harfbuzz-15.1.0
# meson setup build --default-library=static --prefix=$PREFIX \
#   -Dglib=disabled -Dicu=disabled -Dgraphite=disabled -Dfreetype=enabled \
#   -Dtests=disabled -Ddocs=disabled -Dutilities=disabled
# meson compile -C build
# meson install -C build
# cd ..

# https://github.com/maxmind/libmaxminddb/releases
wget https://github.com/maxmind/libmaxminddb/releases/download/1.14.1/libmaxminddb-1.14.1.tar.gz
tar -xzf libmaxminddb-1.14.1.tar.gz
cd libmaxminddb-1.14.1
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

# libxslt
# https://mirrors.dotsrc.org/gcrypt/libgpg-error
# wget https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.61.tar.bz2
wget https://mirrors.dotsrc.org/gcrypt/libgpg-error/libgpg-error-1.61.tar.bz2
tar -xvf libgpg-error-1.61.tar.bz2
cd libgpg-error-1.61
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

# https://mirrors.dotsrc.org/gcrypt/libgcrypt
wget https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.4.tar.bz2
tar -xjvf libgcrypt-1.12.4.tar.bz2
cd libgcrypt-1.12.4
./configure --disable-shared --prefix=$PREFIX --disable-avx2-support
make -j
make install
cd ..

# https://github.com/unicode-org/icu/releases
wget https://github.com/unicode-org/icu/releases/download/release-79.1/icu4c-79.1-sources.tgz
tar -xzf icu4c-79.1-sources.tgz
cd icu/source
env CXXFLAGS="-std=c++17 $CXXFLAGS" CFLAGS="-std=c11" \
  ./configure --enable-static --disable-shared --prefix=$PREFIX --enable-tests=no --enable-samples=no --enable-dyload=no --enable-release
make -j$(nproc)
make install
cd ../..

# https://mirrors.dotsrc.org/ftp.gnu.org/gnu/libiconv
# wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.19.1.tar.gz
wget https://mirrors.dotsrc.org/ftp.gnu.org/gnu/libiconv/libiconv-1.19.1.tar.gz
tar -xzf libiconv-1.19.1.tar.gz
cd libiconv-1.19.1
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

# https://download.gnome.org/sources/libxml2
wget https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.4.tar.xz
tar -xvf libxml2-2.15.4.tar.xz
cd libxml2-2.15.4
./configure --enable-static --disable-shared --prefix=$PREFIX --with-python=no --with-iconv --with-xpath
make -j
make install
# ln -sn /usr/include/libxml2/libxml /usr/include/libxml
cd ..

# https://download.gnome.org/sources/libxslt
wget https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.45.tar.xz
tar -xf libxslt-1.1.45.tar.xz
cd libxslt-1.1.45
./configure --enable-static --disable-shared --prefix=$PREFIX --with-python=no \
  --with-libxml-src=$(pwd)/../libxml2-2.15.4
make -j
make install
cd ..

# libgd

# wget https://download.sourceforge.net/libpng/libpng-1.6.59.tar.gz
# tar -xzf libpng-1.6.59.tar.gz
# cd libpng-1.6.59
# ./configure --disable-shared --prefix=$PREFIX
# make -j
# make install
# cd ..

# wget https://download.savannah.gnu.org/releases/freetype/freetype-2.15.0.tar.gz
# tar -xzf freetype-2.15.0.tar.gz
# cd freetype-2.15.0
# ./configure --disable-shared --prefix=$PREFIX
# make -j
# make install
# cd ..

# wget https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/3.2.1.tar.gz
# tar -xzf 3.2.1.tar.gz
# cd libjpeg-turbo-3.2.1
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -DENABLE_STATIC=on -DENABLE_SHARED=off ..
# make -j
# make install
# cd ../..

# https://github.com/webmproject/libwebp/tags
wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.6.0.tar.gz
tar -xzf libwebp-1.6.0.tar.gz
cd libwebp-1.6.0
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

# wget https://github.com/strukturag/libheif/releases/download/v1.23.7/libheif-1.23.7.tar.gz
# tar -xzf libheif-1.23.7.tar.gz
# cd libheif-1.23.7
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -DENABLE_STATIC=on -DENABLE_SHARED=off ..
# make -j
# make install
# cd ../..

# wget https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.4.2.tar.gz
# tar -xzf v1.4.2.tar.gz
# cd libavif-1.4.2
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -DENABLE_STATIC=on -DENABLE_SHARED=off ..
# make -j
# make install
# cd ../..

# wget https://gitlab.freedesktop.org/api/v4/projects/890/packages/generic/fontconfig/2.18.4/fontconfig-2.18.4.tar.xz
# tar -xJf fontconfig-2.18.4.tar.xz
# cd fontconfig-2.18.4
# ./configure --disable-shared --prefix=$PREFIX --enable-libxml2 --with-add-fonts=/usr/share/fonts,/usr/local/share/fonts
# make -j
# make install
# cd ..

# wget https://download.osgeo.org/libtiff/tiff-4.7.2.tar.gz
# tar -xzf tiff-4.7.2.tar.gz
# cd tiff-4.7.2
# ./configure --disable-shared --prefix=$PREFIX
# make -j
# make install
# cd ..

# https://github.com/libgd/libgd/releases
wget https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.gz
tar -xzf libgd-2.3.3.tar.gz
cd libgd-2.3.3
./configure --enable-static --disable-shared --prefix=$PREFIX \
  --with-freetype=no --with-jpeg=no --with-png=no --with-webp --with-zlib \
  --with-heif=no --with-avif=no --with-tiff=no --with-fontconfig=no
# ./configure --disable-shared --prefix=$PREFIX \
#   --with-freetype --with-jpeg --with-png --with-webp --with-zlib \
#   --with-heif --with-avif --with-tiff --with-fontconfig
if ! grep -q '^#define HAVE_LIBWEBP 1$' src/config.h; then
  echo "GD was configured without WebP support" >&2
  exit 1
fi
make -j
make install
cd ..

# libgeoip
git clone https://github.com/maxmind/geoip-api-c
cd geoip-api-c
./bootstrap
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

# https://github.com/besser82/libxcrypt/releases
wget https://github.com/besser82/libxcrypt/releases/download/v4.5.2/libxcrypt-4.5.2.tar.xz
tar -xf libxcrypt-4.5.2.tar.xz
cd libxcrypt-4.5.2
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

cd ..
