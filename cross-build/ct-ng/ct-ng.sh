#!/bin/bash
# generates a cross-compiler
# TODO: skip unnecessary steps?

# ===========================================================================
set -e
readonly BASE_DIR=${1?} && shift # provide base dir for ct-ng download/installs and cross-compiler (e.g. ~/ct-ng)

# TODO: enforce both or none
TARGET_ARCHITECTURE=$1
TARGET_ARCHITECTURE=${TARGET_ARCHITECTURE:="arm-unknown-linux-gnueabi"}
CTNG_VERSION=$2
CTNG_VERSION=${CTNG_VERSION:="1.20.0"}

# ===========================================================================
readonly CTNG_DOWNLOAD_URL="http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CTNG_VERSION?}.tar.bz2"

   readonly CTNG_SOURCE_DIR="${BASE_DIR?}/src"
 readonly  CTNG_INSTALL_DIR="${BASE_DIR?}/install"
     readonly CTNG_WORK_DIR="${BASE_DIR?}/wd"
          readonly LOGS_DIR="${BASE_DIR?}/logs"     
readonly CROSS_COMPILER_DIR="$HOME/x-tools/${TARGET_ARCHITECTURE?}" # TODO: how to change this?

# ===========================================================================
readonly DEPENDENCIES="" #bison flex texinfo gawk automake libtool cvs ncurses-dev gperf" # TODO: re-enable once dependencies are fleshed out
hash ${DEPENDENCIES?} 2>&- || { echo -e "ERROR: missing one or more dependencies amongst:\n\t${DEPENDENCIES?}"; exit 1; }
/sbin/ldconfig -p | grep libexpat || { echo "ERROR: libexpat is missing, please run 'sudo apt-get install libexpat1-dev'"; exit 1; }

# ===========================================================================
# download
mkdir -p ${CTNG_SOURCE_DIR?}
wget -O- ${CTNG_DOWNLOAD_URL?} | \
  tar jxv -C ${CTNG_SOURCE_DIR?}

# configure
cd "${CTNG_SOURCE_DIR?}/crosstool-ng-${CTNG_VERSION?}"
./configure --prefix="${CTNG_INSTALL_DIR?}"

# build
make
echo $?

# install
make install
echo $?
export PATH="$PATH:${CTNG_INSTALL_DIR?}/bin"

# sanity check
ct-ng --version

# build cross-compiler (this takes a while...)
mkdir -p ${CTNG_WORK_DIR?}
cd ${CTNG_WORK_DIR?}
ct-ng ${TARGET_ARCHITECTURE?} # configure for architecture
mkdir -p ${LOGS_DIR?}

# build cross-compiler
ct-ng build

# ===========================================================================

ls "${CROSS_COMPILER_DIR?}/bin/${TARGET_ARCHITECTURE?}-gcc"
echo
tree "${CROSS_COMPILER_DIR?}"

# ===========================================================================

