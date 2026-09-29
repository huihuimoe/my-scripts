#!/bin/bash
nginx_version=1.31.6
# https://openresty.org/en/nginx-ssl-patches.html
openresty_version=1.31.6
openresty_patches=(
  balancer_pool_max_retry
  balancer_status_code
  cache_manager_exit
  daemon_destroy_pool
  delayed_posted_events
  hash_overflow
  init_cycle_pool_release
  no_error_pages
  privileged_agent_process
  privileged_agent_process_connections
  privileged_agent_process_thread_pool
  proc_exit_handler
  proxy_host_port_vars
  # https://github.com/openresty/lua-nginx-module/issues/2443
  quic_ssl_lua_yield
  reuseport_close_unused_fds
  safe_resolver_ipv6_option
  single_process_graceful_exit
  socket_cloexec
  ssl_cert_cb_yield
  ssl_sess_cb_yield
  ssl_client_hello_cb_yield
  proxy_ssl_verify_cb_yield
  stream_balancer_export
  stream_proxy_get_next_upstream_tries
  stream_proxy_timeout_fields
  stream_ssl_preread_no_skip
  upstream_pipelining
  upstream_timeout_fields
  upstream_ssl_session_cleanup
  http2_subreq_error_wakeup
  initialize_quic_transport_id_variable
  larger_max_error_str
  log_escape_non_ascii
)
# https://github.com/nginx/njs
njs_version=1.0.1
# not really compatible the latest version
# https://github.com/quickjs-ng/quickjs/releases
# quickjs_ng_version=0.11.0
# https://github.com/openresty/echo-nginx-module/tags
echo_nginx_module_version=0.65
# https://github.com/openresty/headers-more-nginx-module/tags
headers_more_nginx_module_version=0.40
# https://github.com/openresty/lua-nginx-module/tags
lua_nginx_module_version=0.10.32rc5
# https://github.com/vision5/ngx_devel_kit/tags
ngx_devel_kit_version=0.3.4
# https://github.com/aperezdc/ngx-fancyindex/tags
fancyindex_version=0.6.0
# https://github.com/arut/nginx-rtmp-module/tags
rtmp_module_version=1.2.2
# https://github.com/slact/nchan/tags
# nchan_version=1.3.6

# https://sourceforge.net/projects/pcre/files/pcre/
# pcre_version=8.45
# https://github.com/PCRE2Project/pcre2/releases
pcre2_version=10.49
clang_version=21

# https://github.com/openresty/luajit2/tags
luajit2_version=2.1-20260914
# https://github.com/openresty/stream-lua-nginx-module/tags
stream_lua_nginx_module_version=0.0.20rc3
# https://github.com/leev/ngx_http_geoip2_module/tags
ngx_http_geoip2_module_version=3.4
# https://github.com/openresty/lua-resty-core/tags
nginx_lua_resty_core_version=0.1.35rc1
# https://github.com/openresty/lua-resty-lrucache/tags
nginx_lua_resty_lrucache_version=0.15
# https://github.com/ekho/lua-nginx-split-clients/tags
# nginx_lua_split_clients_version=0.0.2
# https://github.com/facebook/jemalloc
# https://github.com/jemalloc/jemalloc/tags
# https://github.com/jemalloc/jemalloc/issues/2060
jemalloc_version=5.4.0
# jemalloc_version=6cc4217
# https://github.com/ivmai/libatomic_ops/tags
libatomic_ops_version=7.10.0
