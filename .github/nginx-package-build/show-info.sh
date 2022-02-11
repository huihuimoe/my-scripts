#!/bin/bash
cd $1
sudo cp ./luajit2-*/src/libluajit.so /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2
sudo ldconfig
./nginx-1*/objs/nginx -V
file ./nginx-1*/objs/nginx
ldd ./nginx-1*/objs/nginx
