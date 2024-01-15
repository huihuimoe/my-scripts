#!/bin/bash
. ./config.sh
export CFLAGS="-I`pwd`/jemalloc-${jemalloc_version}/include -I`pwd`/luajit2-${luajit2_version}/src"
export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

# only in CI
if [ ! -z "$CI" ]; then
  EX_LD_OPT="-L/usr/lib -l:libxml2.a -l:libz.a -l:liblzma.a -l:libiconv.a -l:libcrypt.a"
  EX_LD_OPT="$EX_LD_OPT -l:libicuuc.a -l:libicudata.a"
fi
ARCH=$(uname -m)
case $ARCH in
  x86_64)
    ARCH=x86-64
    ;;
  aarch64)
    ARCH=armv8-a
    ;;
esac

cd nginx-${nginx_version}
./configure \
  --with-cc-opt="-g -O2 -fstack-protector-strong -Wp,-D_FORTIFY_SOURCE=2 -fPIC -march=${ARCH} ${CFLAGS}" \
  --with-ld-opt="-Wl,-z,relro -L`pwd`/../luajit2-${luajit2_version}/src -l:libluajit.a -L`pwd`/../jemalloc-${jemalloc_version}/lib -l:libjemalloc_pic.a -lm -ldl $EX_LD_OPT" \
  --prefix=/usr/share/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --http-log-path=/var/log/nginx/access.log \
  --error-log-path=/var/log/nginx/error.log \
  --lock-path=/var/lock/nginx.lock \
  --pid-path=/run/nginx.pid \
  --modules-path=/usr/lib/nginx/modules \
  --http-client-body-temp-path=/var/lib/nginx/body \
  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
  --http-proxy-temp-path=/var/lib/nginx/proxy \
  --http-scgi-temp-path=/var/lib/nginx/scgi \
  --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
  --with-file-aio \
  --with-pcre-jit \
  --with-debug \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_realip_module \
  --with-http_auth_request_module \
  --with-http_addition_module \
  --with-http_dav_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_sub_module \
  --with-mail_ssl_module \
  --with-http_v2_module \
  --with-http_xslt_module \
  --with-http_image_filter_module \
  --with-http_geoip_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_slice_module \
  --with-stream_realip_module \
  --with-threads \
  --with-libatomic=../libatomic_ops-${libatomic_ops_version} \
  --with-pcre=../pcre-${pcre_version} \
  --with-openssl=../boringssl \
  --add-module=../ngx_cache_purge \
  --add-module=../nginx-upload-progress-module \
  --add-module=../nginx-upstream-fair \
  --add-module=../ngx_http_substitutions_filter_module \
  --add-module=../ngx_http_auth_pam_module \
  --add-module=../nginx-dav-ext-module \
  --add-module=../ngx_http_geoip2_module-${ngx_http_geoip2_module_version} \
  --add-module=../echo-nginx-module-${echo_nginx_module_version} \
  --add-module=../ngx-fancyindex-${fancyindex_version} \
  --add-module=../nginx-rtmp-module-${rtmp_module_version} \
  --add-module=../ngx_brotli \
  --add-module=../headers-more-nginx-module-${headers_more_nginx_module_version} \
  --add-module=../ngx_devel_kit-${ngx_devel_kit_version} \
  --add-module=../lua-nginx-module-${lua_nginx_module_version} \
  --add-module=../stream-lua-nginx-module-${stream_lua_nginx_module_version} \
  --add-module=../nginx-module-vts \
  --with-http_v3_module \
  --add-module=../nchan
  # --with-http_v2_hpack_enc \
  # --with-quiche=../quiche
  # --with-http_perl_module \
  # --with-zlib=../zlib-cf \

# Fix "Error 127" during build
touch ../boringssl/.openssl/include/openssl/ssl.h

# https://github.com/quictls/openssl/blob/d2cc208d34cfe2b56d4ef8bcd8e3983a4d00d6bd/include/openssl/sslerr.h#L165
# src/event/quic/ngx_event_quic_openssl_compat.h:31:16: error: redefinition of 'ssl_quic_method_st'
sed -i '0,/#define SSL_R/s//#define SSL_R_MISSING_QUIC_TRANSPORT_PARAMETERS_EXTENSION 801\n#define SSL_R/' ../boringssl/.openssl/include/openssl/ssl.h

# Fix libatomic_ops
ln -s ./.libs/libatomic_ops.a ../libatomic_ops-${libatomic_ops_version}/src/libatomic_ops.a

make -j$(getconf _NPROCESSORS_ONLN)
cd ..
