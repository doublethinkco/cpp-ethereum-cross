#!/bin/bash
# configures, cross-compiles and installs MHD (https://www.gnu.org/software/libmicrohttpd/)
# @author: Anthony Cros

# ===========================================================================
set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
([ -n "$SETUP" ] && ${SETUP?}) || source ./setup.sh $*
COMPONENT=${MHD?}
cd_clone ${MHD_BASE_DIR?} ${MHD_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration: autoconf

section_configuring ${COMPONENT?}

# ensure configure picks up host version of automake aclocal
touch configure.ac aclocal.m4 configure Makefile.am Makefile.in

./configure \
  --build="${AUTOCONF_BUILD_ARCHITECTURE}" \
   --host="${AUTOCONF_HOST_ARCHITECTURE}" \
 --prefix="${MHD_INSTALL_DIR?}"
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
backup_potential_install_dir ${MHD_INSTALL_DIR?}
make install # destination is set during configuration phase
return_code $?


# ===========================================================================

section "done" ${COMPONENT?}
tree "${MHD_INSTALL_DIR?}"


# ===========================================================================

