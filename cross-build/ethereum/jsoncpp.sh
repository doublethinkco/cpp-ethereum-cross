#!/bin/bash
# configures, cross-compiles and installs Json CPP (https://github.com/open-source-parsers/jsoncpp)
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
cd ${SOURCES_DIR?}/jsoncpp && git checkout ${JSONCPP_VERSION?}
export_cross_compiler && sanity_check_cross_compiler
cd_clone ${SOURCES_DIR?}/jsoncpp ${WORK_DIR?}/jsoncpp


# ===========================================================================
# configuration:

section_configuring jsoncpp

cmake \
   ${SOURCES_DIR?}/jsoncpp \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DBUILD_STATIC_LIBS=ON \
  -DBUILD_SHARED_LIBS=OFF \
  -DJSONCPP_WITH_TESTS=OFF \
  -DARCHIVE_INSTALLS_DIR="." # TODO: enforce
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling jsoncpp
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing jsoncpp
make DESTDIR="${INSTALLS_DIR?}/jsoncpp" install
return_code $?

# hack: required by libjson-rpc-cpp
ln -s ${INSTALLS_DIR?}/jsoncpp/usr/local/include ${INSTALLS_DIR?}/jsoncpp/usr/local/include/jsoncpp

# homogenization
ln -s ${INSTALLS_DIR?}/jsoncpp/usr/local/lib     ${INSTALLS_DIR?}/jsoncpp/lib
ln -s ${INSTALLS_DIR?}/jsoncpp/usr/local/include ${INSTALLS_DIR?}/jsoncpp/include

# ===========================================================================

section "done" jsoncpp
tree ${INSTALLS_DIR?}/jsoncpp


# ===========================================================================
