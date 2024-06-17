#!/bin/bash
cd $1
bash ./require.sh

bash ./build.sh
cp -r debian nginx-1*/
cd nginx-1*
sudo dpkg-buildpackage -b -uc
cd ..
sudo chmod -R 777 nginx-1* *.deb
ls -alh *.deb
# cp *.deb ../releases/$TRAVIS_JOB_NUMBER
