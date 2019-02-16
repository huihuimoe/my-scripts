#!/bin/sh
. ./config.sh

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
#wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
#tar zxf openssl-${openssl_version}.tar.gz && rm openssl-${openssl_version}.tar.gz
# dirname: openssl-${openssl_version}

# pcre
wget https://ftp.pcre.org/pub/pcre/pcre-${pcre_version}.zip
unzip pcre-${pcre_version}.zip && rm pcre-${pcre_version}.zip
# dirname: pcre-${pcre_version}

# nginx
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar zxf nginx-${nginx_version}.tar.gz && rm nginx-${nginx_version}.tar.gz
# dirname: nginx-${nginx_version}

# boringssl with tls1.3
# thanks to https://hub.docker.com/r/denji/nginx-boringssl/dockerfile
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
export CFLAGS="-Wno-c++11-extensions -Wno-error -Wno-deprecated-declarations -Wno-unused-const-variable -Wno-conditional-uninitialized -Wno-mismatched-tags"
export COMPILER=clang-${clang_version}
export CXX=clang++-${clang_version}
export CC=clang-${clang_version}
cmake -B`pwd`/boringssl/build -H`pwd`/boringssl
make -C`pwd`/boringssl/build -j$(getconf _NPROCESSORS_ONLN)
cp boringssl/build/crypto/libcrypto.a boringssl/build/ssl/libssl.a boringssl/.openssl/lib/
