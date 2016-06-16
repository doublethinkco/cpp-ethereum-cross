#!/bin/bash
# configures, cross-compiles and installs Ethereum's libweb3core (https://github.com/ethereum/libweb3core)
# @author: Anthony Cros
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
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
cd_clone ${INITIAL_DIR?}/../../libweb3core ${WORK_DIR?}/libweb3core
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring web3core
set_cmake_paths "jsoncpp:boost:leveldb:cryptopp:gmp"

# ---------------------------------------------------------------------------
# configuration hack to remove miniupnp (optional and broken at the moment)
generic_hack \
  ${WORK_DIR?}/libweb3core/libp2p/CMakeLists.txt \
  '!/Miniupnpc/'


# ---------------------------------------------------------------------------
cmake \
   . \
  -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DFATDB=OFF \
  -DMINIUPNPC=OFF \
  -DGUI=OFF \
  -DETHASHCL=OFF \
  -DEVMJIT=OFF \
  -DSOLIDITY=OFF  \
  -DUtils_SCRYPT_LIBRARY=${INSTALLS_DIR?}/libscrypt/usr/local/lib/libscrypt.a \
  -DUtils_SECP256K1_LIBRARY=${INSTALLS_DIR?}/secp256k1/lib/libsecp256k1.a
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling libweb3core
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing libweb3core
make DESTDIR="${INSTALLS_DIR?}/libweb3core" install
return_code $?

# homogenization
ln -s ${INSTALLS_DIR?}/libweb3core/usr/local/lib     ${INSTALLS_DIR?}/libweb3core/lib
ln -s ${INSTALLS_DIR?}/libweb3core/usr/local/include ${INSTALLS_DIR?}/libweb3core/include

# ===========================================================================

section "done" libweb3core
tree ${INSTALLS_DIR?}/libweb3core


# ===========================================================================
