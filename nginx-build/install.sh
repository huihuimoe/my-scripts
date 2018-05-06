#!/bin/sh
. ./config.sh
cd nginx-${nginx_version}
make install
