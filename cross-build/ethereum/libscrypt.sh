#!/bin/bash
# configures, cross-compiles and installs libscrypt (as part of webthree-helpers)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${LIBSCRYPT?}
export_cross_compiler && sanity_check_cross_compiler
cd_clone ${LIBSCRYPT_BASE_DIR?} ${LIBSCRYPT_WORK_DIR?}


# ---------------------------------------------------------------------------
# hacks
generic_hack \
  ${LIBSCRYPT_WORK_DIR?}/CMakeLists.txt \
  'BEGIN{printf("set(CMAKE_CXX_FLAGS \"${CMAKE_CXX_FLAGS} -fPIC\")\n")}1'
generic_hack \
  ${LIBSCRYPT_WORK_DIR?}/CMakeLists.txt \
  'BEGIN{printf("include(EthCompilerSettings)\n")}1'
generic_hack \
  ${LIBSCRYPT_WORK_DIR?}/CMakeLists.txt \
  'BEGIN{printf("include(EthExecutableHelper)\n")}1'
generic_hack \
  ${LIBSCRYPT_WORK_DIR?}/CMakeLists.txt \
  'BEGIN{printf("list(APPEND CMAKE_MODULE_PATH ${ETH_CMAKE_DIR})\n")}1'
generic_hack \
  ${LIBSCRYPT_WORK_DIR?}/CMakeLists.txt \
  'BEGIN{printf("set(ETH_CMAKE_DIR \"${CMAKE_CURRENT_LIST_DIR}/../../cmake\" CACHE PATH \"The path to the cmake directory\")\n")}1'

cat ${LIBSCRYPT_WORK_DIR?}/CMakeLists.txt

# ===========================================================================
# configuration:

section_configuring ${COMPONENT?}
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
# install:

section_installing ${COMPONENT?}
backup_potential_install_dir ${LIBSCRYPT_INSTALL_DIR?}
make DESTDIR="${LIBSCRYPT_INSTALL_DIR?}" install
return_code $?

# homogenization
ln -s ${LIBSCRYPT_INSTALL_DIR?}/usr/local/lib     ${LIBSCRYPT_INSTALL_DIR?}/lib
ln -s ${LIBSCRYPT_INSTALL_DIR?}/usr/local/include ${LIBSCRYPT_INSTALL_DIR?}/include

# ===========================================================================

section "done" ${COMPONENT?}
tree ${LIBSCRYPT_INSTALL_DIR?}


# ===========================================================================
