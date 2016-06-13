#!/bin/bash
# configures, cross-compiles and installs libethereum (https://github.com/ethereum/libethereum)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
cd_clone ${INITIAL_DIR?}/../../libethereum ${WORK_DIR?}/libethereum
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring libethereum

# ---------------------------------------------------------------------------
# hacks
generic_hack \
  ${WORK_DIR?}/libethereum/libethcore/CMakeLists.txt \
  '!/Eth::ethash-cl Cpuid/'
generic_hack \
  ${WORK_DIR?}/libethereum/libethereum/ExtVM.cpp \
  "{ \
    gsub(/std::exception_ptr/,     \"boost::exception_ptr\"    ); \
    gsub(/std::current_exception/, \"boost::current_exception\"); \
    gsub(/std::rethrow_exception/, \"boost::rethrow_exception\"); \
  }1"

# ---------------------------------------------------------------------------
set_cmake_paths "jsoncpp:boost:leveldb:cryptopp:gmp:curl:libjson-rpc-cpp:libmicrohttpd"
cmake \
   . \
   -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DFATDB=OFF \
  -DMINIUPNPC=OFF \
  -DGUI=OFF \
  -DTESTS=OFF \
  -DTOOLS=OFF \
  -DETHASHCL=OFF \
  -DEVMJIT=OFF \
  -DSOLIDITY=OFF  \
  -DUtils_SCRYPT_LIBRARY=${INSTALLS_DIR?}/libscrypt/usr/local/lib/libscrypt.a \
  -DUtils_SECP256K1_LIBRARY=${INSTALLS_DIR?}/secp256k1/lib/libsecp256k1.a \
  -DDev_DEVCORE_LIBRARY=${INSTALLS_DIR?}/libweb3core/usr/local/lib/libdevcore.so \
  -DDev_DEVCRYPTO_LIBRARY=${INSTALLS_DIR?}/libweb3core/usr/local/lib/libdevcrypto.so \
  -DDev_P2P_LIBRARY=${INSTALLS_DIR?}/libweb3core/usr/local/lib/libp2p.so
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling libethereum
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing libethereum
make DESTDIR="${INSTALLS_DIR?}/libethereum" install
return_code $?

# hack (somehow this doesn't get "installed")
ln -s ${WORK_DIR?}/libethereum/include/ethereum/BuildInfo.h  ${INSTALLS_DIR?}/libethereum/usr/local/include/ethereum/BuildInfo.h
ln -s ${WORK_DIR?}/libethereum/include/ethereum/ConfigInfo.h ${INSTALLS_DIR?}/libethereum/usr/local/include/ethereum/ConfigInfo.h

# homogenization
ln -s ${INSTALLS_DIR?}/libethereum/usr/local/lib     ${INSTALLS_DIR?}/libethereum/lib
ln -s ${INSTALLS_DIR?}/libethereum/usr/local/include ${INSTALLS_DIR?}/libethereum/include

# ===========================================================================

section "done" libethereum
tree ${INSTALLS_DIR?}/libethereum


# ===========================================================================

