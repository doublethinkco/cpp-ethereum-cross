#!/bin/bash
#
# @author: Anthony Cros
#

set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
source ./utils.sh
echo "running setup"

# ===========================================================================
export readonly TARGET_SUBTYPE=${1?} # "armel" or "armhf"
export readonly CROSS_COMPILER_PROVENANCE=${2?} # true/false
 
# ===========================================================================
export readonly INITIAL_DIR=${PWD?}

# ===========================================================================

export readonly ORIGIN_ARCHITECTURE="x86_64"
export readonly TARGET_ARCHITECTURE="arm"

# ===========================================================================
export readonly                BASE_DIR="${HOME?}/eth"

export readonly             SOURCES_DIR="${BASE_DIR?}/src"
export readonly                WORK_DIR="${BASE_DIR?}/wd"
export readonly                LOGS_DIR="${BASE_DIR?}/logs"
export readonly            INSTALLS_DIR="${BASE_DIR?}/installs"
export readonly             BACKUPS_DIR="${BASE_DIR?}/baks"

# ===========================================================================
export readonly LIBSCRYPT_LIBRARY_NAME="libscrypt.a"
export readonly SECP256K1_LIBRARY_NAME="libsecp256k1.a"

export readonly   DEVCORE_LIBRARY_NAME="libdevcore.so"
export readonly DEVCRYPTO_LIBRARY_NAME="libdevcrypto.so"
export readonly       P2P_LIBRARY_NAME="libp2p.so"

export readonly    ETHASH_LIBRARY_NAME="libethash.so"
export readonly ETHASHSEAL_LIBRARY_NAME="libethashseal.so"
export readonly   ETHCORE_LIBRARY_NAME="libethcore.so"
export readonly  ETHEREUM_LIBRARY_NAME="libethereum.so"
export readonly    EVMASM_LIBRARY_NAME="libevmasm.so"
export readonly   EVMCORE_LIBRARY_NAME="libevmcore.so"
export readonly       EVM_LIBRARY_NAME="libevm.so"
export readonly       LLL_LIBRARY_NAME="liblll.so"
export readonly TESTUTILS_LIBRARY_NAME="libtestutils.so"

# ---------------------------------------------------------------------------
export readonly SECP256K1_HEADER_FILE_NAME="secp256k1.h"

# ===========================================================================
export readonly            CMAKE="cmake"
export readonly            BOOST="boost"
export readonly              GMP="gmp"
export readonly          JSONCPP="jsoncpp"
export readonly          LEVELDB="leveldb"
export readonly  LIBJSON_RPC_CPP="libjson-rpc-cpp"
export readonly             CURL="curl"
export readonly              MHD="libmicrohttpd"

export readonly WEBTHREE_HELPERS="webthree-helpers"
    export readonly        LIBSCRYPT="libscrypt"
    export readonly        SECP256K1="secp256k1"
export readonly      LIBWEB3CORE="libweb3core"
export readonly      LIBETHEREUM="libethereum"
export readonly         WEBTHREE="webthree"

# ===========================================================================

# TODO: as param file
export readonly    CMAKE_VERSION="3.3.2"
export readonly    BOOST_VERSION="1.59.0"
export readonly      GMP_VERSION="6.0.0a"
export readonly     CURL_VERSION="7.45.0"
export readonly      MHD_VERSION="0.9.44"

export readonly         CRYPTOPP_VERSION="2ee933d"
export readonly          JSONCPP_VERSION="8a6e50a"
export readonly          LEVELDB_VERSION="77948e7"
export readonly  LIBJSON_RPC_CPP_VERSION="0da64a9"

# ---------------------------------------------------------------------------
export readonly    BOOST_ARCHIVE_NAME="${BOOST?}_${BOOST_VERSION//\./_}.tar.gz"
export readonly      GMP_ARCHIVE_NAME="${GMP?}-${GMP_VERSION?}.tar.bz2"
export readonly     CURL_ARCHIVE_NAME="${CURL?}-${CURL_VERSION?}.tar.gz"
export readonly      MHD_ARCHIVE_NAME="${MHD?}-${MHD_VERSION?}.tar.gz"

