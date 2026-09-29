#!/bin/bash
set -ex
cd $1
. ./config.sh

NGINX_SRC="nginx-${nginx_version}"

./${NGINX_SRC}/objs/nginx -V
file ./${NGINX_SRC}/objs/nginx
ldd ./${NGINX_SRC}/objs/nginx
