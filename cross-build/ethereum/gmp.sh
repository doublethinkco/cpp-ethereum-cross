#!/bin/bash
# configures, cross-compiles and installs GMP (https://gmplib.org/)
# @author: Anthony Cros

# ===========================================================================
set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
([ -n "$SETUP" ] && ${SETUP?}) || source ./setup.sh $*
cd_clone ${SOURCES_DIR?}/gmp ${WORK_DIR?}/gmp
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration: autoconf

section_configuring gmp
./configure \
  --build="${AUTOCONF_BUILD_ARCHITECTURE}" \
   --host="${AUTOCONF_HOST_ARCHITECTURE}" \
 --prefix="${INSTALLS_DIR?}/gmp"
return_code $?
grep ${TARGET_ARCHITECTURE?} ./Makefile >/dev/null # sanity check


# ===========================================================================
# cross-compile:

section_cross_compiling gmp
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing gmp
make install # destination is set during configuration phase
return_code $?


# ===========================================================================

section "done" gmp
tree "${INSTALLS_DIR?}/gmp"


# ===========================================================================

