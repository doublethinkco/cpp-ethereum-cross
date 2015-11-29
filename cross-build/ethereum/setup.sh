#!/bin/bash
#
# @author: Anthony Cros
#

set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
source ./utils.sh $*

# ===========================================================================
readonly INITIAL_DIR=${PWD?}

# ===========================================================================

readonly CROSS_COMPILER_ROOT_DIR=${1?}
readonly TIMESTAMP=${2?}
 
# ===========================================================================
readonly ORIGIN_ARCHITECTURE="x86_64"
readonly TARGET_ARCHITECTURE="arm"

# ===========================================================================
readonly                BASE_DIR="${HOME?}/eth/${TIMESTAMP?}"

readonly             SOURCES_DIR="${BASE_DIR?}/src"
readonly                WORK_DIR="${BASE_DIR?}/wd"
readonly                LOGS_DIR="${BASE_DIR?}/logs"
readonly            INSTALLS_DIR="${BASE_DIR?}/installs"
readonly             BACKUPS_DIR="${BASE_DIR?}/baks"

# ===========================================================================
readonly LIBSCRYPT_LIBRARY_NAME="libscrypt.a"
readonly SECP256K1_LIBRARY_NAME="libsecp256k1.a"

readonly   DEVCORE_LIBRARY_NAME="libdevcore.so"
readonly DEVCRYPTO_LIBRARY_NAME="libdevcrypto.so"
readonly       P2P_LIBRARY_NAME="libp2p.so"

readonly    ETHASH_LIBRARY_NAME="libethash.so"
readonly ETHASHSEAL_LIBRARY_NAME="libethashseal.so"
readonly   ETHCORE_LIBRARY_NAME="libethcore.so"
readonly  ETHEREUM_LIBRARY_NAME="libethereum.so"
readonly    EVMASM_LIBRARY_NAME="libevmasm.so"
readonly   EVMCORE_LIBRARY_NAME="libevmcore.so"
readonly       EVM_LIBRARY_NAME="libevm.so"
readonly       LLL_LIBRARY_NAME="liblll.so"
readonly TESTUTILS_LIBRARY_NAME="libtestutils.so"

# ---------------------------------------------------------------------------
readonly SECP256K1_HEADER_FILE_NAME="secp256k1.h"

# ===========================================================================
readonly            CMAKE="cmake"
readonly            BOOST="boost"
readonly         CRYPTOPP="cryptopp"
readonly              GMP="gmp"
readonly          JSONCPP="jsoncpp"
readonly          LEVELDB="leveldb"
readonly  LIBJSON_RPC_CPP="libjson-rpc-cpp"
readonly             CURL="curl"
readonly              MHD="libmicrohttpd"

readonly WEBTHREE_HELPERS="webthree-helpers"
    readonly        LIBSCRYPT="libscrypt"
    readonly        SECP256K1="secp256k1"
readonly      LIBWEB3CORE="libweb3core"
readonly      LIBETHEREUM="libethereum"
readonly         WEBTHREE="webthree"

# ===========================================================================

# TODO: as param file
readonly    CMAKE_VERSION="3.3.2"
readonly    BOOST_VERSION="1.59.0"
readonly CRYPTOPP_VERSION="5.6.2" # version 5.6.2 is a requirement as per the CMake file
readonly      GMP_VERSION="6.0.0a"
readonly     CURL_VERSION="7.45.0"
readonly      MHD_VERSION="0.9.44"

readonly          JSONCPP_VERSION="34bdbb5"
readonly          LEVELDB_VERSION="77948e7"
readonly  LIBJSON_RPC_CPP_VERSION="8dc16d3"

# ---------------------------------------------------------------------------
readonly    BOOST_ARCHIVE_NAME="${BOOST?}_${BOOST_VERSION//\./_}.tar.gz"
readonly CRYPTOPP_ARCHIVE_NAME="${CRYPTOPP?}${CRYPTOPP_VERSION//\./}.zip"
readonly      GMP_ARCHIVE_NAME="${GMP?}-${GMP_VERSION?}.tar.bz2"
readonly     CURL_ARCHIVE_NAME="${CURL?}-${CURL_VERSION?}.tar.gz"
readonly      MHD_ARCHIVE_NAME="${MHD?}-${MHD_VERSION?}.tar.gz"

