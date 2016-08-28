#!/bin/bash
# downloads all components and dependencies (this will take a while)
#
# TODO: turn into loop
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

COMPONENTS=${1?} && shift # e.g "curl:mhd"
if [ ! -f "./setup.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
([ -n "$SETUP" ] && ${SETUP?}) || source ./setup.sh $*


# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} boost)" ]; then  
  section_downloading boost
  fetch ${BOOST_DOWNLOAD_URL?} ${SOURCES_DIR?}/boost
  return_code $?
else
  echo "skipping boost"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} cryptopp)" ]; then 
  section_downloading cryptopp
  fetch ${CRYPTOPP_DOWNLOAD_URL?} ${SOURCES_DIR?}/cryptopp
  return_code $?
else
  echo "skipping cryptopp"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} curl)" ]; then 
  section_downloading curl
  fetch ${CURL_DOWNLOAD_URL?} ${SOURCES_DIR?}/curl
  return_code $?
else
  echo "skipping curl"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} gmp)" ]; then 
  section_downloading gmp
  fetch ${GMP_DOWNLOAD_URL?} ${SOURCES_DIR?}/gmp
  return_code $?

else
  echo "skipping gmp"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} jsoncpp)" ]; then
  section_downloading jsoncpp
  fetch ${JSONCPP_DOWNLOAD_URL?} ${SOURCES_DIR?}/jsoncpp
  return_code $?
else
  echo "skipping jsoncpp"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} leveldb)" ]; then
  section_downloading leveldb
  fetch ${LEVELDB_DOWNLOAD_URL?} ${SOURCES_DIR?}/leveldb
  return_code $?
else
  echo "skipping leveldb"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} libjson-rpc-cpp)" ]; then 
  section_downloading libjson-rpc-cpp
  fetch ${LIBJSON_RPC_CPP_DOWNLOAD_URL?} ${SOURCES_DIR?}/libjson-rpc-cpp
  return_code $?
else
  echo "skipping libjson-rpc-cpp"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} libmicrohttpd)" ]; then 
  section_downloading libmicrohttpd
  fetch ${MHD_DOWNLOAD_URL?} ${SOURCES_DIR?}/libmicrohttpd
  return_code $?
else
  echo "skipping libmicrohttpd"
fi


# ===========================================================================

section_downloading "done"
tree -L 2 ${BASE_DIR?}


# ===========================================================================

