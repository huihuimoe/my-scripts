

wget https://github.com/aws/aws-lc/archive/refs/tags/v1.30.1.tar.gz -O aws-lc.tar.gz
tar xfv aws-lc.tar.gz
mv aws-lc-1.30.1 aws-lc


export clang_version=18
export CXX=clang++-${clang_version}
export CC=clang-${clang_version}



grep -qxF 'SET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' aws-lc/crypto/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(crypto PROPERTIES SOVERSION 1)' >> aws-lc/crypto/CMakeLists.txt
grep -qxF 'SET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' aws-lc/ssl/CMakeLists.txt || echo -e '\nSET_TARGET_PROPERTIES(ssl PROPERTIES SOVERSION 1)' >> aws-lc/ssl/CMakeLists.txt
mkdir -p aws-lc/build aws-lc/.openssl/lib aws-lc/.openssl/include
ln -sf `pwd`/aws-lc/include/openssl aws-lc/.openssl/include/openssl
touch aws-lc/.openssl/include/openssl/ssl.h
cmake -B`pwd`/aws-lc/build -H`pwd`/aws-lc \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations"
make -C`pwd`/aws-lc/build -j$(getconf _NPROCESSORS_ONLN)
cp aws-lc/build/crypto/libcrypto.a aws-lc/build/ssl/libssl.a aws-lc/.openssl/lib


# after build.sh
cd nginx-1.27.1
touch ../aws-lc/.openssl/include/openssl/ssl.h

../aws-lc/.openssl/include/openssl/base.h:101
+ #define OPENSSL_IS_BORINGSSL

../aws-lc/.openssl/include/openssl/ssl.h:6455
+ // ref: lua-nginx-module-0.10.26/src/ngx_http_lua_ssl_ocsp.c
+ #define SSL_CTRL_GET_TLSEXT_STATUS_REQ_TYPE     127
+ // ref: src/event/quic/ngx_event_quic_openssl_compat.h:43
+ #define SSL_R_MISSING_QUIC_TRANSPORT_PARAMETERS_EXTENSION -452