# ===========================================================================
readonly       BOOST_DOWNLOAD_URL="http://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION?}/${BOOST_ARCHIVE_NAME?}/download"
readonly    CRYPTOPP_DOWNLOAD_URL="https://www.cryptopp.com/${CRYPTOPP_ARCHIVE_NAME?}"
readonly         GMP_DOWNLOAD_URL="https://ftp.gnu.org/gnu/gmp/${GMP_ARCHIVE_NAME?}"
readonly        CURL_DOWNLOAD_URL="http://curl.haxx.se/download/${CURL_ARCHIVE_NAME?}"
readonly         MHD_DOWNLOAD_URL="http://ftp.gnu.org/gnu/libmicrohttpd/${MHD_ARCHIVE_NAME?}"
        
readonly          JSONCPP_DOWNLOAD_URL="https://github.com/open-source-parsers/${JSONCPP?}.git"
readonly          LEVELDB_DOWNLOAD_URL="https://github.com/google/${LEVELDB?}.git"
readonly  LIBJSON_RPC_CPP_DOWNLOAD_URL="https://github.com/cinemast/${LIBJSON_RPC_CPP?}.git"

# ===========================================================================
readonly           BOOST_BASE_DIR="${SOURCES_DIR?}/${BOOST?}"
readonly        CRYPTOPP_BASE_DIR="${SOURCES_DIR?}/${CRYPTOPP?}"
readonly             GMP_BASE_DIR="${SOURCES_DIR?}/${GMP?}"
readonly         JSONCPP_BASE_DIR="${SOURCES_DIR?}/${JSONCPP?}"
readonly         LEVELDB_BASE_DIR="${SOURCES_DIR?}/${LEVELDB?}"
readonly            CURL_BASE_DIR="${SOURCES_DIR?}/${CURL?}"
readonly LIBJSON_RPC_CPP_BASE_DIR="${SOURCES_DIR?}/${LIBJSON_RPC_CPP?}"
readonly             MHD_BASE_DIR="${SOURCES_DIR?}/${MHD?}"

readonly WEBTHREE_HELPERS_BASE_DIR="${INITIAL_DIR?}/../../${WEBTHREE_HELPERS?}"
readonly      LIBWEB3CORE_BASE_DIR="${INITIAL_DIR?}/../../${LIBWEB3CORE?}"
readonly      LIBETHEREUM_BASE_DIR="${INITIAL_DIR?}/../../${LIBETHEREUM?}"
readonly         WEBTHREE_BASE_DIR="${INITIAL_DIR?}/../../${WEBTHREE?}"

# ---------------------------------------------------------------------------
readonly LIBSCRYPT_BASE_DIR="${WEBTHREE_HELPERS_BASE_DIR?}/utils/${LIBSCRYPT?}"
readonly SECP256K1_BASE_DIR="${WEBTHREE_HELPERS_BASE_DIR?}/utils/${SECP256K1?}"

# ===========================================================================
readonly           BOOST_WORK_DIR="${WORK_DIR?}/${BOOST?}"
readonly        CRYPTOPP_WORK_DIR="${WORK_DIR?}/${CRYPTOPP?}"
readonly             GMP_WORK_DIR="${WORK_DIR?}/${GMP?}"
readonly         LEVELDB_WORK_DIR="${WORK_DIR?}/${LEVELDB?}"
readonly            CURL_WORK_DIR="${WORK_DIR?}/${CURL?}"
readonly             MHD_WORK_DIR="${WORK_DIR?}/${MHD?}"

# ---------------------------------------------------------------------------
readonly WEBTHREE_HELPERS_WORK_DIR="${WORK_DIR?}/${WEBTHREE_HELPERS?}"

readonly         JSONCPP_WORK_DIR="${WORK_DIR?}/${JSONCPP?}"
readonly LIBJSON_RPC_CPP_WORK_DIR="${WORK_DIR?}/${LIBJSON_RPC_CPP?}"
readonly     LIBWEB3CORE_WORK_DIR="${WORK_DIR?}/${LIBWEB3CORE?}"
readonly     LIBETHEREUM_WORK_DIR="${WORK_DIR?}/${LIBETHEREUM?}"
readonly        WEBTHREE_WORK_DIR="${WORK_DIR?}/${WEBTHREE?}"

# ---------------------------------------------------------------------------
readonly       LIBSCRYPT_WORK_DIR="${WORK_DIR?}/${LIBSCRYPT?}"
readonly       SECP256K1_WORK_DIR="${WORK_DIR?}/${SECP256K1?}"

