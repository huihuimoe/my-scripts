#!/bin/bash
set -ex
cd $1
bash ./require.sh

bash ./build.sh
cp -r ../nginx-base/debian nginx-1*/
cp -r debian/* nginx-1*/debian/
cd nginx-1*
sudo dpkg-buildpackage -b -uc
cd ..
sudo chmod -R 777 nginx-1* *.deb
ls -alh *.deb
# cp *.deb ../releases/$TRAVIS_JOB_NUMBER
