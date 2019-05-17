#!/bin/sh
. ./config.sh
export nps_dir=$(find . -name "*pagespeed-ngx-${pagespeed_ngx_version}" -type d)
export LUAJIT_LIB=$(pwd)/luajit2-${luajit2_version}/src
export LUAJIT_INC=$(pwd)/luajit2-${luajit2_version}/src
export CFLAGS="-Wno-c++11-extensions -Wno-error -Wno-deprecated-declarations -Wno-unused-const-variable -Wno-conditional-uninitialized -Wno-mismatched-tags -Wformat -Werror=format-security"
export COMPILER=clang-${clang_version}
export CXX=clang++-${clang_version}
export CC=clang-${clang_version}
cd nginx-${nginx_version}
yes | ./configure \
  --with-cc-opt="-g -O2 -fstack-protector-strong -Wp,-D_FORTIFY_SOURCE=2 -fPIC ${CFLAGS}" \
  --with-ld-opt="-Wl,-z,relro -Wl,-rpath,/usr/lib/x86_64-linux-gnu,-z,now -Wl,--as-needed -L${LUAJIT_INC} -lpcre" \
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
  --with-http_xslt_module=dynamic \
  --with-http_image_filter_module=dynamic \
  --with-http_geoip_module=dynamic \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-pcre=../pcre-${pcre_version} \
  --with-openssl=../boringssl \
  --with-openssl-opt=enable-weak-ssl-ciphers \
  --add-dynamic-module=../ngx_cache_purge \
  --add-dynamic-module=../nginx-upload-progress-module \
  --add-module=../nginx-upstream-fair \
  --add-dynamic-module=../ngx_http_substitutions_filter_module \
  --add-dynamic-module=../ngx_http_auth_pam_module \
  --add-dynamic-module=../nginx-dav-ext-module \
  --add-dynamic-module=../echo-nginx-module-${echo_nginx_module_version} \
  --add-dynamic-module=../ngx-fancyindex-${fancyindex_version} \
  --add-module=../nginx-rtmp-module-${rtmp_module_version} \
  --add-module=../nchan-${nchan_version} \
  --add-dynamic-module=../ngx_brotli \
  --add-dynamic-module=../headers-more-nginx-module-${headers_more_nginx_module_version} \
  --add-dynamic-module=../${nps_dir} \
  --add-module=../ngx_devel_kit-${ngx_devel_kit_version} \
  --add-module=../lua-nginx-module-${lua_nginx_module_version} \
  --add-module=../stream-lua-nginx-module-${stream_lua_nginx_module_version}
# Fix "Error 127" during build
touch ../boringssl/.openssl/include/openssl/ssl.h
# patch for pagespeed
# gawk -i inplace \
#   '/pthread/ { sub(/-lpthread /, ""); sub(/-lpthread /, ""); sub(/\\/, "-lpthread \\"); print } ! /pthread/ { print }' \
#   "objs/Makefile"
make
cd ..

# --with-http_perl_module=dynamic \
