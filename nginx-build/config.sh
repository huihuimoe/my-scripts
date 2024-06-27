#!/bin/bash
. ../nginx-base/config.sh

# https://github.com/openssl/openssl/tags
# openssl_version=3.1.1
# https://github.com/quictls/openssl/releases
# wait for 3.3 https://github.com/quictls/openssl/issues/138
# https://github.com/haproxy/haproxy/issues/2294
quictls_version=openssl-3.1.5-quic1
# higher performance than openssl3
# quictls_version=OpenSSL_1_1_1w-quic1
