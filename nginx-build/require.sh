#!/bin/sh
. ./config.sh

# stream-lua-nginx-module
wget -O stream-lua-nginx-module-${stream_lua_nginx_module_version}.tar.gz https://github.com/openresty/stream-lua-nginx-module/archive/v${stream_lua_nginx_module_version}.tar.gz
tar -xzvf stream-lua-nginx-module-${stream_lua_nginx_module_version}.tar.gz
# dirname: stream-lua-nginx-module-${stream_lua_nginx_module_version}

# stream-lua-nginx-module
wget -O lua-resty-lrucache-${nginx_lua_resty_lrucache_version}.tar.gz https://github.com/openresty/lua-resty-lrucache/archive/v${nginx_lua_resty_lrucache_version}.tar.gz
tar -xzvf lua-resty-lrucache-${nginx_lua_resty_lrucache_version}.tar.gz
# dirname: lua-resty-lrucache-${nginx_lua_resty_lrucache_version}

# stream-lua-nginx-module
wget -O lua-resty-core-${nginx_lua_resty_core_version}.tar.gz https://github.com/openresty/lua-resty-core/archive/v${nginx_lua_resty_core_version}.tar.gz
tar -xzvf lua-resty-core-${nginx_lua_resty_core_version}.tar.gz
# dirname: lua-resty-core-${nginx_lua_resty_core_version}

# lua-nginx-split-clients
wget -O lua-nginx-split-clients-${nginx_lua_split_clients_version}.tar.gz https://github.com/ekho/lua-nginx-split-clients/archive/v${nginx_lua_split_clients_version}.tar.gz
tar -xzvf lua-nginx-split-clients-${nginx_lua_split_clients_version}.tar.gz
# dirname: lua-nginx-split-clients-${nginx_lua_split_clients_version}

# ngx_http_geoip2_module
wget -O ngx_http_geoip2_module-${ngx_http_geoip2_module_version}.tar.gz https://github.com/leev/ngx_http_geoip2_module/archive/${ngx_http_geoip2_module_version}.tar.gz
tar -xzvf ngx_http_geoip2_module-${ngx_http_geoip2_module_version}.tar.gz
# dirname: ngx_http_geoip2_module-${ngx_http_geoip2_module_version}

# echo-nginx-module
wget https://github.com/openresty/echo-nginx-module/archive/v${echo_nginx_module_version}.tar.gz
tar zxf v${echo_nginx_module_version}.tar.gz && rm v${echo_nginx_module_version}.tar.gz
# dirname: echo-nginx-module-${echo_nginx_module_version}

# headers-more-nginx-module
wget https://github.com/openresty/headers-more-nginx-module/archive/v${headers_more_nginx_module_version}.tar.gz
tar zxf v${headers_more_nginx_module_version}.tar.gz && rm v${headers_more_nginx_module_version}.tar.gz
# dirname: headers-more-nginx-module-${headers_more_nginx_module_version}

# lua-nginx-module
wget https://github.com/openresty/lua-nginx-module/archive/v${lua_nginx_module_version}.tar.gz
tar zxf v${lua_nginx_module_version}.tar.gz && rm v${lua_nginx_module_version}.tar.gz
# dirname: lua-nginx-module-${lua_nginx_module_version}

# ngx_devel_kit
wget https://github.com/simplresty/ngx_devel_kit/archive/v${ngx_devel_kit_version}.tar.gz
tar zxf v${ngx_devel_kit_version}.tar.gz && rm v${ngx_devel_kit_version}.tar.gz
# dirname: ngx_devel_kit-${ngx_devel_kit_version}

# ngx-fancyindex
wget https://github.com/aperezdc/ngx-fancyindex/archive/v${fancyindex_version}.tar.gz
tar zxf v${fancyindex_version}.tar.gz && rm v${fancyindex_version}.tar.gz
# dirname: ngx-fancyindex-${fancyindex_version}

# nginx-rtmp-module
wget https://github.com/arut/nginx-rtmp-module/archive/v${rtmp_module_version}.tar.gz
tar zxf v${rtmp_module_version}.tar.gz && rm v${rtmp_module_version}.tar.gz
# dirname: nginx-rtmp-module-${rtmp_module_version}

