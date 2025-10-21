#!/bin/bash
set -ex
cd $1
./nginx-1*/objs/nginx -V
file ./nginx-1*/objs/nginx
ldd ./nginx-1*/objs/nginx
