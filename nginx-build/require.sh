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
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
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
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-balancer_pool_max_retry.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-balancer_status_code.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-cache_manager_exit.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-daemon_destroy_pool.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-delayed_posted_events.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-hash_overflow.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-init_cycle_pool_release.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-no_error_pages.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-privileged_agent_process.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-privileged_agent_process_connections.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-privileged_agent_process_thread_pool.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-proc_exit_handler.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-proxy_host_port_vars.patch)
# https://github.com/openresty/lua-nginx-module/issues/2443
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-quic_ssl_lua_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-reuseport_close_unused_fds.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-safe_resolver_ipv6_option.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-single_process_graceful_exit.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-socket_cloexec.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-ssl_cert_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-ssl_sess_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-ssl_client_hello_cb_yield.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-proxy_ssl_verify_cb_yield.patch)

patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-stream_balancer_export.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-stream_proxy_get_next_upstream_tries.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-stream_proxy_timeout_fields.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-stream_proxy_protocol_v2.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-stream_ssl_preread_no_skip.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-upstream_pipelining.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/openresty/openresty/master/patches/nginx/1.31.0/nginx-1.31.0-upstream_timeout_fields.patch)
# patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/nginx-stream-proxy-protocol-v2/main/stream-proxy-protocol-v2-release-1.27.0.patch)
# kn007's patches
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/refs/heads/master/nginx_dynamic_tls_records.patch)
patch -p1 <<< $(wget -qO- https://raw.githubusercontent.com/kn007/patch/master/use_openssl_md5_sha1.patch)
cd ..
# dirname: nginx-${nginx_version}
