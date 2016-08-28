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
# hacks

clone ${INITIAL_DIR?}/../../cmake ${WORK_DIR?}/cmake # clones without cd-ing
generic_hack \
  ${WORK_DIR?}/cmake/UseEth.cmake \
  '!/Eth::ethash-cl Cpuid/'
generic_hack \
  ${WORK_DIR?}/cmake/UseDev.cmake \
  '!/Miniupnpc/'

generic_hack \
  ${WORK_DIR?}/cpp-ethereum/libethcore/CMakeLists.txt \
  '!/Eth::ethash-cl Cpuid/'

# configuration hack to remove miniupnp (optional and broken at the moment)
generic_hack \
  ${WORK_DIR?}/cpp-ethereum/libp2p/CMakeLists.txt \
  '!/Miniupnpc/'

# ---------------------------------------------------------------------------
set_cmake_paths "boost:cryptopp:curl:gmp:jsoncpp:leveldb::libjson-rpc-cpp:libmicrohttpd"

mkdir build
cd build
cmake \
   .. \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DMINIUPNPC=OFF \
  -DETHASHCL=OFF \
  -DEVMJIT=OFF \
  -DTOOLS=OFF \
  -DETH_JSON_RPC_STUB=OFF
return_code $?
cd ..

# ===========================================================================
# cross-compile:

section_cross_compiling cpp-ethereum
cd build
make -j2
return_code $?
cd ..


# ===========================================================================
# install:

section_installing cpp-ethereum
cd build
make DESTDIR="${INSTALLS_DIR?}/cpp-ethereum" install
return_code $?
cd ..


# ===========================================================================

section "done" cpp-ethereum
tree ${INSTALLS_DIR?}/cpp-ethereum
