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
# We *have* to download Boost because EthDependencies.cmake in
# webthree-helper does a find_package() for it unconditionally, no matter
# what we are actually building.
./download.sh \
  "boost:gmp" \
  "${TARGET_SUBTYPE?}"
#  "boost;cmake;cryptopp;curl;gmp;libjson-rpc-cpp;mhd"

# ===========================================================================
# cmake:
mkdir -p ${CMAKE_INSTALL_DIR?}
get_cmake_toolchain_file_content > ${CMAKE_TOOLCHAIN_FILE?}
echo && tree -L 1 ${BASE_DIR?} && \
  echo -e "\n\n${CMAKE_TOOLCHAIN_FILE?}:\n$(cat ${CMAKE_TOOLCHAIN_FILE?})\n"

# ---------------------------------------------------------------------------
# webthree-helpers hack (for libethereum):
clone ${WEBTHREE_HELPERS_BASE_DIR?} ${WEBTHREE_HELPERS_WORK_DIR?} # clones without cd-ing
generic_hack \
  ${WEBTHREE_HELPERS_WORK_DIR?}/cmake/UseEth.cmake \
  '!/Eth::ethash-cl Cpuid/'
generic_hack \
  ${WEBTHREE_HELPERS_WORK_DIR?}/cmake/UseDev.cmake \
  '!/Miniupnpc/'


# ===========================================================================
# Layer 0 is Boost.
# Absolutely everything depends on Boost, whether they use it or not,
# because of EthDependencies.cmake in webthree-helper, which does an
# unconditional find_module() for boost, irrespective of what is being built.

./boost.sh     "${TARGET_SUBTYPE?}"


# ===========================================================================
# Layer 1 are the external libraries.  Do any of these themselves depend on
# Boost?  I think that the majority or indeed all of them *might not*, and
# that if we fixed up the CMake code so that the unconditional Boost
# dependency could be skipped then we could improve the build ordering here.

./libscrypt.sh "${TARGET_SUBTYPE?}"
./gmp.sh       "${TARGET_SUBTYPE?}"
./cryptopp.sh  "${TARGET_SUBTYPE?}"
./curl.sh      "${TARGET_SUBTYPE?}"
./jsoncpp.sh   "${TARGET_SUBTYPE?}"
./leveldb.sh   "${TARGET_SUBTYPE?}"
./mhd.sh       "${TARGET_SUBTYPE?}"


# ===========================================================================
# Layer 2 comprises secp256k1 and libjson-rpc-cpp (which are external
# libraries which depend on Layer 1 external libraries)

./libjson-rpc-cpp.sh "${TARGET_SUBTYPE?}" # requires curl, jsoncpp and mhd
./secp256k1.sh       "${TARGET_SUBTYPE?}"


# ===========================================================================
# Layers 3, 4 and 5 are libweb3core, libethereum and webthree, which are
# stacked on top of each other.

./libweb3core.sh "${TARGET_SUBTYPE?}" # requires secp256k1 and more
tree -L 4 ${LIBWEB3CORE_INSTALL_DIR?}
./libethereum.sh "${TARGET_SUBTYPE?}" # requires libweb3core and more
tree -L 4 ${LIBETHEREUM_INSTALL_DIR?}
./webthree.sh "${TARGET_SUBTYPE?}" # requires libethereum and more
tree -L 4 ${WEBTHREE_INSTALL_DIR?}


# ===========================================================================
printf '=%.0s' {1..75} && echo

# ===========================================================================
# produces a packaged-up file (will spit out instructions on how to use it)
./package.sh \
  ${INSTALLS_DIR?} \
  ${WEBTHREE_INSTALL_DIR?}/usr/local/bin

# ===========================================================================
echo "done."

# ===========================================================================
