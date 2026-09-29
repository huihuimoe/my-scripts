#!/bin/bash
set -ex
cd $1
. ./config.sh

bash ./require.sh
bash ./build.sh

NGINX_SRC="nginx-${nginx_version}"

cp -r ../nginx-base/debian "${NGINX_SRC}/"
cp -r debian/* "${NGINX_SRC}/debian/"

# Dynamically generate debian/changelog to ensure package version matches nginx_version
cat <<EOF > "${NGINX_SRC}/debian/changelog"
nginx (${nginx_version}) unstable; urgency=medium

  * Release nginx ${nginx_version}

 -- huihuimoe <0w0@loli.pet>  $(date -R)
EOF

cd "${NGINX_SRC}"
sudo dpkg-buildpackage -b -uc
cd ..
sudo chmod -R 777 "${NGINX_SRC}" *.deb
ls -alh *.deb
