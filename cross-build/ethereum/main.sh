#!/bin/bash
#
# @author: Anthony Cros
#
# TODO:
# - libjson RPC CPP seems to contact github somehow...
 
# ===========================================================================
set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi

# ===========================================================================

source ./utils.sh
check_args $* # "armel"/"armhf" and "apt"/"manual"
source ./setup.sh $*

# ===========================================================================

cd ${INITIAL_DIR?}               && pwd && git log -1 --format="%h"
cd ${WEBTHREE_HELPERS_BASE_DIR?} && pwd && git log -1 --format="%h"
cd ${LIBWEB3CORE_BASE_DIR?}      && pwd && git log -1 --format="%h"
cd ${LIBETHEREUM_BASE_DIR?}      && pwd && git log -1 --format="%h"
cd ${WEBTHREE_BASE_DIR?}         && pwd && git log -1 --format="%h"
cd ${INITIAL_DIR?}

# ===========================================================================
# init:
mkdir -p ${BASE_DIR?}
mkdir -p ${SOURCES_DIR?} ${WORK_DIR?} ${LOGS_DIR?} ${INSTALLS_DIR?} ${BACKUPS_DIR?}

# ===========================================================================
# downloads
./download.sh \
  "${CMAKE?}:${JSONCPP?}:${BOOST?}:${LEVELDB?}:cryptopp:${GMP?}:${CURL?}:${LIBJSON_RPC_CPP?}:${MHD?}" \
  "${TARGET_SUBTYPE?}"

# ===========================================================================
# cmake:
mkdir -p ${CMAKE_INSTALL_DIR?}
get_cmake_toolchain_file_content > ${CMAKE_TOOLCHAIN_FILE?}
echo && tree -L 1 ${BASE_DIR?} && \
  echo -e "\n\n${CMAKE_TOOLCHAIN_FILE?}:\n$(cat ${CMAKE_TOOLCHAIN_FILE?})\n"

# ===========================================================================
# libweb3core dependencies cross-compilation
export_cross_compiler
sanity_check_cross_compiler

./cryptopp.sh  "${TARGET_SUBTYPE?}"
./boost.sh     "${TARGET_SUBTYPE?}"
./jsoncpp.sh   "${TARGET_SUBTYPE?}"
./leveldb.sh   "${TARGET_SUBTYPE?}"
./gmp.sh       "${TARGET_SUBTYPE?}"

./curl.sh            "${TARGET_SUBTYPE?}"
./mhd.sh             "${TARGET_SUBTYPE?}"
./libjson-rpc-cpp.sh "${TARGET_SUBTYPE?}" # needs both curl and mhd

./libscrypt.sh "${TARGET_SUBTYPE?}"
./secp256k1.sh "${TARGET_SUBTYPE?}"

# ---------------------------------------------------------------------------
# webthree-helpers hack (for libethereum):
clone ${WEBTHREE_HELPERS_BASE_DIR?} ${WEBTHREE_HELPERS_WORK_DIR?} # clones without cd-ing
generic_hack \
  ${WEBTHREE_HELPERS_WORK_DIR?}/cmake/UseEth.cmake \
  '!/Eth::ethash-cl Cpuid/'
generic_hack \
  ${WEBTHREE_HELPERS_WORK_DIR?}/cmake/UseDev.cmake \
  '!/Miniupnpc/'

# ---------------------------------------------------------------------------
./libweb3core.sh "${TARGET_SUBTYPE?}"


# ===========================================================================
# libethereum dependencies cross-compilation
export_cross_compiler
sanity_check_cross_compiler

./libethereum.sh "${TARGET_SUBTYPE?}" # requires libweb3core


# ===========================================================================
# webthree dependencies cross-compilation
export_cross_compiler
sanity_check_cross_compiler

./webthree.sh "${TARGET_SUBTYPE?}" # requires libweb3core and libethereum


# ===========================================================================
printf '=%.0s' {1..75} && echo
tree -L 4 ${LIBWEB3CORE_INSTALL_DIR?}
tree -L 4 ${LIBETHEREUM_INSTALL_DIR?}
tree -L 4 ${WEBTHREE_INSTALL_DIR?}

# ===========================================================================
# produces a packaged-up file (will spit out instructions on how to use it)
./package.sh \
  ${INSTALLS_DIR?} \
  ${WEBTHREE_INSTALL_DIR?}/usr/local/bin

# ===========================================================================
echo "done."

# ===========================================================================
