#!/bin/bash
# configures, cross-compiles and installs libscrypt
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
export_cross_compiler && sanity_check_cross_compiler
cd_clone ${INITIAL_DIR?}/../../utils/libscrypt ${WORK_DIR?}/libscrypt


# ===========================================================================
# configuration:
# Two hacks here.   One to add the "scaffolding" and another to add -fPIC
generic_hack \
  ${WORK_DIR?}/libscrypt/CMakeLists.txt \
  'BEGIN{printf("cmake_minimum_required(VERSION 3.0.0)\nset(ETH_CMAKE_DIR \"'${INITIAL_DIR?}/../../cmake'\" CACHE PATH \"The path to the cmake directory\")\nlist(APPEND CMAKE_MODULE_PATH ${ETH_CMAKE_DIR})\nset(CMAKE_C_FLAGS \"${CMAKE_C_FLAGS} -fPIC\")\n")}1'
cat ${WORK_DIR?}/libscrypt/CMakeLists.txt

# TODO - Only including boost here because of EthDependencies bug, not because we need it.
section_configuring libscrypt
set_cmake_paths "boost"
cmake \
   . \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?}
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling libscrypt
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing libscrypt
make DESTDIR="${INSTALLS_DIR?}/libscrypt" install
return_code $?

# homogenization
ln -s ${INSTALLS_DIR?}/libscrypt/usr/local/lib     ${INSTALLS_DIR?}/libscrypt/lib
ln -s ${INSTALLS_DIR?}/libscrypt/usr/local/include ${INSTALLS_DIR?}/libscrypt/include

# ===========================================================================

section "done" libscrypt
tree ${INSTALLS_DIR?}/libscrypt


# ===========================================================================