# ===========================================================================
export readonly       BOOST_DOWNLOAD_URL="https://github.com/doublethinkco/webthree-umbrella-cross/releases/download/${BOOST_ARCHIVE_NAME?}/${BOOST_ARCHIVE_NAME?}"
export readonly         GMP_DOWNLOAD_URL="https://ftp.gnu.org/gnu/gmp/${GMP_ARCHIVE_NAME?}"
export readonly        CURL_DOWNLOAD_URL="http://curl.haxx.se/download/${CURL_ARCHIVE_NAME?}"
export readonly         MHD_DOWNLOAD_URL="http://ftp.gnu.org/gnu/libmicrohttpd/${MHD_ARCHIVE_NAME?}"
        
export readonly         CRYPTOPP_DOWNLOAD_URL="https://github.com/doublethinkco/cryptopp.git"
export readonly          JSONCPP_DOWNLOAD_URL="https://github.com/doublethinkco/${JSONCPP?}.git"
export readonly          LEVELDB_DOWNLOAD_URL="https://github.com/google/${LEVELDB?}.git"
export readonly  LIBJSON_RPC_CPP_DOWNLOAD_URL="https://github.com/doublethinkco/${LIBJSON_RPC_CPP?}.git"

# ===========================================================================
export readonly           BOOST_BASE_DIR="${SOURCES_DIR?}/${BOOST?}"
export readonly        CRYPTOPP_BASE_DIR="${SOURCES_DIR?}/cryptopp"
export readonly             GMP_BASE_DIR="${SOURCES_DIR?}/${GMP?}"
export readonly         JSONCPP_BASE_DIR="${SOURCES_DIR?}/${JSONCPP?}"
export readonly         LEVELDB_BASE_DIR="${SOURCES_DIR?}/${LEVELDB?}"
export readonly            CURL_BASE_DIR="${SOURCES_DIR?}/${CURL?}"
export readonly LIBJSON_RPC_CPP_BASE_DIR="${SOURCES_DIR?}/${LIBJSON_RPC_CPP?}"
export readonly             MHD_BASE_DIR="${SOURCES_DIR?}/${MHD?}"

export readonly WEBTHREE_HELPERS_BASE_DIR="${INITIAL_DIR?}/../../${WEBTHREE_HELPERS?}"
export readonly      LIBWEB3CORE_BASE_DIR="${INITIAL_DIR?}/../../${LIBWEB3CORE?}"
export readonly      LIBETHEREUM_BASE_DIR="${INITIAL_DIR?}/../../${LIBETHEREUM?}"
export readonly         WEBTHREE_BASE_DIR="${INITIAL_DIR?}/../../${WEBTHREE?}"

# ---------------------------------------------------------------------------
export readonly LIBSCRYPT_BASE_DIR="${WEBTHREE_HELPERS_BASE_DIR?}/utils/${LIBSCRYPT?}"
export readonly SECP256K1_BASE_DIR="${WEBTHREE_HELPERS_BASE_DIR?}/utils/${SECP256K1?}"

# ===========================================================================
export readonly           BOOST_WORK_DIR="${WORK_DIR?}/${BOOST?}"
export readonly        CRYPTOPP_WORK_DIR="${WORK_DIR?}/cryptopp"
export readonly             GMP_WORK_DIR="${WORK_DIR?}/${GMP?}"
export readonly         LEVELDB_WORK_DIR="${WORK_DIR?}/${LEVELDB?}"
export readonly            CURL_WORK_DIR="${WORK_DIR?}/${CURL?}"
export readonly             MHD_WORK_DIR="${WORK_DIR?}/${MHD?}"

