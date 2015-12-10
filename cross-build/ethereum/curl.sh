#!/bin/bash
# configures, cross-compiles and installs CUrl (http://curl.haxx.se/)
# @author: Anthony Cros

# ===========================================================================
set -e
source ./utils.sh
check_args $*
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${CURL?}
cd_clone ${CURL_BASE_DIR?} ${CURL_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# hack: somehow exported CC and CXX for ARM do not get picked up, so have to resort to that instead
export PATH="$PATH:${CROSS_COMPILER_ROOT_DIR?}/bin"

# ===========================================================================
# configuration:

section_configuring ${COMPONENT?}
./configure \
  --build="${ORIGIN_ARCHITECTURE?}-linux-gnu" \
   --host="${TARGET_ARCHITECTURE?}-unknown-linux-gnueabi" \
 --prefix="${CURL_INSTALL_DIR?}"
return_code $?
grep ${TARGET_ARCHITECTURE?} ./Makefile # sanity check


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make
return_code $?


# ===========================================================================
# install:

section_installing ${COMPONENT?}
backup_potential_install_dir ${CURL_INSTALL_DIR?}
make install # destination is set during configuration phase
return_code $?


# ===========================================================================

section "done" ${COMPONENT?}
tree -L 3 "${CURL_INSTALL_DIR?}"


# ===========================================================================
