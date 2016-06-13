#!/bin/bash
# configures, cross-compiles and installs CUrl (http://curl.haxx.se/)
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
cd_clone ${SOURCES_DIR?}/curl ${WORK_DIR?}/curl
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# hack: somehow exported CC and CXX for ARM do not get picked up, so have to resort to that instead
export PATH="$PATH:${CROSS_COMPILER_ROOT_DIR?}/bin"

# ===========================================================================
# configuration:

section_configuring curl
./configure \
  --build="${AUTOCONF_BUILD_ARCHITECTURE}" \
   --host="${AUTOCONF_HOST_ARCHITECTURE}" \
 --prefix="${INSTALLS_DIR?}/curl"
return_code $?
grep ${TARGET_ARCHITECTURE?} ./Makefile # sanity check


# ===========================================================================
# cross-compile:

section_cross_compiling curl
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing curl
make install # destination is set during configuration phase
return_code $?


# ===========================================================================

section "done" curl
tree -L 3 "${INSTALLS_DIR?}/curl"


# ===========================================================================
