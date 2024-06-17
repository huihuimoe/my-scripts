#!/bin/bash
. ./config.sh
# nps_dir=$(find . -name "*pagespeed-ngx-${pagespeed_ngx_version}" -type d)
export CXX=clang++-${clang_version}
export CC=clang-${clang_version}

# ./my-scripts/nginx-build/nginx-1.23.2/objs/autoconf.err

CFLAGS="-I`pwd`/jemalloc-${jemalloc_version}/include -I`pwd`/luajit2-${luajit2_version}/src -I`pwd`/pcre2-${pcre2_version}/build"
# https://github.com/arut/nginx-rtmp-module/commit/c56fd73def3eb407155ecebc28af84ea83dc99e5
CFLAGS="$CFLAGS -Wno-error=unused-but-set-variable"
EX_LD_OPT="-L`pwd`/pcre2-${pcre2_version}/build"
EX_LD_OPT="$EX_LD_OPT -L`pwd`/luajit2-${luajit2_version}/src -l:libluajit.a -L`pwd`/jemalloc-${jemalloc_version}/lib -l:libjemalloc_pic.a -lm -ldl"
# only in CI
if [ ! -z "$CI" ]; then
  EX_LD_OPT="$EX_LD_OPT -L/usr/lib -l:libxml2.a -l:libz.a -l:liblzma.a -l:libiconv.a -l:libcrypt.a"
  EX_LD_OPT="$EX_LD_OPT -l:libicuuc.a -l:libicudata.a"
fi
ARCH=$(uname -m)
case $ARCH in
  x86_64)
    ARCH=x86-64
    ;;
  aarch64)
    # https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html
    ARCH=armv8-a
    ;;
esac

cd nginx-${nginx_version}
sed -i "s| \\./configure.*| ./configure CC=${CC} CXX=${CXX}|" auto/lib/libatomic/make
./configure \
  --with-cc-opt="-g -O2 -fstack-protector-strong -Wp,-D_FORTIFY_SOURCE=2 -fPIC -march=${ARCH} ${CFLAGS}" \
  --with-ld-opt="-Wl,-z,relro $EX_LD_OPT" \
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
  --with-http_v3_module \
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
  --with-pcre-jit \
  --with-openssl=../openssl-${quictls_version} \
  --with-openssl-opt="enable-weak-ssl-ciphers enable-ec_nistp_64_gcc_128 -march=${ARCH} CC=${CC} CXX=${CXX}" \
  --with-zlib=../zlib-cf \
  --add-module=../ngx_cache_purge \
  --add-module=../nginx-upload-progress-module \
  --add-module=../nginx-upstream-fair \
  --add-module=../ngx_http_substitutions_filter_module \
  --add-module=../ngx_http_auth_pam_module \
  --add-module=../nginx-dav-ext-module \
  --add-module=../ngx_http_geoip2_module-${ngx_http_geoip2_module_version} \
  --add-module=../echo-nginx-module-${echo_nginx_module_version} \
  --add-module=../ngx-fancyindex-${fancyindex_version} \
  --add-module=../nginx-rtmp-module \
  --add-module=../ngx_brotli \
  --add-module=../headers-more-nginx-module-${headers_more_nginx_module_version} \
  --add-module=../ngx_devel_kit-${ngx_devel_kit_version} \
  --add-module=../lua-nginx-module-${lua_nginx_module_version} \
  --add-module=../stream-lua-nginx-module-${stream_lua_nginx_module_version} \
  --add-module=../lua-upstream-nginx-module \
  --add-module=../set-misc-nginx-module \
  --add-module=../nchan \
  --add-module=../nginx-module-vts \
  --add-module=../njs/nginx
# --with-http_perl_module \

# Fix libatomic_ops
ln -sf ./.libs/libatomic_ops.a ../libatomic_ops-${libatomic_ops_version}/src/libatomic_ops.a

# patch for pagespeed
# gawk -i inplace \
#   '/pthread/ { sub(/-lpthread /, ""); sub(/-lpthread /, ""); sub(/\\/, "-lpthread \\"); print } ! /pthread/ { print }' \
#   "objs/Makefile"

make -j$(getconf _NPROCESSORS_ONLN)
cd ..
