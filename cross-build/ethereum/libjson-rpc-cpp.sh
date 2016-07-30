#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script for cross-building libjson-rpc-cpp for ARM Linux devices.
#
# https://github.com/cinemast/libjson-rpc-cpp
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
cd ${SOURCES_DIR?}/libjson-rpc-cpp && git checkout ${LIBJSON_RPC_CPP_VERSION?}
cd_if_not_exists ${WORK_DIR?}/libjson-rpc-cpp
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring libjson-rpc-cpp
set_cmake_paths "jsoncpp:curl:libmicrohttpd"
cmake \
   ${SOURCES_DIR?}/libjson-rpc-cpp \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DHTTP_SERVER=YES \
  -DHTTP_CLIENT=YES \
  -DUNIX_DOMAIN_SOCKET_SERVER=NO \
  -DUNIX_DOMAIN_SOCKET_CLIENT=NO \
  -DCOMPILE_TESTS=NO \
  -DCOMPILE_STUBGEN=NO \
  -DCOMPILE_EXAMPLES=NO # watch for UNIX_DOMAIN_SOCKET_SERVER spelling (TODO: detail)
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling libjson-rpc-cpp

# somehow these aren't available as is (throws a lot of warnings and eventually dies for lack of finding curl.h)
generic_hack ./src/jsonrpccpp/CMakeFiles/jsonrpccommon.dir/flags.make '{gsub(/^CXX_FLAGS = /,"CXX_FLAGS = -std=c++11 -isystem'${INSTALLS_DIR?}/curl'/include ")}1'
generic_hack ./src/jsonrpccpp/CMakeFiles/jsonrpcserver.dir/flags.make '{gsub(/^CXX_FLAGS = /,"CXX_FLAGS = -std=c++11 -isystem'${INSTALLS_DIR?}/curl'/include ")}1'
generic_hack ./src/jsonrpccpp/CMakeFiles/jsonrpcclient.dir/flags.make '{gsub(/^CXX_FLAGS = /,"CXX_FLAGS = -std=c++11 -isystem'${INSTALLS_DIR?}/curl'/include ")}1'

make
return_code $?


# ===========================================================================
# install:

section_installing libjson-rpc-cpp
make DESTDIR="${INSTALLS_DIR?}/libjson-rpc-cpp" -j 8 install
return_code $?

# homogenization
ln -s ${INSTALLS_DIR?}/libjson-rpc-cpp/usr/local/lib     ${INSTALLS_DIR?}/libjson-rpc-cpp/lib
ln -s ${INSTALLS_DIR?}/libjson-rpc-cpp/usr/local/include ${INSTALLS_DIR?}/libjson-rpc-cpp/include


# ===========================================================================

section "done" libjson-rpc-cpp
tree ${INSTALLS_DIR?}/libjson-rpc-cpp


# ===========================================================================
