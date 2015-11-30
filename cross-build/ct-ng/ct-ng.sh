#!/bin/bash
# generates a cross-compiler
# TODO: skip unnecessary steps?

# ===========================================================================
set -e
readonly BASE_DIR=${1?} && shift # provide base dir for ct-ng download/installs and cross-compiler (e.g. ~/ct-ng)

# TODO: enforce both or none
CONFIG_CHANGES=${1?} && shift # must provide a config file path or "default"; 
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
[ "${CONFIG_CHANGES?}" == "default" ] || [ -f "${CONFIG_CHANGES?}" ] ||  { echo "ERROR: must provide config file changes or the value \"default\"" exit 1; }

# ===========================================================================

# TEMPORARILY BORROWED FROM ethereum dir's utils.sh, DO NOT EDIT generic_hack
#
# applies generic awk script to a copy of the given file
function generic_hack() { # ensure script is idempotent
  FILE=${1?} && shift
  AWK_SCRIPT=${1?} && shift  
  
  if [ ! -f ${FILE?}.bak ]; then
    cp ${FILE?} ${FILE?}.bak # to keep original file around conveniently (without having to use git)
  fi
  
  awk "${AWK_SCRIPT?}" ${FILE?}.bak > ${FILE?}
}

# ---------------------------------------------------------------------------
function to_awk_script() {
  for ENTRY in $(tee | tr ',' '\n'); do # loop through entries and create an awk clause/action for each
    KEY=$(echo "${ENTRY?}" | cut -d'=' -f1)
    VAL=$(echo "${ENTRY?}" | cut -d'=' -f2 | sed 's/"/\\"/g') # if quotes are provided, must escape them in awk script
    if [ -z "${VAL?}" ]; then
      echo "/ *${KEY?}[= ]/{print \"# ${KEY?} is not set\"; next}" # next so as to only print the replacement
    else
      echo "/ *${KEY?}[= ]/{print \"${KEY?}=${VAL?}\"; next}" # next: see above
    fi  
  done | tr -d "\n"
  echo -n "1" # so as to print every other line
}

# ---------------------------------------------------------------------------
function quick_cleanup() {
  awk '!/^ *$/ && !/^ *#/{sub(/^ */,"");sub(/ *$/,"");print}'
} # removes empty lines/comments and trims

function ct_ng_config_hack() {
  FILE=${1?} && shift
  CHANGES_FILE=${1?} && shift
  
  AWK_SCRIPT=$(cat ${CHANGES_FILE?} | quick_cleanup | cut -d',' -f1 | to_awk_script)
  echo -e "using:\n\tawk '${AWK_SCRIPT?}' ${FILE?}"

  generic_hack ${FILE?} "${AWK_SCRIPT?}" 
}

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

# modify config file to suit the need of a specific architecture
if [ "${CONFIG_CHANGES?}" != "default" ]; then
  echo "using:"
  echo
  cat ${CONFIG_CHANGES?}
  echo

  ct_ng_config_hack \
    ${CTNG_WORK_DIR?}/.config \
    ${CONFIG_CHANGES?}
fi

# build cross-compiler
mkdir -p ${LOGS_DIR?}
ct-ng build

# ===========================================================================

ls "${CROSS_COMPILER_DIR?}/bin/${TARGET_ARCHITECTURE?}-gcc"
echo
tree "${CROSS_COMPILER_DIR?}"

# ===========================================================================

