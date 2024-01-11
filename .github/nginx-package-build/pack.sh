#!/bin/bash
cd $1
bash ./require.sh

# libcurl based unavailable
if [ ! -z "$CI" ]; then
  mkdir system_libs
  sudo mv /usr/lib/x86_64-linux-gnu/libbrotlicommon.so.* /usr/lib/x86_64-linux-gnu/libbrotlienc.so.* system_libs/
fi
bash ./build.sh
if [ ! -z "$CI" ]; then
  sudo mv system_libs/* /usr/lib/x86_64-linux-gnu
fi
cp -r debian nginx-1*/
cd nginx-1*
sudo dpkg-buildpackage -b -uc
cd ..
sudo chmod -R 777 nginx-1* *.deb
ls -alh *.deb
# cp *.deb ../releases/$TRAVIS_JOB_NUMBER
