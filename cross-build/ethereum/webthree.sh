#!/bin/bash
# configures, cross-compiles and installs webthree (https://github.com/ethereum/webthree)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
cd_clone ${INITIAL_DIR?}/../../webthree ${WORK_DIR?}/webthree
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring webthree

# ---------------------------------------------------------------------------
set_cmake_paths "jsoncpp:boost:leveldb:cryptopp:curl:libjson-rpc-cpp:libmicrohttpd:libweb3core:libethereum:libscrypt"

# TODO: ETH_JSON_RPC_STUB off ok?; doesn't use libnatspec.so?
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
 -DETH_JSON_RPC_STUB=OFF \
   -DUtils_SCRYPT_LIBRARY=${INSTALLS_DIR?}/libscrypt/usr/local/lib/libscrypt.a \
-DUtils_SECP256K1_LIBRARY=${INSTALLS_DIR?}/secp256k1/lib/libsecp256k1.a \
    -DDev_DEVCORE_LIBRARY=${INSTALLS_DIR?}/libweb3core/usr/local/lib/libdevcore.so \
  -DDev_DEVCRYPTO_LIBRARY=${INSTALLS_DIR?}/libweb3core/usr/local/lib/libdevcrypto.so \
        -DDev_P2P_LIBRARY=${INSTALLS_DIR?}/libweb3core/usr/local/lib/libp2p.so \
     -DEth_ETHASH_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libethash.so \
 -DEth_ETHASHSEAL_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libethashseal.so \
    -DEth_ETHCORE_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libethcore.so \
   -DEth_ETHEREUM_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libethereum.so \
     -DEth_EVMASM_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libevmasm.so \
    -DEth_EVMCORE_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libevmcore.so \
        -DEth_EVM_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libevm.so \
        -DEth_LLL_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/liblll.so \
  -DEth_TESTUTILS_LIBRARY=${INSTALLS_DIR?}/libethereum/usr/local/lib/libtestutils.so
return_code $?

# ---------------------------------------------------------------------------
# hack: somehow these don't get properly included
readonly MISSING_LIBETHEREUM="-I${INSTALLS_DIR?}/libethereum/include"
readonly MISSING_LIBJSON_RPC_CPP1="-I${WORK_DIR?}/libjson-rpc-cpp/src"
readonly MISSING_LIBJSON_RPC_CPP2="-I${INSTALLS_DIR?}/libjson-rpc-cpp/include/jsonrpccpp/common"

generic_hack \
  ${WORK_DIR?}/webthree/libwebthree/CMakeFiles/webthree.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?}"' ")}1'
generic_hack \
  ${WORK_DIR?}/webthree/eth/CMakeFiles/eth.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?} ${MISSING_LIBJSON_RPC_CPP1?} ${MISSING_LIBJSON_RPC_CPP2?}"' ")}1'
generic_hack \
  ${WORK_DIR?}/webthree/libweb3jsonrpc/CMakeFiles/web3jsonrpc.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?} ${MISSING_LIBJSON_RPC_CPP1?} ${MISSING_LIBJSON_RPC_CPP2?}"' ");gsub(/ -Werror/,"")}1'


# ===========================================================================
# cross-compile:

section_cross_compiling webthree
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing webthree
make DESTDIR="${INSTALLS_DIR?}/webthree" install
return_code $?


# ===========================================================================

section "done" webthree
tree ${INSTALLS_DIR?}/webthree
