#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script to download all external dependencies, each of which needs
# cross-building before we can cross-build cpp-ethereum itself.
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


# ---------------------------------------------------------------------------
set -e
([ -n "$SETUP" ] && ${SETUP?}) || source ./setup.sh $*


# ---------------------------------------------------------------------------
section_downloading boost
fetch ${BOOST_DOWNLOAD_URL?} ${SOURCES_DIR?}/boost
return_code $?

# ---------------------------------------------------------------------------
section_downloading cryptopp
fetch ${CRYPTOPP_DOWNLOAD_URL?} ${SOURCES_DIR?}/cryptopp
return_code $?

# ---------------------------------------------------------------------------
section_downloading curl
fetch ${CURL_DOWNLOAD_URL?} ${SOURCES_DIR?}/curl
return_code $?

# ---------------------------------------------------------------------------
section_downloading gmp
fetch ${GMP_DOWNLOAD_URL?} ${SOURCES_DIR?}/gmp
return_code $?

# ---------------------------------------------------------------------------
section_downloading jsoncpp
fetch ${JSONCPP_DOWNLOAD_URL?} ${SOURCES_DIR?}/jsoncpp
return_code $?

# ---------------------------------------------------------------------------
section_downloading leveldb
fetch ${LEVELDB_DOWNLOAD_URL?} ${SOURCES_DIR?}/leveldb
return_code $?

# ---------------------------------------------------------------------------
section_downloading libjson-rpc-cpp
fetch ${LIBJSON_RPC_CPP_DOWNLOAD_URL?} ${SOURCES_DIR?}/libjson-rpc-cpp
return_code $?

# ---------------------------------------------------------------------------
section_downloading libmicrohttpd
fetch ${MHD_DOWNLOAD_URL?} ${SOURCES_DIR?}/libmicrohttpd
return_code $?

# ---------------------------------------------------------------------------
section_downloading "done"
tree -L 2 ${BASE_DIR?}
