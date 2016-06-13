#!/bin/bash
# generates a cross-compiler
#
# Copyright (c) 2015-2016 Kitsilano Software Inc (https://doublethink.co)
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


# ===========================================================================
set -e
readonly       BASE_DIR=${1?} && shift # provide base dir for ct-ng download/installs and cross-compiler (e.g. ~/ct-ng)
readonly CONFIG_CHANGES=${1?} && shift # must provide a config file path (e.g. ./conf/wandboard) or "none" (which corresponds to armel)
if [ ! -f "../ethereum/utils.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
source ../ethereum/utils.sh

# TODO: enforce both or none
TARGET_ARCHITECTURE=$1
CTNG_VERSION="1.20.0"

readonly DEFAULT_CONFIG_CHANGES_VALUE="none"

# ===========================================================================
readonly CTNG_DOWNLOAD_URL="http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CTNG_VERSION?}.tar.bz2"

   readonly CTNG_SOURCE_DIR="${BASE_DIR?}/src"
 readonly  CTNG_INSTALL_DIR="${BASE_DIR?}/install"
     readonly CTNG_WORK_DIR="${BASE_DIR?}/wd"
          readonly LOGS_DIR="${BASE_DIR?}/logs"     
readonly CROSS_COMPILER_DIR="$HOME/x-tools/${TARGET_ARCHITECTURE?}"

# ===========================================================================
readonly DEPENDENCIES="" #bison flex texinfo gawk automake libtool cvs ncurses-dev gperf" # TODO: re-enable once dependencies are fleshed out
hash ${DEPENDENCIES?} 2>&- || { echo -e "ERROR: missing one or more dependencies amongst:\n\t${DEPENDENCIES?}"; exit 1; }
/sbin/ldconfig -p | grep libexpat || { echo "ERROR: libexpat is missing, please run 'sudo apt-get install libexpat1-dev'"; exit 1; }
[ "${CONFIG_CHANGES?}" == "${DEFAULT_CONFIG_CHANGES_VALUE?}" ] || [ -f "${CONFIG_CHANGES?}" ] ||  { echo "ERROR: must provide config changes file or the value \"${DEFAULT_CONFIG_CHANGES_VALUE?}\" ('${CONFIG_CHANGES?}')" exit 1; }
CONFIG_CHANGES_ABS="${PWD?}/${CONFIG_CHANGES?}"

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
ct-ng "arm-unknown-linux-gnueabi" # Default architecture?

# modify config file to suit the need of a specific architecture
if [ "${CONFIG_CHANGES?}" != "${DEFAULT_CONFIG_CHANGES_VALUE?}" ]; then
  echo "using:"
  echo
  cat ${CONFIG_CHANGES_ABS?}
  echo

  ct_ng_config_hack \
    ${CTNG_WORK_DIR?}/.config \
    ${CONFIG_CHANGES_ABS?}
fi

# build cross-compiler
mkdir -p ${LOGS_DIR?}
ct-ng build

# ===========================================================================

ls "${CROSS_COMPILER_DIR?}/bin/${TARGET_ARCHITECTURE?}-gcc"
echo
tree -L 3 "${CROSS_COMPILER_DIR?}"
cd $HOME
tar -zcf $HOME/xcompiler.tgz ./x-tools
ls $HOME/xcompiler.tgz

# ===========================================================================

