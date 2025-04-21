#!/bin/bash
. ./config.sh
. ../nginx-base/require-base.sh

export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

# nginx
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar zxf nginx-${nginx_version}.tar.gz
rm -rf nginx-${nginx_version}.tar.gz
# freenginx
# wget http://freenginx.org/download/freenginx-${nginx_version}.tar.gz
# tar zxf freenginx-${nginx_version}.tar.gz
# mv freenginx-${nginx_version} nginx-${nginx_version}
# rm -rf freenginx-${nginx_version}.tar.gz
cd nginx-${nginx_version}
# huihui's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/nginx-stream-proxy-protocol-v2/main/stream-proxy-protocol-v2-release-1.27.0.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-disable-http-to-https.patch)
# https://openresty.org/en/nginx-ssl-patches.html
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-single_process_graceful_exit.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-socket_cloexec.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-ssl_cert_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-ssl_sess_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx-1.27.0-ssl_client_hello_cb_yield.patch)
# kn007's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/refs/heads/master/nginx_dynamic_tls_records.patch)
# patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/master/Enable_BoringSSL_OCSP.patch)
cd ..

# boringssl with tls1.3
# thanks to https://github.com/nginx-modules/docker-nginx-boringssl/blob/main/mainline-alpine.Dockerfile#L111
# git clone https://boringssl.googlesource.com/boringssl
# cd boringssl
# git checkout --force --quiet e648990
# cd ..
# https://trac.nginx.org/nginx/ticket/2605
git clone https://boringssl.googlesource.com/boringssl --depth=1 -b chromium-stable
grep -qxF 'SET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' boringssl/crypto/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' >> boringssl/crypto/CMakeLists.txt
grep -qxF 'SET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' boringssl/ssl/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' >> boringssl/ssl/CMakeLists.txt
mkdir -p boringssl/build boringssl/.openssl/lib boringssl/.openssl/include
ln -sf `pwd`/boringssl/include/openssl boringssl/.openssl/include/openssl
touch boringssl/.openssl/include/openssl/ssl.h
cmake -B`pwd`/boringssl/build -H`pwd`/boringssl \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations -O3"
make -C`pwd`/boringssl/build -j$(getconf _NPROCESSORS_ONLN)
cp boringssl/build/crypto/libcrypto.a boringssl/build/ssl/libssl.a boringssl/.openssl/lib
