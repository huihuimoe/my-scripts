#!/bin/bash
set -ex
. ./config.sh
. ../nginx-base/require-base.sh

export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

# openssl
# wget https://github.com/openssl/openssl/archive/refs/tags/openssl-${openssl_version}.tar.gz
wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
tar zxf openssl-${openssl_version}.tar.gz
rm -rf openssl-${openssl_version}.tar.gz
# mv openssl-openssl-${openssl_version} openssl-${openssl_version}

# https://nginx.org/en/docs/configure.html#http_v3_module
# wget -q https://github.com/quictls/openssl/archive/refs/tags/${quictls_version}.tar.gz
# tar zxf ${quictls_version}.tar.gz
# rm -rf ${quictls_version}.tar.gz
# mv openssl-openssl-* openssl-${quictls_version}
# dirname: openssl-${quictls_version}

# nginx
wget https://nginx.org/download/nginx-${nginx_version}.tar.gz
tar zxf nginx-${nginx_version}.tar.gz
rm -rf nginx-${nginx_version}.tar.gz
# freenginx
# wget http://freenginx.org/download/freenginx-${nginx_version}.tar.gz
# tar zxf freenginx-${nginx_version}.tar.gz
# rm -rf freenginx-${nginx_version}.tar.gz
# mv freenginx-${nginx_version} nginx-${nginx_version}  
cd nginx-${nginx_version}
# huihui's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-disable-http-to-https.patch)
# https://openresty.org/en/nginx-ssl-patches.html
for patch in "${openresty_patches[@]}"; do
  if [ -f "../patch/nginx-${nginx_version}-${patch}.patch" ]; then
    patch -p1 < "../patch/nginx-${nginx_version}-${patch}.patch"
  elif [ "$patch" = "socket_cloexec" ] && [ "$nginx_version" = "1.31.8" ]; then
    patch -p1 <<< "$(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-1.31.8-socket_cloexec.patch)"
  else
    patch -p1 <<< "$(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/${openresty_version}/nginx-${openresty_version}-${patch}.patch)"
  fi
done
# kn007's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/refs/heads/master/nginx_dynamic_tls_records.patch)
# patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/master/use_openssl_md5_sha1.patch)
cd ..
# dirname: nginx-${nginx_version}
