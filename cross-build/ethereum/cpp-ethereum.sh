#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script for cross-building cpp-ethereum for ARM Linux devices.
#
# http://www.ethdocs.org/en/latest/ethereum-clients/cpp-ethereum/
# https://github.com/doublethinkco/cpp-ethereum-cross
#
# ------------------------------------------------------------------------------
# This file is part of cpp-ethereum-cross.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright (c) 2015-2016 Kitsilano Software Inc (https://doublethink.co)
#------------------------------------------------------------------------------


# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
cd_clone ${INITIAL_DIR?}/../.. ${WORK_DIR?}/cpp-ethereum
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring cpp-ethereum

# ---------------------------------------------------------------------------
set_cmake_paths "boost:cryptopp:curl:gmp:jsoncpp:leveldb::libjson-rpc-cpp:libmicrohttpd:libscrypt:mhd"

tree ${INSTALLS_DIR?}

cmake \
   . \
   -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DMINIUPNPC=OFF \
  -DETHASHCL=OFF \
  -DEVMJIT=OFF \
  -DETH_JSON_RPC_STUB=OFF \
  -DUtils_SCRYPT_LIBRARY=${INSTALLS_DIR?}/libscrypt/lib/libscrypt.a \
  -DUtils_SECP256K1_LIBRARY=${INSTALLS_DIR?}/secp256k1/lib/libsecp256k1.a
return_code $?

# ---------------------------------------------------------------------------
# hack: somehow these don't get properly included
readonly MISSING_LIBETHEREUM="-I${INSTALLS_DIR?}/libethereum/include"
readonly MISSING_LIBJSON_RPC_CPP1="-I${WORK_DIR?}/libjson-rpc-cpp/src"
readonly MISSING_LIBJSON_RPC_CPP2="-I${INSTALLS_DIR?}/libjson-rpc-cpp/include/jsonrpccpp/common"

generic_hack \
  ${WORK_DIR?}/webthree/eth/CMakeFiles/eth.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBJSON_RPC_CPP1?} ${MISSING_LIBJSON_RPC_CPP2?}"' ")}1'
generic_hack \
  ${WORK_DIR?}/webthree/libweb3jsonrpc/CMakeFiles/web3jsonrpc.dir/flags.make \
  '{gsub(/CXX_FLAGS = /, "CXX_FLAGS = '"${MISSING_LIBJSON_RPC_CPP1?} ${MISSING_LIBJSON_RPC_CPP2?}"' ");gsub(/ -Werror/,"")}1'

# hacks
generic_hack \
  ${WORK_DIR?}/libethcore/CMakeLists.txt \
  '!/Eth::ethash-cl Cpuid/'

# configuration hack to remove miniupnp (optional and broken at the moment)
generic_hack \
  ${WORK_DIR?}/libp2p/CMakeLists.txt \
  '!/Miniupnpc/'

# ===========================================================================
# cross-compile:

section_cross_compiling cpp-ethereum
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing cpp-ethereum
make DESTDIR="${INSTALLS_DIR?}/cpp-ethereum" install
return_code $?


# ===========================================================================

section "done" cpp-ethereum
tree ${INSTALLS_DIR?}/cpp-ethereum
