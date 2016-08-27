#!/bin/bash
# configures, cross-compiles and installs CryptoPP (https://www.cryptopp.com/)
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
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
cd ${SOURCES_DIR?}/cryptopp && git checkout ${CRYPTOPP_VERSION?}
export_cross_compiler && sanity_check_cross_compiler
cd_clone ${SOURCES_DIR?}/cryptopp ${WORK_DIR?}/cryptopp


# ---------------------------------------------------------------------------
make clean
return_code $?


# ===========================================================================
# configuration: no configuration phase (bare Makefile), but hack needed

# hack
section_hacking cryptopp
generic_hack ./GNUmakefile '!/=native/'

# hack sanity check
grep '=native' ./GNUmakefile.bak
grep '=native' ./GNUmakefile && exit 1 || :


# ===========================================================================
# cross-compile:

section_cross_compiling cryptopp
make -j2
return_code $?


# ===========================================================================
# install: DESTDIR does not work, so emulate

section_installing cryptopp
mkdir ${INSTALLS_DIR?}/cryptopp
rm ${INSTALLS_DIR?}/cryptopp/lib 2>&- || :
rm $HOME/cryptopp 2>&- || :
mkdir ${INSTALLS_DIR?}/cryptopp/lib
cp    ${WORK_DIR?}/cryptopp/lib*    ${INSTALLS_DIR?}/cryptopp/lib
ln -s ${WORK_DIR?}/cryptopp $HOME/cryptopp # hack: somehow this is necessary for includes to work with cryptopp


# ===========================================================================

section "done" cryptopp
tree -L 3 "${INSTALLS_DIR?}/cryptopp"