# ---------------------------------------------------------------------------
export readonly WEBTHREE_HELPERS_WORK_DIR="${WORK_DIR?}/${WEBTHREE_HELPERS?}"

export readonly         JSONCPP_WORK_DIR="${WORK_DIR?}/${JSONCPP?}"
export readonly LIBJSON_RPC_CPP_WORK_DIR="${WORK_DIR?}/${LIBJSON_RPC_CPP?}"
export readonly     LIBWEB3CORE_WORK_DIR="${WORK_DIR?}/${LIBWEB3CORE?}"
export readonly     LIBETHEREUM_WORK_DIR="${WORK_DIR?}/${LIBETHEREUM?}"
export readonly        WEBTHREE_WORK_DIR="${WORK_DIR?}/${WEBTHREE?}"

# ---------------------------------------------------------------------------
export readonly       LIBSCRYPT_WORK_DIR="${WORK_DIR?}/${LIBSCRYPT?}"
export readonly       SECP256K1_WORK_DIR="${WORK_DIR?}/${SECP256K1?}"

# ===========================================================================
export readonly           CMAKE_INSTALL_DIR="${INSTALLS_DIR?}/${CMAKE?}"
export readonly           BOOST_INSTALL_DIR="${INSTALLS_DIR?}/${BOOST?}"
export readonly        CRYPTOPP_INSTALL_DIR="${INSTALLS_DIR?}/cryptopp"
export readonly             GMP_INSTALL_DIR="${INSTALLS_DIR?}/${GMP?}"
export readonly         JSONCPP_INSTALL_DIR="${INSTALLS_DIR?}/${JSONCPP?}"
export readonly         LEVELDB_INSTALL_DIR="${INSTALLS_DIR?}/${LEVELDB?}"
export readonly            CURL_INSTALL_DIR="${INSTALLS_DIR?}/${CURL?}"
export readonly             MHD_INSTALL_DIR="${INSTALLS_DIR?}/${MHD?}"
export readonly LIBJSON_RPC_CPP_INSTALL_DIR="${INSTALLS_DIR?}/${LIBJSON_RPC_CPP?}"

# ---------------------------------------------------------------------------
export readonly     LIBWEB3CORE_INSTALL_DIR="${INSTALLS_DIR?}/${LIBWEB3CORE?}"
export readonly     LIBETHEREUM_INSTALL_DIR="${INSTALLS_DIR?}/${LIBETHEREUM?}"
export readonly        WEBTHREE_INSTALL_DIR="${INSTALLS_DIR?}/${WEBTHREE?}"

# ---------------------------------------------------------------------------
export readonly       LIBSCRYPT_INSTALL_DIR="${INSTALLS_DIR?}/${LIBSCRYPT?}"
export readonly       SECP256K1_INSTALL_DIR="${INSTALLS_DIR?}/${SECP256K1?}"

# ===========================================================================
export readonly LIBETHEREUM_LIB_DIR="${LIBETHEREUM_INSTALL_DIR?}/usr/local/lib"
export readonly LIBWEB3CORE_LIB_DIR="${LIBWEB3CORE_INSTALL_DIR?}/usr/local/lib"
export readonly   LIBSCRYPT_LIB_DIR="${LIBSCRYPT_INSTALL_DIR?}/usr/local/lib"
export readonly   SECP256K1_LIB_DIR="${SECP256K1_INSTALL_DIR?}/lib"

# ---------------------------------------------------------------------------
export readonly          LIBSCRYPT_LIBRARY="${LIBSCRYPT_LIB_DIR?}/${LIBSCRYPT_LIBRARY_NAME?}"
export readonly          SECP256K1_LIBRARY="${SECP256K1_LIB_DIR?}/${SECP256K1_LIBRARY_NAME?}"

