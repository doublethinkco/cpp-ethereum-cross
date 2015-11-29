#!/bin/bash
# configures, cross-compiles and installs LevelDB (https://github.com/google/leveldb)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${LEVELDB?}
cd ${LEVELDB_BASE_DIR?} && git checkout ${LEVELDB_VERSION?}
cd_clone ${LEVELDB_BASE_DIR?} ${LEVELDB_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ---------------------------------------------------------------------------
make clean
return_code $?

# ===========================================================================
# no configuration phase (bare Makefile)
:

# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make
return_code $?


# ===========================================================================
# install: no install target, emulate for consistency

section_installing ${COMPONENT?}
backup_potential_install_dir ${LEVELDB_INSTALL_DIR?}
mkdir ${LEVELDB_INSTALL_DIR?}
rm ${LEVELDB_INSTALL_DIR?}/lib 2>&- || :
rm ${LEVELDB_INSTALL_DIR?}/include 2>&- || :
mkdir ${LEVELDB_INSTALL_DIR?}/lib
cp    ${LEVELDB_WORK_DIR?}/lib*    ${LEVELDB_INSTALL_DIR?}/lib
cp -r ${LEVELDB_WORK_DIR?}/include ${LEVELDB_INSTALL_DIR?}

# ===========================================================================

section "done" ${COMPONENT?}
tree ${LEVELDB_INSTALL_DIR?}


# ===========================================================================
