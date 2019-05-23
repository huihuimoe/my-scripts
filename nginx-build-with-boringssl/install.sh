#!/bin/sh
. ./config.sh
cd luajit2-${luajit2_version}
sudo make install
cd ..
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
cd luajit2-* && make install && cd ..
cd lua-resty-lrucache-* && make install && cd ..
cd lua-resty-core-* && make install && cd ..
cd lua-nginx-split-clients-* && make install && cd ..

mkdir -p /var/lib/nginx/body
cd /usr/local/lib/lua && mv ngx resty split-clients /usr/local/share/lua/5.1
