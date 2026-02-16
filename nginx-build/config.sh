#!/bin/bash
. ../nginx-base/config.sh

# https://github.com/openssl/openssl/tags
openssl_version=3.6.1
# https://github.com/quictls/openssl/releases
# https://github.com/haproxy/haproxy/issues/2294
# mig to new https://github.com/quictls/quictls project
# quictls_version=openssl-3.3.0-quic1
# higher performance than openssl3
# quictls_version=OpenSSL_1_1_1w-quic1
