#!/bin/bash

# set -x CC clang-16
# set -x CXX clang++-16
# set -x PREFIX /usr
# set -x PKG_CONFIG "pkg-config --static"

mkdir deps
cd deps

export CXX=clang++-16
export CC=clang-16
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

wget https://tukaani.org/xz/xz-5.4.5.tar.gz
tar -xzvf xz-5.4.5.tar.gz
cd xz-5.4.5
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

git clone --recursive https://github.com/google/brotli --depth=1
git clone --recursive https://github.com/facebook/zstd --depth=1

cd zstd
env LDFLAGS="-fPIC" make -j lib-mt install
rm /usr/lib/libzstd.so*
cd ..

cd brotli
mkdir out && cd out
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DBUILD_SHARED_LIBS=off ..
make -j
make install
cd ../..

wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.tar.gz
tar -xzvf util-linux-2.39.tar.gz
cd util-linux-2.39
./configure --disable-all-programs --disable-shared --enable-libuuid --prefix=$PREFIX
make -j
make install
cd ..

# wget https://github.com/harfbuzz/harfbuzz/releases/download/5.3.1/harfbuzz-5.3.1.tar.xz
# tar -xvf harfbuzz-5.3.1.tar.xz
# cd harfbuzz-5.3.1
# ./configure --disable-shared --prefix=$PREFIX --with-glib=no --with-icu=no --with-graphite2=no --with-freetype=yes --with-fontconfig=yes
# make -j
# make install
# cd ..

# libmaxminddb
wget https://github.com/maxmind/libmaxminddb/releases/download/1.9.1/libmaxminddb-1.9.1.tar.gz
tar -xzvf libmaxminddb-1.9.1.tar.gz
cd libmaxminddb-1.9.1
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

# libxslt

wget https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.47.tar.bz2
tar -xjvf libgpg-error-1.47.tar.bz2
cd libgpg-error-1.47
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

wget https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.3.tar.bz2
tar -xjvf libgcrypt-1.10.3.tar.bz2
cd libgcrypt-1.10.3
./configure --disable-shared --prefix=$PREFIX --disable-avx2-support
make -j
make install
cd ..

wget https://github.com/unicode-org/icu/releases/download/release-74-1/icu4c-74_1-src.tgz
tar -xzvf icu4c-74_1-src.tgz
cd icu/source
env CXXFLAGS="-std=c++11 $CXXFLAGS"\
  ./configure --enable-static --disable-shared --prefix=$PREFIX --enable-tests=no --enable-samples=no --enable-dyload=no --enable-release
make -j$(nproc)
make install
cd ../..

wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz
tar -xzvf libiconv-1.17.tar.gz
cd libiconv-1.17
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

wget https://download.gnome.org/sources/libxml2/2.12/libxml2-2.12.3.tar.xz
tar -xvf libxml2-2.12.3.tar.xz
cd libxml2-2.12.3
./configure --enable-static --disable-shared --prefix=$PREFIX --with-python=no --with-iconv --with-xpath
make -j
make install
ln -sn /usr/include/libxml2/libxml /usr/include/libxml
cd ..

wget https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.39.tar.xz
tar -xf libxslt-1.1.39.tar.xz
cd libxslt-1.1.39
./configure --disable-shared --prefix=$PREFIX --with-python=no
make -j
make install
cd ..

# libgd

# wget https://download.sourceforge.net/libpng/libpng-1.6.38.tar.gz
# tar -xzvf libpng-1.6.38.tar.gz
# cd libpng-1.6.38
# ./configure --disable-shared --prefix=$PREFIX
# make -j
# make install
# cd ..

# wget https://download.savannah.gnu.org/releases/freetype/freetype-2.12.1.tar.gz
# tar -xzvf freetype-2.12.1.tar.gz
# cd freetype-2.12.1
# ./configure --disable-shared --prefix=$PREFIX
# make -j
# make install
# cd ..

# wget https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/2.1.4.tar.gz
# tar -xzvf 2.1.4.tar.gz
# cd libjpeg-turbo-2.1.4
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -DENABLE_STATIC=on -DENABLE_SHARED=off ..
# make -j
# make install
# cd ../..

wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.2.tar.gz
tar -xzvf libwebp-1.3.2.tar.gz
cd libwebp-1.3.2
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -DENABLE_STATIC=on -DENABLE_SHARED=off ..
make -j
make install
cd ../..

# wget https://github.com/strukturag/libheif/releases/download/v1.13.0/libheif-1.13.0.tar.gz
# tar -xzvf libheif-1.13.0.tar.gz
# cd libheif-1.13.0
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -DENABLE_STATIC=on -DENABLE_SHARED=off ..
# make -j
# make install
# cd ../..

# wget https://github.com/AOMediaCodec/libavif/archive/refs/tags/v0.11.1.tar.gz
# tar -xzvf v0.11.1.tar.gz
# cd libavif-0.11.1
# mkdir build
# cd build
# cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -DENABLE_STATIC=on -DENABLE_SHARED=off ..
# make -j
# make install
# cd ../..

# wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.1.tar.gz
# tar -xzvf fontconfig-2.14.1.tar.gz
# cd fontconfig-2.14.1
# ./configure --disable-shared --prefix=$PREFIX --enable-libxml2 --with-add-fonts=/usr/share/fonts,/usr/local/share/fonts
# make -j
# make install
# cd ..

# wget https://download.osgeo.org/libtiff/tiff-4.4.0.tar.gz
# tar -xzvf tiff-4.4.0.tar.gz
# cd tiff-4.4.0
# ./configure --disable-shared --prefix=$PREFIX
# make -j
# make install
# cd ..


wget https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.gz
tar -xzvf libgd-2.3.3.tar.gz
cd libgd-2.3.3
./configure --disable-shared --prefix=$PREFIX \
  --with-freetype=no --with-jpeg=no --with-png=no --with-webp --with-zlib \
  --with-heif=no --with-avif=no --with-tiff=no --with-fontconfig=no
# ./configure --disable-shared --prefix=$PREFIX \
#   --with-freetype --with-jpeg --with-png --with-webp --with-zlib \
#   --with-heif --with-avif --with-tiff --with-fontconfig
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

# libxcrypt
wget https://github.com/besser82/libxcrypt/releases/download/v4.4.36/libxcrypt-4.4.36.tar.xz
tar -xf libxcrypt-4.4.36.tar.xz
cd libxcrypt-4.4.36
./configure --disable-shared --prefix=$PREFIX
make -j
make install
cd ..

cd ..
