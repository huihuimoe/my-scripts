#!/bin/bash
. ./config.sh

export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

# stream-lua-nginx-module
wget -O stream-lua-nginx-module-${stream_lua_nginx_module_version}.tar.gz https://github.com/openresty/stream-lua-nginx-module/archive/v${stream_lua_nginx_module_version}.tar.gz
tar -xzf stream-lua-nginx-module-${stream_lua_nginx_module_version}.tar.gz
# revert change in pr #344 (not change in freenginx)
# https://github.com/openresty/stream-lua-nginx-module/pull/344
patch -d stream-lua-nginx-module-${stream_lua_nginx_module_version} -R -p1 \
  <<< $(wget -qO- https://raw.githubusercontent.com/huihuimoe/my-scripts/master/patch/stream-lua-nginx-module-pr344.patch)
# dirname: stream-lua-nginx-module-${stream_lua_nginx_module_version}

wget -O lua-resty-lrucache-${nginx_lua_resty_lrucache_version}.tar.gz https://github.com/openresty/lua-resty-lrucache/archive/v${nginx_lua_resty_lrucache_version}.tar.gz
tar -xzf lua-resty-lrucache-${nginx_lua_resty_lrucache_version}.tar.gz
# dirname: lua-resty-lrucache-${nginx_lua_resty_lrucache_version}

wget -O lua-resty-core-${nginx_lua_resty_core_version}.tar.gz https://github.com/openresty/lua-resty-core/archive/v${nginx_lua_resty_core_version}.tar.gz
tar -xzf lua-resty-core-${nginx_lua_resty_core_version}.tar.gz
# dirname: lua-resty-core-${nginx_lua_resty_core_version}

# lua-nginx-split-clients
wget -O lua-nginx-split-clients-${nginx_lua_split_clients_version}.tar.gz https://github.com/ekho/lua-nginx-split-clients/archive/v${nginx_lua_split_clients_version}.tar.gz
tar -xzf lua-nginx-split-clients-${nginx_lua_split_clients_version}.tar.gz
# dirname: lua-nginx-split-clients-${nginx_lua_split_clients_version}

git clone --depth=1 https://github.com/openresty/lua-upstream-nginx-module
git clone --depth=1 https://github.com/openresty/set-misc-nginx-module

# ngx_http_geoip2_module
wget -O ngx_http_geoip2_module-${ngx_http_geoip2_module_version}.tar.gz https://github.com/leev/ngx_http_geoip2_module/archive/${ngx_http_geoip2_module_version}.tar.gz
tar -xzf ngx_http_geoip2_module-${ngx_http_geoip2_module_version}.tar.gz
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
# wget https://github.com/openresty/lua-nginx-module/archive/v${lua_nginx_module_version}.tar.gz
# tar zxf v${lua_nginx_module_version}.tar.gz
# FIXME: temp fix
git clone --depth=1 https://github.com/openresty/lua-nginx-module.git lua-nginx-module-${lua_nginx_module_version}
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
mv nginx-rtmp-module-${rtmp_module_version} nginx-rtmp-module
# dirname: nginx-rtmp-module

# nchan
# wget https://github.com/slact/nchan/archive/v${nchan_version}.tar.gz
# tar zxf v${nchan_version}.tar.gz
# git clone --recursive --depth=1 https://github.com/slact/nchan
# dirname: nchan-${nchan_version}

# ngx_http_substitutions_filter_module
git clone --depth=1 https://github.com/yaoweibin/ngx_http_substitutions_filter_module
cd ngx_http_substitutions_filter_module
git checkout e12e965ac1837ca709709f9a26f572a54d83430e
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
git clone --recursive --depth=1 https://github.com/google/ngx_brotli.git
# dirname: ngx_brotli

# pcre
# wget http://downloads.sourceforge.net/project/pcre/pcre/${pcre_version}/pcre-${pcre_version}.zip -O pcre-${pcre_version}.zip
# unzip pcre-${pcre_version}.zip
# dirname: pcre-${pcre_version}

wget -O pcre2-${pcre2_version}.zip https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${pcre2_version}/pcre2-${pcre2_version}.zip
unzip pcre2-${pcre2_version}.zip
cd pcre2-${pcre2_version}
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DPCRE2_SUPPORT_JIT=ON ..
make -j$(getconf _NPROCESSORS_ONLN)
cd ../..
# dirname: pcre2-${pcre2_version}

# zlib-cf
git clone --depth=1 https://github.com/cloudflare/zlib.git zlib-cf
cd zlib-cf
#make -f Makefile.in distclean
./configure --static --64
cd ..

git clone --recursive https://github.com/facebook/zstd --depth=1
cd zstd
mkdir out
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-fPIC" \
  -DZSTD_BUILD_SHARED=OFF \
  -B out -S build/cmake
make -C out -j
cd ..
git clone https://github.com/tokers/zstd-nginx-module --depth=1

# nginx-module-vts
git clone --depth=1 https://github.com/vozlt/nginx-module-vts.git

# libatomic_ops
wget -O libatomic_ops-${libatomic_ops_version}.tar.gz https://github.com/ivmai/libatomic_ops/releases/download/v${libatomic_ops_version}/libatomic_ops-${libatomic_ops_version}.tar.gz
tar -xzf libatomic_ops-${libatomic_ops_version}.tar.gz

# luajit
# https://hub.docker.com/r/ekho/nginx-lua/dockerfile
wget -O luajit2-${luajit2_version}.tar.gz https://github.com/openresty/luajit2/archive/v${luajit2_version}.tar.gz
tar -xzf luajit2-${luajit2_version}.tar.gz
cd luajit2-${luajit2_version}
sed -i "s/DEFAULT_CC = gcc/DEFAULT_CC = $CC/" src/Makefile
make -j$(getconf _NPROCESSORS_ONLN) CFLAGS='-static -fPIC' CC=$CC
cd src
ln -s libluajit.so libluajit-5.1.so
cd ..
cd ..
# dirname: luajit2-${luajit2_version}

git clone --depth=1 https://github.com/openresty/lua-cjson
mkdir -p lua-cjson/build
cd lua-cjson/build
cmake .. \
  -DLUA_LIBRARIES=$(pwd)/../../luajit2-${luajit2_version}/src \
  -DLUA_INCLUDE_DIR=$(pwd)/../../luajit2-${luajit2_version}/src
make -j
cd ../..

# jemalloc
git clone https://github.com/jemalloc/jemalloc jemalloc-${jemalloc_version}
cd jemalloc-${jemalloc_version}
git checkout ${jemalloc_version}
./autogen.sh --enable-static
make -j$(getconf _NPROCESSORS_ONLN)
cd ..

# njs
git clone --depth=1 https://github.com/nginx/njs -b ${njs_version}

rm *.zip *.gz
