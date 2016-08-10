#!/bin/bash
#
# @author: Anthony Cros, Jahn Bertsch
#
# Copyright (c) 2015-2016 Kitsilano Software Inc (https://doublethink.co)
# Copyright (c) 2016 Jahn Bertsch
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.  

set -e
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
source ./utils.sh
echo "running setup"

# ===========================================================================
export readonly TARGET_SUBTYPE=${1?} # "armel", "armhf", "armv7" or "arm64"
export readonly CROSS_COMPILER_PROVENANCE=${2?} # "manual", "apt" or "xcode"
export readonly INITIAL_DIR=${PWD?}
export readonly ORIGIN_ARCHITECTURE="x86_64"
export readonly TARGET_ARCHITECTURE="arm"

# ===========================================================================
export readonly                BASE_DIR="${HOME?}/eth"
export readonly             SOURCES_DIR="${BASE_DIR?}/src"
export readonly                WORK_DIR="${BASE_DIR?}/wd"
export readonly                LOGS_DIR="${BASE_DIR?}/logs"
export readonly            INSTALLS_DIR="${BASE_DIR?}/installs"

# ===========================================================================
export readonly            BOOST_VERSION="1.61.0"
export readonly             CURL_VERSION="7.49.1"
export readonly         CRYPTOPP_VERSION="c522a8c"
export readonly              GMP_VERSION="6.1.0"
export readonly          JSONCPP_VERSION="8a6e50a"
export readonly          LEVELDB_VERSION="77948e7"
export readonly  LIBJSON_RPC_CPP_VERSION="0da64a9"
export readonly              MHD_VERSION="0.9.50"

# ===========================================================================
export readonly            BOOST_DOWNLOAD_URL="https://github.com/doublethinkco/cpp-ethereum-cross/releases/download/ExternalDependencies/boost_${BOOST_VERSION//\./_}.tar.gz"
export readonly             CURL_DOWNLOAD_URL="http://curl.haxx.se/download/curl-${CURL_VERSION?}.tar.gz"
export readonly         CRYPTOPP_DOWNLOAD_URL="https://github.com/doublethinkco/cryptopp.git"
export readonly              GMP_DOWNLOAD_URL="https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VERSION?}.tar.bz2"
export readonly          JSONCPP_DOWNLOAD_URL="https://github.com/doublethinkco/jsoncpp.git"
export readonly          LEVELDB_DOWNLOAD_URL="https://github.com/google/leveldb.git"
export readonly  LIBJSON_RPC_CPP_DOWNLOAD_URL="https://github.com/doublethinkco/libjson-rpc-cpp.git"
export readonly              MHD_DOWNLOAD_URL="https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-${MHD_VERSION?}.tar.gz"

# ===========================================================================
if [ "${CROSS_COMPILER_PROVENANCE?}" == "xcode" ]; then
  export readonly AUTOCONF_BUILD_ARCHITECTURE="${ORIGIN_ARCHITECTURE?}-apple-darwin"
else
  export readonly AUTOCONF_BUILD_ARCHITECTURE="${ORIGIN_ARCHITECTURE?}-linux-gnu"
fi

if [ "${TARGET_SUBTYPE?}" == "armel" ]; then
  export readonly AUTOCONF_HOST_ARCHITECTURE="${TARGET_ARCHITECTURE?}-unknown-linux-gnueabi"
elif [ "${TARGET_SUBTYPE?}" == "armhf" ]; then
  export readonly AUTOCONF_HOST_ARCHITECTURE="${TARGET_ARCHITECTURE?}-unknown-linux-gnueabihf"
elif [ "${TARGET_SUBTYPE?}" == "armv7" ]; then
  export readonly AUTOCONF_HOST_ARCHITECTURE="arm-apple-darwin"
elif [ "${TARGET_SUBTYPE?}" == "arm64" ]; then
  export readonly AUTOCONF_HOST_ARCHITECTURE="aarch64-apple-darwin"
else
  echo "ERROR: invalid TARGET_SUBTYPE '${TARGET_SUBTYPE}'"
  exit 1
fi

# ===========================================================================
if [ "${CROSS_COMPILER_PROVENANCE?}" == "apt" ]; then
  export readonly CROSS_COMPILER_ROOT_DIR="/usr"

  if [ "${TARGET_SUBTYPE?}" == "armel" ]; then
    export readonly GCC_CROSS_COMPILER="/usr/bin/arm-linux-gnueabi-gcc"
    export readonly GXX_CROSS_COMPILER="/usr/bin/arm-linux-gnueabi-g++"
  else
    export readonly GCC_CROSS_COMPILER="/usr/bin/arm-linux-gnueabihf-gcc"
    export readonly GXX_CROSS_COMPILER="/usr/bin/arm-linux-gnueabihf-g++"
  fi

elif [ "${CROSS_COMPILER_PROVENANCE?}" == "manual" ]; then
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

  export readonly GCC_CROSS_COMPILER="${CROSS_COMPILER_ROOT_DIR?}/bin/${CROSS_COMPILER_TARGET?}-gcc"
  export readonly GXX_CROSS_COMPILER="${CROSS_COMPILER_ROOT_DIR?}/bin/${CROSS_COMPILER_TARGET?}-g++"

elif [ "${CROSS_COMPILER_PROVENANCE?}" == "xcode" ]; then
  export readonly PLATFORM="iPhoneSimulator"  # supported values are: AppleTVOS AppleTVSimulator MacOSX WatchOS WatchSimulator iPhoneOS iPhoneSimulator
  export readonly XCODE_ROOT=$(xcode-select -print-path)
  export readonly PLATFORM_ROOT="${XCODE_ROOT}/Platforms/${PLATFORM}.platform/Developer"
  export readonly SDK_ROOT="${PLATFORM_ROOT}/SDKs/${PLATFORM}.sdk"
  export readonly TOOLCHAIN_ROOT="${XCODE_ROOT}/Toolchains/XcodeDefault.xctoolchain/usr/bin/"

  export readonly GCC_CROSS_COMPILER="${TOOLCHAIN_ROOT}/clang"
  export readonly GXX_CROSS_COMPILER="${TOOLCHAIN_ROOT}/clang++}"

else
  echo "ERROR: invalid CROSS_COMPILER_PROVENANCE '${CROSS_COMPILER_PROVENANCE}'"
  exit 1
fi

export readonly GCC_CROSS_COMPILER_PATTERN=$(perl -e "print quotemeta('${GCC_CROSS_COMPILER}')")
export readonly GXX_CROSS_COMPILER_PATTERN=$(perl -e "print quotemeta('${GXX_CROSS_COMPILER}')")
export readonly CMAKE_TOOLCHAIN_FILE="${INSTALLS_DIR?}/cmake/toolchain"

# ===========================================================================

export readonly SETUP=true

echo "setup done."