# ===========================================================================
readonly           CMAKE_INSTALL_DIR="${INSTALLS_DIR?}/${CMAKE?}"
readonly           BOOST_INSTALL_DIR="${INSTALLS_DIR?}/${BOOST?}"
readonly        CRYPTOPP_INSTALL_DIR="${INSTALLS_DIR?}/${CRYPTOPP?}"
readonly             GMP_INSTALL_DIR="${INSTALLS_DIR?}/${GMP?}"
readonly         JSONCPP_INSTALL_DIR="${INSTALLS_DIR?}/${JSONCPP?}"
readonly         LEVELDB_INSTALL_DIR="${INSTALLS_DIR?}/${LEVELDB?}"
readonly            CURL_INSTALL_DIR="${INSTALLS_DIR?}/${CURL?}"
readonly             MHD_INSTALL_DIR="${INSTALLS_DIR?}/${MHD?}"
readonly LIBJSON_RPC_CPP_INSTALL_DIR="${INSTALLS_DIR?}/${LIBJSON_RPC_CPP?}"

# ---------------------------------------------------------------------------
readonly     LIBWEB3CORE_INSTALL_DIR="${INSTALLS_DIR?}/${LIBWEB3CORE?}"
readonly     LIBETHEREUM_INSTALL_DIR="${INSTALLS_DIR?}/${LIBETHEREUM?}"
readonly        WEBTHREE_INSTALL_DIR="${INSTALLS_DIR?}/${WEBTHREE?}"

# ---------------------------------------------------------------------------
readonly       LIBSCRYPT_INSTALL_DIR="${INSTALLS_DIR?}/${LIBSCRYPT?}"
readonly       SECP256K1_INSTALL_DIR="${INSTALLS_DIR?}/${SECP256K1?}"

# ===========================================================================
readonly LIBETHEREUM_LIB_DIR="${LIBETHEREUM_INSTALL_DIR?}/usr/local/lib"
readonly LIBWEB3CORE_LIB_DIR="${LIBWEB3CORE_INSTALL_DIR?}/usr/local/lib"
readonly   LIBSCRYPT_LIB_DIR="${LIBSCRYPT_INSTALL_DIR?}/usr/local/lib"
readonly   SECP256K1_LIB_DIR="${SECP256K1_INSTALL_DIR?}/lib"

# ---------------------------------------------------------------------------
readonly          LIBSCRYPT_LIBRARY="${LIBSCRYPT_LIB_DIR?}/${LIBSCRYPT_LIBRARY_NAME?}"
readonly          SECP256K1_LIBRARY="${SECP256K1_LIB_DIR?}/${SECP256K1_LIBRARY_NAME?}"

readonly   DEVCORE_WEB3CORE_LIBRARY="${LIBWEB3CORE_LIB_DIR?}/${DEVCORE_LIBRARY_NAME?}"
readonly DEVCRYPTO_WEB3CORE_LIBRARY="${LIBWEB3CORE_LIB_DIR?}/${DEVCRYPTO_LIBRARY_NAME?}"
readonly       P2P_WEB3CORE_LIBRARY="${LIBWEB3CORE_LIB_DIR?}/${P2P_LIBRARY_NAME?}"

readonly    ETHASH_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHASH_LIBRARY_NAME?}"
readonly ETHASHSEAL_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHASHSEAL_LIBRARY_NAME?}"
readonly   ETHCORE_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHCORE_LIBRARY_NAME?}"
readonly  ETHEREUM_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${ETHEREUM_LIBRARY_NAME?}"
readonly    EVMASM_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${EVMASM_LIBRARY_NAME?}"
readonly   EVMCORE_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${EVMCORE_LIBRARY_NAME?}"
readonly       EVM_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${EVM_LIBRARY_NAME?}"
readonly       LLL_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${LLL_LIBRARY_NAME?}"
readonly TESTUTILS_ETHEREUM_LIBRARY="${LIBETHEREUM_LIB_DIR?}/${TESTUTILS_LIBRARY_NAME?}"

# ===========================================================================

readonly CROSS_COMPILER_TARGET=$(echo "${CROSS_COMPILER_ROOT_DIR?}" | awk -F$'/' '{print $NF}')

readonly  GCC_CROSS_COMPILER="${CROSS_COMPILER_ROOT_DIR?}/bin/${CROSS_COMPILER_TARGET?}-gcc"
readonly  GXX_CROSS_COMPILER="${CROSS_COMPILER_ROOT_DIR?}/bin/${CROSS_COMPILER_TARGET?}-g++"

readonly GCC_CROSS_COMPILER_PATTERN=$(perl -e "print quotemeta('${GCC_CROSS_COMPILER}')")
readonly GXX_CROSS_COMPILER_PATTERN=$(perl -e "print quotemeta('${GXX_CROSS_COMPILER}')")

readonly CMAKE_TOOLCHAIN_FILE="${CMAKE_INSTALL_DIR?}/toolchain"

# ===========================================================================

readonly export SETUP=true

echo "setup done."

