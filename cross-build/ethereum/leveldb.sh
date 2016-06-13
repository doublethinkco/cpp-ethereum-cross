#!/bin/bash
# configures, cross-compiles and installs LevelDB (https://github.com/google/leveldb)
# @author: Anthony Cros

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
