#!/bin/sh
. ./config.sh

export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

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
tar zxf v${echo_nginx_module_version}.tar.gz
# dirname: echo-nginx-module-${echo_nginx_module_version}

# headers-more-nginx-module
wget https://github.com/openresty/headers-more-nginx-module/archive/v${headers_more_nginx_module_version}.tar.gz
tar zxf v${headers_more_nginx_module_version}.tar.gz
# dirname: headers-more-nginx-module-${headers_more_nginx_module_version}

# lua-nginx-module
wget https://github.com/openresty/lua-nginx-module/archive/v${lua_nginx_module_version}.tar.gz
tar zxf v${lua_nginx_module_version}.tar.gz
# dirname: lua-nginx-module-${lua_nginx_module_version}

# ngx_devel_kit
wget https://github.com/simplresty/ngx_devel_kit/archive/v${ngx_devel_kit_version}.tar.gz
tar zxf v${ngx_devel_kit_version}.tar.gz
# dirname: ngx_devel_kit-${ngx_devel_kit_version}

# ngx-fancyindex
wget https://github.com/aperezdc/ngx-fancyindex/archive/v${fancyindex_version}.tar.gz
tar zxf v${fancyindex_version}.tar.gz
# dirname: ngx-fancyindex-${fancyindex_version}

# nginx-rtmp-module
wget https://github.com/arut/nginx-rtmp-module/archive/v${rtmp_module_version}.tar.gz
tar zxf v${rtmp_module_version}.tar.gz
# dirname: nginx-rtmp-module-${rtmp_module_version}

# nchan
wget https://github.com/slact/nchan/archive/v${nchan_version}.tar.gz
tar zxf v${nchan_version}.tar.gz
# dirname: nchan-${nchan_version}

# ngx_http_substitutions_filter_module
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
cd ngx_http_substitutions_filter_module
git checkout b8a71eacc7f986ba091282ab8b1bbbc6ae1807e0
# merged
# wget https://github.com/yaoweibin/ngx_http_substitutions_filter_module/pull/19.patch
# patch -p1 < 19.patch
cd ..
# dirname: ngx_http_substitutions_filter_module

# nginx-upload-progress-module
git clone --depth=1 https://github.com/masterzen/nginx-upload-progress-module
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
git clone --depth=1 https://github.com/sto/ngx_http_auth_pam_module
# dirname: ngx_http_auth_pam_module

# nginx-dav-ext-module
git clone --depth=1 https://github.com/arut/nginx-dav-ext-module
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
git clone --depth=1 https://github.com/google/ngx_brotli.git
# git clone --depth=1 https://github.com/eustas/ngx_brotli.git
cd ngx_brotli && git submodule update --init && cd ..
# dirname: ngx_brotli

# pagespeed-ngx
wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${pagespeed_ngx_version}.zip
unzip v${pagespeed_ngx_version}.zip
nps_dir=$(find . -name "*pagespeed-ngx-${pagespeed_ngx_version}" -type d)
cd "$nps_dir"
psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
wget ${psol_url}
tar -zxf $(basename ${psol_url})
rm $(basename ${psol_url})
cd ..
# dirname: ${nps_dir}

# pcre
wget https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.zip
unzip pcre-${pcre_version}.zip
# dirname: pcre-${pcre_version}

# zlib-cf
git clone https://github.com/cloudflare/zlib.git zlib-cf
cd zlib-cf
make -f Makefile.in distclean
cd ..

# nginx
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar zxf nginx-${nginx_version}.tar.gz
cd nginx-${nginx_version}
#wget -L https://raw.githubusercontent.com/nginx-modules/ngx_http_tls_dyn_size/0.4/nginx__dynamic_tls_records_1.15.5%2B.patch -O dynamic_tls_records.patch
#patch -p1 < dynamic_tls_records.patch
wget -L https://raw.githubusercontent.com/kn007/patch/master/nginx_with_quic.patch
patch -p1 < nginx_with_quic.patch
wget -L https://raw.githubusercontent.com/kn007/patch/master/Enable_BoringSSL_OCSP.patch
patch -p1 < Enable_BoringSSL_OCSP.patch
cd ..
# dirname: nginx-${nginx_version}

# quiche
git clone --recursive --depth=1 https://github.com/cloudflare/quiche

# libatomic_ops
wget -O libatomic_ops-${libatomic_ops_version}.tar.gz https://github.com/ivmai/libatomic_ops/releases/download/v${libatomic_ops_version}/libatomic_ops-${libatomic_ops_version}.tar.gz
tar -xzvf libatomic_ops-${libatomic_ops_version}.tar.gz
rm libatomic_ops-${libatomic_ops_version}.tar.gz

# luajit
# https://hub.docker.com/r/ekho/nginx-lua/dockerfile
wget -O luajit2-${luajit2_version}.tar.gz https://github.com/openresty/luajit2/archive/v${luajit2_version}.tar.gz
tar -xzvf luajit2-${luajit2_version}.tar.gz
cd luajit2-${luajit2_version}
make -j$(getconf _NPROCESSORS_ONLN) CFLAGS='-static -static-libgcc -static-libstdc++ -fPIC'
cd src
ln -s libluajit.so libluajit-5.1.so
cd ..
cd ..
# dirname: luajit2-${luajit2_version}

# jemalloc
wget -O jemalloc-${jemalloc_version}.tar.bz2 https://github.com/jemalloc/jemalloc/releases/download/${jemalloc_version}/jemalloc-${jemalloc_version}.tar.bz2
tar -xvf jemalloc-${jemalloc_version}.tar.bz2
rm jemalloc-${jemalloc_version}.tar.bz2
cd jemalloc-${jemalloc_version}
./configure --enable-static
make -j$(getconf _NPROCESSORS_ONLN)
cd ..

# boringssl with tls1.3
# thanks to https://github.com/nginx-modules/docker-nginx-boringssl/blob/master/mainline/alpine/Dockerfile#L108
git clone --depth=1 https://boringssl.googlesource.com/boringssl
sed -i 's@out \([>=]\) TLS1_2_VERSION@out \1 TLS1_3_VERSION@' boringssl/ssl/ssl_lib.cc
sed -i 's@ssl->version[ ]*=[ ]*TLS1_2_VERSION@ssl->version = TLS1_3_VERSION@' boringssl/ssl/s3_lib.cc
sed -i 's@(SSL3_VERSION, TLS1_2_VERSION@(SSL3_VERSION, TLS1_3_VERSION@' boringssl/ssl/ssl_test.cc
sed -i 's@\$shaext[ ]*=[ ]*0;@\$shaext = 1;@' boringssl/crypto/*/asm/*.pl
sed -i 's@\$avx[ ]*=[ ]*[0|1];@\$avx = 2;@' boringssl/crypto/*/asm/*.pl
sed -i 's@\$addx[ ]*=[ ]*0;@\$addx = 1;@' boringssl/crypto/*/asm/*.pl
mkdir -p boringssl/build boringssl/.openssl/lib boringssl/.openssl/include
ln -sf `pwd`/boringssl/include/openssl boringssl/.openssl/include/openssl
touch boringssl/.openssl/include/openssl/ssl.h
cmake -B`pwd`/boringssl/build -H`pwd`/boringssl
make -C`pwd`/boringssl/build -j$(getconf _NPROCESSORS_ONLN)
cp boringssl/build/crypto/libcrypto.a boringssl/build/ssl/libssl.a boringssl/.openssl/lib/

rm *.zip *.gz
