#!/bin/bash
# packages up all that is needed for eth to run
# @author: Anthony Cros

# ===========================================================================
set -e

TIMESTAMP=${1?} && shift
INSTALL_DIR=${1?} && shift
WEBTHREE_BIN_DIR=${1?} && shift

RESULT_FILE_NAME="eth.${TIMESTAMP?}.tgz"

TMP_DIR=$(mktemp -d)
mkdir ${TMP_DIR?}/eth
mkdir ${TMP_DIR?}/eth/lib
cp -r ${WEBTHREE_BIN_DIR?} ${TMP_DIR?}/eth/
for FILE in $(find ${INSTALL_DIR?} | grep '\.so'); do
cp ${FILE?} ${TMP_DIR?}/eth/lib
done
tar --remove-files -C ${TMP_DIR?} -zcf ~/${RESULT_FILE_NAME?} ./eth
rmdir ${TMP_DIR?}
echo -e "INSTRUCTIONS:\n\n- Uncompress the resulting file ('~/${RESULT_FILE_NAME?}') on the device\n- cd into the bin directory inside it\n- run:\n   export LD_LIBRARY_PATH=/path/to/lib # lib folder inside the tarball\n  ./eth # in bin"

# ===========================================================================
