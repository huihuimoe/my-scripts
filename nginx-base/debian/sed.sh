#!/bin/bash

BASE=${1:-$(pwd)}

sed -i '/logs\/nginx.pid;/a\ \npcre_jit  on;' ${BASE}/etc/nginx/nginx.conf
#for file in $(ls ${BASE}/usr/lib/nginx/modules) ; do
#	sed -i "/pcre_jit  on;/a\# load_module /usr/lib/nginx/modules/${file};" ${BASE}/etc/nginx/nginx.conf
#done
sed -i '/pcre_jit  on;/a\ ' ${BASE}/etc/nginx/nginx.conf

# sed -i 's/#tcp_nopush     on;/tcp_nopush      on;\n    tcp_nodelay     on;\n    aio             on;\n\n    ssl_dyn_rec_enable on;\n    ssl_ecdh_curve prime256v1:secp384r1;/' ${BASE}/etc/nginx/nginx.conf
sed -i 's/#tcp_nopush     on;/tcp_nopush      on;\n    tcp_nodelay     on;\n    aio             on;\n\n    #ssl_ecdh_curve prime256v1:secp384r1;/' ${BASE}/etc/nginx/nginx.conf
sed -i 's/keepalive_timeout  65;/keepalive_timeout 65;\n    keepalive_requests 10000;\n    reset_timedout_connection on;\n    variables_hash_max_size 2048;/' ${BASE}/etc/nginx/nginx.conf

# GeoIP
sed -i 's/include       mime.types;/#geoip_country \/usr\/share\/GeoIP\/GeoIPv6.dat;\n    #geoip_city    \/usr\/share\/GeoIP\/GeoIPCity.dat;\n    #geoip_org     \/usr\/share\/GeoIP\/GeoIPASNum.dat;\n    include       cloudflare-geo.conf;\n    include       mime.types;/' ${BASE}/etc/nginx/nginx.conf
cp debian/files/cloudflare* ${BASE}/etc/nginx/

cp ${BASE}/etc/nginx/nginx.conf ${BASE}/etc/nginx/nginx.conf.default
