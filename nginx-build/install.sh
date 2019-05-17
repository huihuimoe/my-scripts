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
