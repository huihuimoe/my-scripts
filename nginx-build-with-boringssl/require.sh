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
# 
# https://raw.githubusercontent.com/openresty/openresty/refs/heads/master/patches/nginx/1.27.1/nginx-1.27.1-stream_proxy_protocol_v2.patch
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/nginx-stream-proxy-protocol-v2/main/stream-proxy-protocol-v2-release-1.27.0.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-disable-http-to-https.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-with-boringssl_nginx.patch)
# https://openresty.org/en/nginx-ssl-patches.html
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.27.1/nginx-1.27.1-single_process_graceful_exit.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.27.1/nginx-1.27.1-socket_cloexec.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.27.1/nginx-1.27.1-ssl_cert_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.27.1/nginx-1.27.1-ssl_sess_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.27.1/nginx-1.27.1-ssl_client_hello_cb_yield.patch)
# https://github.com/openresty/lua-nginx-module/issues/2443
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.27.1/nginx-1.27.1-quic_ssl_lua_yield.patch)
# kn007's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/refs/heads/master/nginx_dynamic_tls_records.patch)
# patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/master/Enable_BoringSSL_OCSP.patch)
cd ..

# https://trac.nginx.org/nginx/ticket/2605

# The `chromium-stable` branch is no longer being updated. Historically, this
# branch pointed to, though lagged behind, the revision of BoringSSL that the
# current latest stable release of Chromium used. It was used by projects that
# wanted some slower-moving branch to follow than `HEAD`.

# BoringSSL now tags periodic releases that can be used instead. See the tags of
# the form `0.YYYYMMDD.N`.

git clone https://boringssl.googlesource.com/boringssl --depth=1 -b $boringssl_version
mkdir -p boringssl/build boringssl/.openssl/lib boringssl/.openssl/include
ln -sf $(pwd)/boringssl/include/openssl boringssl/.openssl/include/openssl
touch boringssl/.openssl/include/openssl/ssl.h
cmake -B$(pwd)/boringssl/build -H$(pwd)/boringssl \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations -O3"
make -C$(pwd)/boringssl/build -j$(getconf _NPROCESSORS_ONLN)
cp boringssl/build/libcrypto.a boringssl/build/libssl.a boringssl/.openssl/lib
