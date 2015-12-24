#!/bin/bash
# configures, cross-compiles and installs Json CPP (https://github.com/open-source-parsers/jsoncpp)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${JSONCPP?}
cd ${JSONCPP_BASE_DIR?} && git checkout ${JSONCPP_VERSION?}
export_cross_compiler && sanity_check_cross_compiler
cd_clone ${JSONCPP_BASE_DIR?} ${JSONCPP_WORK_DIR?}


# ===========================================================================
# configuration:

section_configuring ${COMPONENT?}

cmake \
   ${JSONCPP_BASE_DIR?} \
  -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DBUILD_STATIC_LIBS=ON \
  -DBUILD_SHARED_LIBS=OFF \
  -DJSONCPP_WITH_TESTS=OFF \
  -DARCHIVE_INSTALLS_DIR="." # TODO: enforce
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make
return_code $?


# ===========================================================================
# install:

section_installing ${COMPONENT?}
backup_potential_install_dir ${JSONCPP_INSTALL_DIR?}
make DESTDIR="${JSONCPP_INSTALL_DIR?}" install
return_code $?

# hack: required by libjson-rpc-cpp
ln -s ${JSONCPP_INSTALL_DIR?}/usr/local/include ${JSONCPP_INSTALL_DIR?}/usr/local/include/jsoncpp

# homogenization
ln -s ${JSONCPP_INSTALL_DIR?}/usr/local/lib     ${JSONCPP_INSTALL_DIR?}/lib
ln -s ${JSONCPP_INSTALL_DIR?}/usr/local/include ${JSONCPP_INSTALL_DIR?}/include

# ===========================================================================

section "done" ${COMPONENT?}
tree ${JSONCPP_INSTALL_DIR?}


# ===========================================================================
