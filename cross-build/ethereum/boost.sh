#!/bin/bash
# configures, cross-compiles and installs Boost (http://www.boost.org/)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${BOOST?}
cd_clone ${BOOST_BASE_DIR?} ${BOOST_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration: Boost.Build

section_configuring ${COMPONENT?}
readonly BOOST_LIBRARIES="chrono,filesystem,regex,random,thread,date_time,program_options,test" # test --> unit_test_framework (throws warnings...)
./bootstrap.sh --with-libraries="${BOOST_LIBRARIES?}" # TODO: how to use an actual work dir rather than current dir?
return_code $?


# ---------------------------------------------------------------------------
section_hacking ${COMPONENT?}
generic_hack \
  ./project-config.jam \
  '{gsub(/using gcc/,"using gcc : arm : '${GCC_CROSS_COMPILER?}'")}1'
grep ${GCC_CROSS_COMPILER_PATTERN?} ./project-config.jam 2>&-  || { echo "ERROR: could not find '${GCC_CROSS_COMPILER?}' in project-config.jam"; exit 1; } # sanity check


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
backup_potential_install_dir ${BOOST_INSTALL_DIR?}
./b2 \
  install \
  --debug-configuration \
  --prefix=${BOOST_INSTALL_DIR?} # also installs (expect some warnings) - takes a while
return_code $?


# ===========================================================================
# install:

section_installing ${COMPONENT?}
ls ${BOOST_INSTALL_DIR?}/lib/libboost_*.a # sanity check; already installed (see previous step)
return_code $?


# ===========================================================================

section "done" ${COMPONENT?}
tree -L 2 "${BOOST_INSTALL_DIR?}"


# ===========================================================================
