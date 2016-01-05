#!/bin/bash
# configures, cross-compiles and installs libethereum (https://github.com/ethereum/libethereum)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${LIBETHEREUM?}
cd_clone ${LIBETHEREUM_BASE_DIR?} ${LIBETHEREUM_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring ${COMPONENT?}

# ---------------------------------------------------------------------------
# hacks
generic_hack \
  ${LIBETHEREUM_WORK_DIR?}/libethcore/CMakeLists.txt \
  '!/Eth::ethash-cl Cpuid/'
generic_hack \
  ${LIBETHEREUM_WORK_DIR?}/libethereum/ExtVM.cpp \
  "{ \
    gsub(/std::exception_ptr/,     \"boost::exception_ptr\"    ); \
    gsub(/std::current_exception/, \"boost::current_exception\"); \
    gsub(/std::rethrow_exception/, \"boost::rethrow_exception\"); \
  }1"

# ---------------------------------------------------------------------------
set_cmake_paths "${JSONCPP?}:${BOOST?}:${LEVELDB?}:cryptopp:${GMP?}:${CURL?}:${LIBJSON_RPC_CPP?}:${MHD?}"
cmake \
   . \
   -G "Unix Makefiles" \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DFATDB=OFF \
  -DMINIUPNPC=OFF \
  -DGUI=OFF \
  -DTESTS=OFF \
  -DTOOLS=OFF \
  -DETHASHCL=OFF \
  -DEVMJIT=OFF \
  -DSOLIDITY=OFF  \
  -DUtils_SCRYPT_LIBRARY=${LIBSCRYPT_LIBRARY?} \
  -DUtils_SECP256K1_LIBRARY=${SECP256K1_LIBRARY?} \
  -DDev_DEVCORE_LIBRARY=${DEVCORE_WEB3CORE_LIBRARY?} \
  -DDev_DEVCRYPTO_LIBRARY=${DEVCRYPTO_WEB3CORE_LIBRARY?} \
  -DDev_P2P_LIBRARY=${P2P_WEB3CORE_LIBRARY?}
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}
make -j 8
return_code $?


# ===========================================================================
# install:

section_installing ${COMPONENT?}
backup_potential_install_dir ${LIBETHEREUM_INSTALL_DIR?}
make DESTDIR="${LIBETHEREUM_INSTALL_DIR?}" install
return_code $?

# hack (somehow this doesn't get "installed")
ln -s ${LIBETHEREUM_WORK_DIR?}/include/ethereum/BuildInfo.h  ${LIBETHEREUM_INSTALL_DIR?}/usr/local/include/ethereum/BuildInfo.h
ln -s ${LIBETHEREUM_WORK_DIR?}/include/ethereum/ConfigInfo.h ${LIBETHEREUM_INSTALL_DIR?}/usr/local/include/ethereum/ConfigInfo.h

# homogenization
ln -s ${LIBETHEREUM_INSTALL_DIR?}/usr/local/lib     ${LIBETHEREUM_INSTALL_DIR?}/lib
ln -s ${LIBETHEREUM_INSTALL_DIR?}/usr/local/include ${LIBETHEREUM_INSTALL_DIR?}/include

# ===========================================================================

section "done" ${COMPONENT?}
tree ${LIBETHEREUM_INSTALL_DIR?}


# ===========================================================================

