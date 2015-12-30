#!/bin/bash
# configures, cross-compiles and installs libscrypt (as part of webthree-helpers)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${LIBSCRYPT?}
cd_if_not_exists ${LIBSCRYPT_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ---------------------------------------------------------------------------
# hacks
generic_hack \
  ${LIBSCRYPT_BASE_DIR?}/CMakeLists.txt \
  '{gsub(/DSTATICLIB/,"DSTATICLIB -fPIC")}1'


# ===========================================================================
# configuration:

section_configuring ${COMPONENT?}
cmake \
   ${LIBSCRYPT_BASE_DIR?} \
  -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?}
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make
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
