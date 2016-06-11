#!/bin/bash
# downloads all components and dependencies (this will take a while)
# @author: Anthony Cros

# TODO: turn into loop

# ===========================================================================
set -e

COMPONENTS=${1?} && shift # e.g "cmake:curl:mhd"
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
  echo "skipping leveldb
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
if [ -n "$(contains ${COMPONENTS?} gmp)" ]; then 
  section_downloading gmp
  fetch ${GMP_DOWNLOAD_URL?} ${SOURCES_DIR?}/gmp
  return_code $?

else
  echo "skipping gmp"
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

