#!/bin/bash
set -ex
. ./config.sh
. ../nginx-base/require-base.sh

export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

# awslc
wget https://github.com/aws/aws-lc/archive/refs/tags/v${awslc_version}.tar.gz -qO aws-lc.tar.gz
tar xf aws-lc.tar.gz
mv aws-lc-${awslc_version} aws-lc
patch -d aws-lc -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-with-awslc_awslc.patch)
# patch -d aws-lc -p1 < ../patch/nginx-with-awslc_awslc.patch

grep -qxF 'SET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' aws-lc/crypto/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' >> aws-lc/crypto/CMakeLists.txt
grep -qxF 'SET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' aws-lc/ssl/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' >> aws-lc/ssl/CMakeLists.txt
mkdir -p aws-lc/build aws-lc/.openssl/lib aws-lc/.openssl/include
ln -sf `pwd`/aws-lc/include/openssl aws-lc/.openssl/include/openssl
touch aws-lc/.openssl/include/openssl/ssl.h
cmake -B`pwd`/aws-lc/build -H`pwd`/aws-lc \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations -O3" \
  -DBUILD_TESTING=OFF \
  -DBUILD_TOOL=OFF
make -C`pwd`/aws-lc/build -j$(getconf _NPROCESSORS_ONLN)
cp aws-lc/build/crypto/libcrypto.a aws-lc/build/ssl/libssl.a aws-lc/.openssl/lib

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
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-disable-http-to-https.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-with-awslc_nginx.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/nginx-with-boringssl_nginx.patch)
# awslc patch
# patch -p1 < ../aws-lc/tests/ci/integration/nginx_patch/aws-lc-nginx.patch
# https://openresty.org/en/nginx-ssl-patches.html
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-balancer_pool_max_retry.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-balancer_status_code.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-cache_manager_exit.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-daemon_destroy_pool.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-delayed_posted_events.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-hash_overflow.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-init_cycle_pool_release.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-no_error_pages.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-privileged_agent_process.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-privileged_agent_process_connections.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-privileged_agent_process_thread_pool.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-proc_exit_handler.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-proxy_host_port_vars.patch)
# https://github.com/openresty/lua-nginx-module/issues/2443
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-quic_ssl_lua_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-reuseport_close_unused_fds.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-safe_resolver_ipv6_option.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-single_process_graceful_exit.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-socket_cloexec.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-ssl_cert_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-ssl_sess_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-ssl_client_hello_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-proxy_ssl_verify_cb_yield.patch)

patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-stream_balancer_export.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-stream_proxy_get_next_upstream_tries.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-stream_proxy_timeout_fields.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-stream_proxy_protocol_v2.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-stream_ssl_preread_no_skip.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-upstream_pipelining.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.29.2/nginx-1.29.2-upstream_timeout_fields.patch)
# fix SSL_get0_peer_certificate new api in openresty's proxy-protocol-v2 patch (use old SSL_get_peer_certificate)
sed -i 's|SSL_get0_peer_certificate|SSL_get_peer_certificate|g' src/core/ngx_proxy_protocol.c

# patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/nginx-stream-proxy-protocol-v2/main/stream-proxy-protocol-v2-release-1.27.0.patch)
# kn007's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/refs/heads/master/nginx_dynamic_tls_records.patch)
cd ..
