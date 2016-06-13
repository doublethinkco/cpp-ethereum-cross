#!/bin/bash
# configures, cross-compiles and installs Json CPP (https://github.com/open-source-parsers/jsoncpp)
# @author: Anthony Cros

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
