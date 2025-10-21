#!/bin/bash
set -ex
. ./config.sh
cd lua-resty-lrucache-${nginx_lua_resty_lrucache_version}
sudo make install
cd ..
cd lua-resty-core-${nginx_lua_resty_core_version}
sudo make install
cd ..
cd lua-nginx-split-clients-${nginx_lua_split_clients_version}
sudo make install
cd ..
cd nginx-${nginx_version}
sudo make install
cd ..
cd lua-resty-lrucache-* && sudo make install && cd ..
cd lua-resty-core-* && sudo make install && cd ..
cd lua-nginx-split-clients-* && sudo make install && cd ..

sudo mkdir -p /var/lib/nginx/body
cd /usr/local/lib/lua && sudo mv ngx resty split-clients /usr/local/share/lua/5.1
