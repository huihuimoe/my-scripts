#!/bin/sh
. ./config.sh
cd nginx-${nginx_version}
sudo make install
