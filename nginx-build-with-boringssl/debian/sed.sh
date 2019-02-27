#!/bin/bash
sed -i '/logs\/nginx.pid;/a\ \npcre_jit  on;' debian/nginx-boringssl-huihui/etc/nginx/nginx.conf
for file in $(ls debian/nginx-boringssl-huihui/usr/lib/nginx/modules) ; do
	sed -i "/pcre_jit  on;/a\# load_module /usr/lib/nginx/modules/${file};" debian/nginx-boringssl-huihui/etc/nginx/nginx.conf
done
sed -i '/pcre_jit  on;/a\ ' debian/nginx-boringssl-huihui/etc/nginx/nginx.conf

sed -i 's/#tcp_nopush     on;/tcp_nopush      on;\n    tcp_nodelay     on;\n    aio             on;\n\n    ssl_dyn_rec_enable on;\n    ssl_ecdh_curve prime256v1:secp384r1;/' debian/nginx-boringssl-huihui/etc/nginx/nginx.conf

cp debian/nginx-boringssl-huihui/etc/nginx/nginx.conf debian/nginx-boringssl-huihui/etc/nginx/nginx.conf.default
