#!/bin/bash
# configures, cross-compiles and installs LevelDB (https://github.com/google/leveldb)
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
cd ${SOURCES_DIR?}/leveldb && git checkout ${LEVELDB_VERSION?}
cd_clone ${SOURCES_DIR?}/leveldb ${WORK_DIR?}/leveldb
export_cross_compiler && sanity_check_cross_compiler


# ---------------------------------------------------------------------------
make clean
return_code $?

# ===========================================================================
# no configuration phase (bare Makefile)
:

# ===========================================================================
# cross-compile:

section_cross_compiling leveldb
make -j 8
return_code $?


# ===========================================================================
# install: no install target, emulate for consistency

section_installing leveldb
mkdir ${INSTALLS_DIR?}/leveldb
rm ${INSTALLS_DIR?}/leveldb/lib 2>&- || :
rm ${INSTALLS_DIR?}/leveldb/include 2>&- || :
mkdir ${INSTALLS_DIR?}/leveldb/lib
cp    ${WORK_DIR?}/leveldb/lib*    ${INSTALLS_DIR?}/leveldb/lib
cp -r ${WORK_DIR?}/leveldb/include ${INSTALLS_DIR?}/leveldb

# ===========================================================================

section "done" leveldb
tree ${INSTALLS_DIR?}/leveldb


# ===========================================================================
