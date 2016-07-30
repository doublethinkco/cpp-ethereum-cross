#!/bin/bash
# cross-compiles and installs secp256k1
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
cd_clone ${INITIAL_DIR?}/../../utils/secp256k1 ${WORK_DIR?}/secp256k1
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

generic_hack \
  ${WORK_DIR?}/secp256k1/CMakeLists.txt \
  'BEGIN{printf("cmake_minimum_required(VERSION 3.0.0)\nset(ETH_CMAKE_DIR \"'${INITIAL_DIR?}/../../cmake'\" CACHE PATH \"The path to the cmake directory\")\nlist(APPEND CMAKE_MODULE_PATH ${ETH_CMAKE_DIR})\n")}1'

# TODO - Only including boost here because of EthDependencies bug, not because we need it.
section_configuring secp256k1
set_cmake_paths "boost:gmp"
cmake \
   . \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?}
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling secp256k1
make -j 8
return_code $?


# ===========================================================================
# install: no install target, emulate for consistency

section_installing secp256k1
mkdir ${INSTALLS_DIR?}/secp256k1
mkdir ${INSTALLS_DIR?}/secp256k1/lib
mkdir ${INSTALLS_DIR?}/secp256k1/include
cp    ${WORK_DIR?}/secp256k1/libsecp256k1.a       ${INSTALLS_DIR?}/secp256k1/lib
cp -r ${WORK_DIR?}/secp256k1/include/secp256k1.h  ${INSTALLS_DIR?}/secp256k1/include


# ===========================================================================

section "done" secp256k1
tree ${INSTALLS_DIR?}/secp256k1


# ===========================================================================