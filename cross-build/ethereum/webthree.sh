#!/bin/bash
# configures, cross-compiles and installs webthree (https://github.com/ethereum/webthree)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${WEBTHREE?}
cd_clone ${WEBTHREE_BASE_DIR?} ${WEBTHREE_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring ${COMPONENT?}

# ---------------------------------------------------------------------------
# hacks

# Remove 'flu', 'libjsengine' and 'libjsconsole' executables.  They depends on V8 which we are not
# cross-building.  It is very large and complex.
generic_hack \
  ${WEBTHREE_WORK_DIR?}/CMakeLists.txt \
  '!/OPTIONAL Readline/ && \
   !/set\(JSCONSOLE 1\)/ && \
   !/add_subdirectory\(flu\)/ && \
   !/add_subdirectory\(libjsengine\)/ && \
   !/add_subdirectory\(libjsconsole\)/'
generic_hack \
  ${WEBTHREE_WORK_DIR?}/eth/CMakeLists.txt \
  '!/OPTIONAL Readline/{gsub(/ Web3::jsconsole/,"");print}'
generic_hack \
  ${WEBTHREE_WORK_DIR?}/eth/main.cpp \
  '/if \(mode == OperationMode::Attach\)/{ON=1} \
    ON{print "// " $0} \
   !ON{print ""    $0} \
    ON && /}$/{ON=0}' # see corresponding bug subbmited: https://github.com/ethereum/webthree/issues/69

# We appear unable to deal with optional dependencies in these
# cross-builds at the moment, so just chop this out.
generic_hack \
  ${WEBTHREE_WORK_DIR?}/libweb3jsonrpc/CMakeLists.txt \
  '!/Solidity/'

# ---------------------------------------------------------------------------
set_cmake_paths "${JSONCPP?}:${BOOST?}:${LEVELDB?}:${CRYPTOPP?}:${CURL?}:${LIBJSON_RPC_CPP?}:${MHD?}:${LIBWEB3CORE?}:${LIBETHEREUM?}:${LIBSCRYPT?}"

# TODO: ETH_JSON_RPC_STUB off ok?; doesn't use libnatspec.so?
cmake \
   . \
   -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DCMAKE_BUILD_TYPE=Debug \
  -DFATDB=OFF \
  -DMINIUPNPC=OFF \
  -DGUI=OFF \
  -DTESTS=OFF \
  -DTOOLS=OFF \
  -DETHASHCL=OFF \
  -DEVMJIT=OFF \
  -DSOLIDITY=OFF  \
 -DETH_JSON_RPC_STUB=OFF \
   -DUtils_SCRYPT_LIBRARY=${LIBSCRYPT_LIBRARY?} \
-DUtils_SECP256K1_LIBRARY=${SECP256K1_LIBRARY?} \
    -DDev_DEVCORE_LIBRARY=${DEVCORE_WEB3CORE_LIBRARY?} \
  -DDev_DEVCRYPTO_LIBRARY=${DEVCRYPTO_WEB3CORE_LIBRARY?} \
        -DDev_P2P_LIBRARY=${P2P_WEB3CORE_LIBRARY?} \
     -DEth_ETHASH_LIBRARY=${ETHASH_ETHEREUM_LIBRARY?} \
 -DEth_ETHASHSEAL_LIBRARY=${ETHASHSEAL_ETHEREUM_LIBRARY?} \
    -DEth_ETHCORE_LIBRARY=${ETHCORE_ETHEREUM_LIBRARY?} \
   -DEth_ETHEREUM_LIBRARY=${ETHEREUM_ETHEREUM_LIBRARY?} \
     -DEth_EVMASM_LIBRARY=${EVMASM_ETHEREUM_LIBRARY?} \
    -DEth_EVMCORE_LIBRARY=${EVMCORE_ETHEREUM_LIBRARY?} \
        -DEth_EVM_LIBRARY=${EVM_ETHEREUM_LIBRARY?} \
        -DEth_LLL_LIBRARY=${LLL_ETHEREUM_LIBRARY?} \
  -DEth_TESTUTILS_LIBRARY=${TESTUTILS_ETHEREUM_LIBRARY?}
return_code $?

# ---------------------------------------------------------------------------
# hack: somehow these don't get properly included
readonly MISSING_LIBETHEREUM="-I${LIBETHEREUM_INSTALL_DIR}/include"
readonly MISSING_LIBJSON_RPC_CPP1="-I${LIBJSON_RPC_CPP_WORK_DIR?}/src"
readonly MISSING_LIBJSON_RPC_CPP2="-I${LIBJSON_RPC_CPP_INSTALL_DIR?}/include/jsonrpccpp/common"

generic_hack \
  ${WEBTHREE_WORK_DIR?}/libwebthree/CMakeFiles/webthree.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?}"' ")}1'
generic_hack \
  ${WEBTHREE_WORK_DIR?}/test/CMakeFiles/testweb3.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?}"' ")}1'
generic_hack \
  ${WEBTHREE_WORK_DIR?}/test/ethrpctest/CMakeFiles/ethrpctest.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?}"' ")}1'

generic_hack \
  ${WEBTHREE_WORK_DIR?}/eth/CMakeFiles/eth.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?} ${MISSING_LIBJSON_RPC_CPP1?} ${MISSING_LIBJSON_RPC_CPP2?}"' ")}1'
generic_hack \
  ${WEBTHREE_WORK_DIR?}/libweb3jsonrpc/CMakeFiles/web3jsonrpc.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBETHEREUM?} ${MISSING_LIBJSON_RPC_CPP1?} ${MISSING_LIBJSON_RPC_CPP2?}"' ");gsub(/ -Werror/,"")}1'


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make
return_code $?


# ===========================================================================
# install:

section_installing ${COMPONENT?}
backup_potential_install_dir ${WEBTHREE_INSTALL_DIR?}
make DESTDIR="${WEBTHREE_INSTALL_DIR?}" install
return_code $?


# ===========================================================================

section "done" ${COMPONENT?}
tree ${WEBTHREE_INSTALL_DIR?}


# ===========================================================================

