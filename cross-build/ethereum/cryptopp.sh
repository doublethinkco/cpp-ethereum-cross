#!/bin/bash
# configures, cross-compiles and installs CryptoPP (https://www.cryptopp.com/)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${CRYPTOPP?}
cd_clone ${CRYPTOPP_BASE_DIR?} ${CRYPTOPP_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler

# ---------------------------------------------------------------------------
make clean
return_code $?


# ===========================================================================
# configuration: no configuration phase (bare Makefile), but hack needed

# hack
section_hacking ${COMPONENT?}
generic_hack ./GNUmakefile '!/=native/'
#generic_hack ./GNUmakefile '{gsub(/O2/,"O2 -fPIC")}1'

# hack sanity check
grep '=native' ./GNUmakefile.bak
grep '=native' ./GNUmakefile && exit 1 || :


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make
return_code $?


# ===========================================================================
# install: DESTDIR does not work, so emulate

section_installing ${COMPONENT?}
backup_potential_install_dir ${CRYPTOPP_INSTALL_DIR?}
mkdir ${CRYPTOPP_INSTALL_DIR?}
rm ${CRYPTOPP_INSTALL_DIR?}/lib 2>&- || :
rm $HOME/${CRYPTOPP?} 2>&- || :
mkdir ${CRYPTOPP_INSTALL_DIR?}/lib
cp    ${CRYPTOPP_WORK_DIR?}/lib*    ${CRYPTOPP_INSTALL_DIR?}/lib
ln -s ${CRYPTOPP_WORK_DIR?} $HOME/${CRYPTOPP?} # hack: somehow this is necessary for includes to work with cryptopp


# ===========================================================================

section "done" ${COMPONENT?}
tree -L 3 "${CRYPTOPP_INSTALL_DIR?}"


# ===========================================================================