# nchan
wget https://github.com/slact/nchan/archive/v${nchan_version}.tar.gz
tar zxf v${nchan_version}.tar.gz && rm v${nchan_version}.tar.gz
# dirname: nchan-${nchan_version}

# ngx_http_substitutions_filter_module
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
cd ngx_http_substitutions_filter_module
git checkout bc58cb11844bc42735bbaef7085ea86ace46d05b
wget https://github.com/yaoweibin/ngx_http_substitutions_filter_module/pull/19.patch
patch -p1 < 19.patch
cd ..
# dirname: ngx_http_substitutions_filter_module

# nginx-upload-progress-module
git clone https://github.com/masterzen/nginx-upload-progress-module
# dirname: nginx-upload-progress-module

# ngx_cache_purge
git clone https://github.com/FRiCKLE/ngx_cache_purge
cd ngx_cache_purge
git checkout 331fe43e8d9a3d1fa5e0c9fec7d3201d431a9177
wget https://github.com/FRiCKLE/ngx_cache_purge/pull/45.patch
wget https://github.com/FRiCKLE/ngx_cache_purge/pull/51.patch
patch -p1 < 45.patch
patch -p1 < 51.patch
cd ..
# dirname: ngx_cache_purge

# ngx_http_auth_pam_module
git clone https://github.com/sto/ngx_http_auth_pam_module
# dirname: ngx_http_auth_pam_module

# nginx-dav-ext-module
git clone https://github.com/arut/nginx-dav-ext-module
# dirname: nginx-dav-ext-module

# nginx-upstream-fair
git clone https://github.com/gnosek/nginx-upstream-fair
cd nginx-upstream-fair
git checkout a18b4099fbd458111983200e098b6f0c8efed4bc
wget https://github.com/gnosek/nginx-upstream-fair/pull/21.patch
wget https://github.com/gnosek/nginx-upstream-fair/pull/22.patch
wget https://github.com/gnosek/nginx-upstream-fair/pull/23.patch
patch -p1 < 21.patch
patch -p1 < 22.patch
patch -p1 < 23.patch
cd ..
# dirname: nginx-upstream-fair

# ngx_brotli
git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli && git submodule update --init && cd ..
# dirname: ngx_brotli

# pagespeed-ngx
wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${pagespeed_ngx_version}.zip
unzip v${pagespeed_ngx_version}.zip
rm v${pagespeed_ngx_version}.zip
nps_dir=$(find . -name "*pagespeed-ngx-${pagespeed_ngx_version}" -type d)
cd "$nps_dir"
psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
wget ${psol_url}
tar -zxf $(basename ${psol_url})
rm $(basename ${psol_url})
cd ..
# dirname: ${nps_dir}

# openssl
wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
tar zxf openssl-${openssl_version}.tar.gz && rm openssl-${openssl_version}.tar.gz
# dirname: openssl-${openssl_version}

# pcre
wget https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.zip
unzip pcre-${pcre_version}.zip && rm pcre-${pcre_version}.zip
# dirname: pcre-${pcre_version}

# nginx
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar zxf nginx-${nginx_version}.tar.gz && rm nginx-${nginx_version}.tar.gz
cd nginx-${nginx_version}
wget -L https://raw.githubusercontent.com/nginx-modules/ngx_http_tls_dyn_size/0.4/nginx__dynamic_tls_records_1.15.5%2B.patch -O dynamic_tls_records.patch
patch -p1 < dynamic_tls_records.patch
cd ..
# dirname: nginx-${nginx_version}

# luajit
wget -O luajit2-${luajit2_version}.tar.gz https://github.com/openresty/luajit2/archive/v${luajit2_version}.tar.gz
tar -xzvf luajit2-${luajit2_version}.tar.gz
cd luajit2-${luajit2_version}
make -j2
cd src
ln -s libluajit.so libluajit-5.1.so
cd ..
cd ..
# dirname: luajit2-${luajit2_version}