export readonly   DEVCORE_WEB3CORE_LIBRARY="${LIBWEB3CORE_LIB_DIR?}/${DEVCORE_LIBRARY_NAME?}"
export readonly DEVCRYPTO_WEB3CORE_LIBRARY="${LIBWEB3CORE_LIB_DIR?}/${DEVCRYPTO_LIBRARY_NAME?}"
export readonly       P2P_WEB3CORE_LIBRARY="${LIBWEB3CORE_LIB_DIR?}/${P2P_LIBRARY_NAME?}"

export readonly    ETHASH_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHASH_LIBRARY_NAME?}"
export readonly ETHASHSEAL_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHASHSEAL_LIBRARY_NAME?}"
export readonly   ETHCORE_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHCORE_LIBRARY_NAME?}"
export readonly  ETHEREUM_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHEREUM_LIBRARY_NAME?}"
export readonly    EVMASM_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${EVMASM_LIBRARY_NAME?}"
export readonly   EVMCORE_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${EVMCORE_LIBRARY_NAME?}"
export readonly       EVM_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${EVM_LIBRARY_NAME?}"
export readonly       LLL_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${LLL_LIBRARY_NAME?}"
export readonly TESTUTILS_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${TESTUTILS_LIBRARY_NAME?}"

# ===========================================================================

if [ "${CROSS_COMPILER_PROVENANCE?}" == "apt" ]; then
  export readonly CROSS_COMPILER_ROOT_DIR="/usr"

  if [ "${TARGET_SUBTYPE?}" == "armel" ]; then
    export readonly  GCC_CROSS_COMPILER="/usr/bin/arm-linux-gnueabi-gcc"
    export readonly  GXX_CROSS_COMPILER="/usr/bin/arm-linux-gnueabi-g++"
  else
    export readonly  GCC_CROSS_COMPILER="/usr/bin/arm-linux-gnueabihf-gcc"
    export readonly  GXX_CROSS_COMPILER="/usr/bin/arm-linux-gnueabihf-g++"
  fi

else
  export readonly XCOMPILER_VERSION="15-12-04"
  export readonly XCOMPILER_DOWNLOAD_URL="https://github.com/doublethinkco/webthree-umbrella-cross/releases/download"
  export readonly XCOMPILER_DESTINATION_DIR="$HOME/x-tools"
  export readonly CROSS_COMPILER_ROOT_DIR="${XCOMPILER_DESTINATION_DIR?}/arm-unknown-linux-gnueabi" # name remains the same since the ct-ng configuration is all we are changing from armel to armhf

  if [ -d "${XCOMPILER_DESTINATION_DIR?}" ]; then
    echo "ERROR: '${XCOMPILER_DESTINATION_DIR?}' already exists"
    exit 1
  fi
  fetch "${XCOMPILER_DOWNLOAD_URL?}/${TARGET_SUBTYPE?}-${XCOMPILER_VERSION}/${TARGET_SUBTYPE?}.tgz" ${XCOMPILER_DESTINATION_DIR?}
  ls -d "${CROSS_COMPILER_ROOT_DIR?}" # check present

  export readonly CROSS_COMPILER_TARGET=$(echo "${CROSS_COMPILER_ROOT_DIR?}" | awk -F$'/' '{print $NF}')

  export readonly  GCC_CROSS_COMPILER="${CROSS_COMPILER_ROOT_DIR?}/bin/${CROSS_COMPILER_TARGET?}-gcc"
  export readonly  GXX_CROSS_COMPILER="${CROSS_COMPILER_ROOT_DIR?}/bin/${CROSS_COMPILER_TARGET?}-g++"
fi
export readonly GCC_CROSS_COMPILER_PATTERN=$(perl -e "print quotemeta('${GCC_CROSS_COMPILER}')")
export readonly GXX_CROSS_COMPILER_PATTERN=$(perl -e "print quotemeta('${GXX_CROSS_COMPILER}')")
export readonly CMAKE_TOOLCHAIN_FILE="${CMAKE_INSTALL_DIR?}/toolchain"

# ===========================================================================

export readonly SETUP=true

echo "setup done."

