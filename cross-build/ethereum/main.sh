#!/bin/bash
#
# @author: Anthony Cros
#
# TODO:
# - libjson RPC CPP seems to contact github somehow...
#
# Copyright (c) 2015-2016 Kitsilano Software Inc (https://doublethink.co)
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

 
# ===========================================================================
set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi

# ===========================================================================

source ./utils.sh
check_args $* # "armel"/"armhf" and "apt"/"manual"
source ./setup.sh $*

# ===========================================================================

cd ${INITIAL_DIR?}       && pwd && git log -1 --format="%h"
cd ${INITIAL_DIR?}/../.. && pwd && git log -1 --format="%h"
cd ${INITIAL_DIR?}

# ===========================================================================
# init:
mkdir -p ${BASE_DIR?}
mkdir -p ${SOURCES_DIR?} ${WORK_DIR?} ${LOGS_DIR?} ${INSTALLS_DIR?}

# ===========================================================================
# We *have* to download Boost because EthDependencies.cmake in
# webthree-helper does a find_package() for it unconditionally, no matter
# what we are actually building.
#
# We are also still downloading cmake even though the Docker files have
# already been updated to "apt-get install" it, because there are still
# references to CMAKE_TOOLCHAIN_FILE all over the place.   Those should
# be re-directed to point at the installed version, and then we can
# strip out the cmake download here.
#
# NOTE - We use orphaned copies secp256k1 and scrypt which live inside
# the webthree-helper package.   Their oddness makes them pigs to
# cross-build, because we are not running CMake from a repo root
# directory

./download.sh \
  "boost:cmake:cryptopp:curl:gmp:jsoncpp:leveldb:libjson-rpc-cpp:libmicrohttpd" \
  "${TARGET_SUBTYPE?}"

# ===========================================================================
# cmake:
mkdir -p ${INSTALLS_DIR?}/cmake
get_cmake_toolchain_file_content > ${CMAKE_TOOLCHAIN_FILE?}
echo && tree -L 1 ${BASE_DIR?} && \
  echo -e "\n\n${CMAKE_TOOLCHAIN_FILE?}:\n$(cat ${CMAKE_TOOLCHAIN_FILE?})\n"

# ---------------------------------------------------------------------------
# cmake file hacks (for libethereum):
clone ${INITIAL_DIR?}/../../cmake ${WORK_DIR?}/cmake # clones without cd-ing
generic_hack \
  ${WORK_DIR?}/cmake/UseEth.cmake \
  '!/Eth::ethash-cl Cpuid/'
generic_hack \
  ${WORK_DIR?}/cmake/UseDev.cmake \
  '!/Miniupnpc/'


# ---------------------------------------------------------------------------
# Layer 1 contains most of our external dependencies.  All mutually independent.

./boost.sh     "${TARGET_SUBTYPE?}"
./cryptopp.sh  "${TARGET_SUBTYPE?}"
./curl.sh      "${TARGET_SUBTYPE?}"
./gmp.sh       "${TARGET_SUBTYPE?}"
./jsoncpp.sh   "${TARGET_SUBTYPE?}"
./leveldb.sh   "${TARGET_SUBTYPE?}"
./mhd.sh       "${TARGET_SUBTYPE?}"

# ---------------------------------------------------------------------------
# Layer 2 contains external dependencies which are dependent on other
# external dependencies:
#
# - libjson-rpc-cpp depends on curl, jsoncpp and libmicrohtppd.
# - secp256k1 depends on gmp (but we build it as part of cpp-ethereum)

./libjson-rpc-cpp.sh "${TARGET_SUBTYPE?}"


# ---------------------------------------------------------------------------
# Layers 3 is the cpp-ethereum project itself.

./cpp-ethereum.sh "${TARGET_SUBTYPE?}"


# ===========================================================================
printf '=%.0s' {1..75} && echo

# ===========================================================================
# produces a packaged-up file (will spit out instructions on how to use it)
./package.sh \
  ${INSTALLS_DIR?} \
  ${INSTALLS_DIR?}/cpp-ethereum/usr/local/bin

# ===========================================================================
echo "done."
