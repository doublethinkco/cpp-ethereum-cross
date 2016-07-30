
#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script which packages up all the generated artifacts.
#
# https://github.com/doublethinkco/cpp-ethereum-cross
#
# ------------------------------------------------------------------------------
# This file is part of cpp-ethereum-cross.
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
#
# Copyright (c) 2015-2016 Kitsilano Software Inc (https://doublethink.co)
#------------------------------------------------------------------------------


# ===========================================================================
set -e

INSTALL_DIR=${1?} && shift
WEBTHREE_BIN_DIR=${1?} && shift

RESULT_FILE_NAME="crosseth.tgz"

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
