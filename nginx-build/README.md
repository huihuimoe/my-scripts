# Build my own Nginx

Please confirm you are sudoer.

## Requirement

```bash
sudo apt-get update
sudo apt-get install -y unzip clang-11 \
  libexpat-dev libpcre3-dev libxml2-dev libxslt-dev \
  libgeoip-dev libgd-dev gawk uuid-dev libpam0g-dev \
  wget git perl libperl-dev make gcc libmaxminddb-dev \
  libatomic-ops-dev libjemalloc-dev
# sudo apt-get install -y dpkg-dev debhelper
```

## Download, build and install Ngnx

```bash
bash require.sh
bash build.sh
bash install.sh
```
