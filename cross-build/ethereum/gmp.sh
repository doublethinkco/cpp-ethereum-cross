#!/bin/bash
# configures, cross-compiles and installs GMP (https://gmplib.org/)
# @author: Anthony Cros

# ===========================================================================
set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
([ -n "$SETUP" ] && ${SETUP?}) || source ./setup.sh $*
COMPONENT=${GMP?}
cd_clone ${GMP_BASE_DIR?} ${GMP_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration: autoconf

section_configuring ${COMPONENT?}
./configure \
  --build="${ORIGIN_ARCHITECTURE?}-linux-gnu" \
   --host="${TARGET_ARCHITECTURE?}-unknown-linux-gnueabi" \
 --prefix="${GMP_INSTALL_DIR?}"
return_code $?
grep ${TARGET_ARCHITECTURE?} ./Makefile >/dev/null # sanity check


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing ${COMPONENT?}
backup_potential_install_dir ${GMP_INSTALL_DIR?}
make install # destination is set during configuration phase
return_code $?


# ===========================================================================

section "done" ${COMPONENT?}
tree "${GMP_INSTALL_DIR?}"


# ===========================================================================

