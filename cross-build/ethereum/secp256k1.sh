#!/bin/bash
# cross-compiles and installs secp256k1 (as part of webthree-helpers)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${SECP256K1?}
cd_clone ${SECP256K1_BASE_DIR?} ${SECP256K1_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

generic_hack \
  ${SECP256K1_WORK_DIR?}/CMakeLists.txt \
  'BEGIN{printf("cmake_minimum_required(VERSION 3.0.0)\nset(ETH_CMAKE_DIR \"'${WEBTHREE_HELPERS_BASE_DIR?}/cmake'\" CACHE PATH \"The path to the cmake directory\")\nlist(APPEND CMAKE_MODULE_PATH ${ETH_CMAKE_DIR})\n")}1'

section_configuring ${COMPONENT?}
set_cmake_paths "${JSONCPP?}:${BOOST?}:${LEVELDB?}:cryptopp:${GMP?}:${CURL?}:${LIBJSON_RPC_CPP?}:${MHD?}" # overkill but necessary until https://github.com/ethereum/webthree-helpers/issues/68 is addressed properly
cmake \
   . \
  -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?}
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make -j 8
return_code $?


# ===========================================================================
# install: no install target, emulate for consistency

section_installing ${COMPONENT?}
backup_potential_install_dir ${SECP256K1_INSTALL_DIR?}
mkdir ${SECP256K1_INSTALL_DIR?}
mkdir ${SECP256K1_INSTALL_DIR?}/lib
mkdir ${SECP256K1_INSTALL_DIR?}/include
cp    ${SECP256K1_WORK_DIR?}/${SECP256K1_LIBRARY_NAME?}             ${SECP256K1_INSTALL_DIR?}/lib
cp -r ${SECP256K1_WORK_DIR?}/include/${SECP256K1_HEADER_FILE_NAME?} ${SECP256K1_INSTALL_DIR?}/include


# ===========================================================================

section "done" ${COMPONENT?}
tree ${SECP256K1_INSTALL_DIR?}


# ===========================================================================