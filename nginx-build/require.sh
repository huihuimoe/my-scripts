#!/bin/sh
. ./config.sh

apt update
apt install -y wget git unzip clang-${clang_version} \
  libexpat-dev libpcre3-dev libxml2-dev libxslt-dev libgeoip-dev libgd-dev \
  gawk uuid-dev libpam0g-dev libluajit-5.1 libluajit-5.1-dev

# echo-nginx-module
wget https://github.com/openresty/echo-nginx-module/archive/v${echo_nginx_module_version}.tar.gz
tar zxvf v${echo_nginx_module_version}.tar.gz && rm v${echo_nginx_module_version}.tar.gz
# dirname: echo-nginx-module-${echo_nginx_module_version}

# headers-more-nginx-module
wget https://github.com/openresty/headers-more-nginx-module/archive/v${headers_more_nginx_module_version}.tar.gz
tar zxvf v${headers_more_nginx_module_version}.tar.gz && rm v${headers_more_nginx_module_version}.tar.gz
# dirname: headers-more-nginx-module-${headers_more_nginx_module_version}

# lua-nginx-module
wget https://github.com/openresty/lua-nginx-module/archive/v${lua_nginx_module_version}.tar.gz
tar zxvf v${lua_nginx_module_version}.tar.gz && rm v${lua_nginx_module_version}.tar.gz
# dirname: lua-nginx-module-${lua_nginx_module_version}

# ngx_devel_kit
wget https://github.com/simplresty/ngx_devel_kit/archive/v0.3.1rc1.tar.gz
tar zxvf v${ngx_devel_kit_version}.tar.gz && rm v${ngx_devel_kit_version}.tar.gz
# dirname: ngx_devel_kit-${ngx_devel_kit_version}

# ngx_http_substitutions_filter_module
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
# dirname: ngx_http_substitutions_filter_module

# ngx_http_auth_pam_module
git clone https://github.com/sto/ngx_http_auth_pam_module
# dirname: ngx_http_auth_pam_module

# nginx-dav-ext-module
git clone https://github.com/arut/nginx-dav-ext-module
# dirname: nginx-dav-ext-module

# nginx-upstream-fair
git clone https://github.com/chrislea/nginx-upstream-fair/
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
tar -xzvf $(basename ${psol_url})
rm $(basename ${psol_url})
cd ..
# dirname: ${nps_dir}

# openssl
wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
tar zxvf openssl-${openssl_version}.tar.gz && rm openssl-${openssl_version}.tar.gz
# dirname: openssl-${openssl_version}

# nginx
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar zxvf nginx-${nginx_version}.tar.gz && rm nginx-${nginx_version}.tar.gz
# dirname: nginx-${nginx_version}

# LuaJIT
#cd ../${LuaJIT}
wget https://github.com/LuaJIT/LuaJIT/archive/v${LuaJIT_version}.tar.gz
tar zxvf v${LuaJIT_version}.tar.gz && rm v${LuaJIT_version}.tar.gz
cd LuaJIT-${LuaJIT_version}
make && sudo make insatll && ldconfig
cd ..
