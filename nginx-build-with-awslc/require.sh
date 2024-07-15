#!/bin/bash
. ./config.sh
. ../nginx-base/require-base.sh

export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

# nginx
#wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
#tar zxf nginx-${nginx_version}.tar.gz
# freenginx
wget http://freenginx.org/download/freenginx-${nginx_version}.tar.gz
tar zxf freenginx-${nginx_version}.tar.gz
mv freenginx-${nginx_version} nginx-${nginx_version}
rm -rf freenginx-${nginx_version}.tar.gz
cd nginx-${nginx_version}
# huihui's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/nginx-stream-proxy-protocol-v2/main/stream-proxy-protocol-v2-release-1.27.0.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-disable-http-to-https.patch)
# https://openresty.org/en/nginx-ssl-patches.html
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-single_process_graceful_exit.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-socket_cloexec.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-ssl_cert_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-ssl_client_hello_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-ssl_sess_cb_yield.patch)
# kn007's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/master/nginx_dynamic_tls_records.patch)
cd ..


wget https://github.com/aws/aws-lc/archive/refs/tags/v${awslc_version}.tar.gz -O aws-lc.tar.gz
tar xfv aws-lc.tar.gz
mv aws-lc-${awslc_version} aws-lc
patch -d aws-lc -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-with-aws-lc.patch)

grep -qxF 'SET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' aws-lc/crypto/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' >> aws-lc/crypto/CMakeLists.txt
grep -qxF 'SET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' aws-lc/ssl/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' >> aws-lc/ssl/CMakeLists.txt
mkdir -p aws-lc/build aws-lc/.openssl/lib aws-lc/.openssl/include
ln -sf `pwd`/aws-lc/include/openssl aws-lc/.openssl/include/openssl
touch aws-lc/.openssl/include/openssl/ssl.h
cmake -B`pwd`/aws-lc/build -H`pwd`/aws-lc \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations" \
  -DBUILD_TESTING=OFF \
  -DBUILD_TOOL=OFF
make -C`pwd`/aws-lc/build -j$(getconf _NPROCESSORS_ONLN)
cp aws-lc/build/crypto/libcrypto.a aws-lc/build/ssl/libssl.a aws-lc/.openssl/lib
