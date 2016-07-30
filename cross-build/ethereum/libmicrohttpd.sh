#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script for cross-building libmicrohttps for ARM Linux devices.
#
# https://www.gnu.org/software/libmicrohttpd/
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
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
([ -n "$SETUP" ] && ${SETUP?}) || source ./setup.sh $*
cd_clone ${SOURCES_DIR?}/libmicrohttpd ${WORK_DIR?}/libmicrohttpd
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration: autoconf

section_configuring libmicrohttpd

# ensure configure picks up host version of automake aclocal
touch configure.ac aclocal.m4 configure Makefile.am Makefile.in

./configure \
  --build="${AUTOCONF_BUILD_ARCHITECTURE}" \
   --host="${AUTOCONF_HOST_ARCHITECTURE}" \
 --prefix="${INSTALLS_DIR?}/libmicrohttpd"
return_code $?
grep ${TARGET_ARCHITECTURE?} ./Makefile >/dev/null # sanity check


# ===========================================================================
# cross-compile:

section_cross_compiling libmicrohttpd
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing libmicrohttpd
make install # destination is set during configuration phase
return_code $?


# ===========================================================================

section "done" libmicrohttpd
tree "${INSTALLS_DIR?}/libmicrohttpd"
