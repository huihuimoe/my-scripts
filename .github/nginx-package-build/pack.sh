#!/bin/bash
cd $1
bash ./require.sh

# libcurl based unavailable
# if [ ! -z "$CI" ]; then
#   mkdir -p system_libs
#   sudo mv /usr/lib/$(uname -m)-linux-gnu/libbrotlicommon.so.* /usr/lib/$(uname -m)-linux-gnu/libbrotlienc.so.* system_libs/
# fi
bash ./build.sh
# if [ ! -z "$CI" ]; then
#   sudo mv system_libs/* /usr/lib/$(uname -m)-linux-gnu
# fi
cp -r debian nginx-1*/
cd nginx-1*
sudo dpkg-buildpackage -b -uc
cd ..
sudo chmod -R 777 nginx-1* *.deb
ls -alh *.deb
# cp *.deb ../releases/$TRAVIS_JOB_NUMBER
