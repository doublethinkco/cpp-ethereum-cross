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
if [ -n "$(contains ${COMPONENTS?} ${BOOST?})" ]; then  
  section_downloading ${BOOST?}
  fetch ${BOOST_DOWNLOAD_URL?} ${BOOST_BASE_DIR?}
  return_code $?
else
  echo "skipping ${BOOST?}"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} ${JSONCPP?})" ]; then
  section_downloading ${JSONCPP?}
  fetch ${JSONCPP_DOWNLOAD_URL?} ${JSONCPP_BASE_DIR?}
  return_code $?
else
  echo "skipping ${JSONCPP?}"
fi


# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} ${LEVELDB?})" ]; then
  section_downloading ${LEVELDB?}
  fetch ${LEVELDB_DOWNLOAD_URL?} ${LEVELDB_BASE_DIR?}
  return_code $?
else
  echo "skipping ${LEVELDB?}"
fi


# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} cryptopp)" ]; then 
  section_downloading cryptopp
  fetch ${CRYPTOPP_DOWNLOAD_URL?} ${CRYPTOPP_BASE_DIR?}
  return_code $?
else
  echo "skipping cryptopp"
fi


# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} ${GMP?})" ]; then 
  section_downloading ${GMP?}
  fetch ${GMP_DOWNLOAD_URL?} ${GMP_BASE_DIR?}
  return_code $?

else
  echo "skipping ${GMP?}"
fi


# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} ${CURL?})" ]; then 
  section_downloading ${CURL?}
  fetch ${CURL_DOWNLOAD_URL?} ${CURL_BASE_DIR?}
  return_code $?
else
  echo "skipping ${CURL?}"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} ${LIBJSON_RPC_CPP?})" ]; then 
  section_downloading ${LIBJSON_RPC_CPP?}
  fetch ${LIBJSON_RPC_CPP_DOWNLOAD_URL?} ${LIBJSON_RPC_CPP_BASE_DIR?}
  return_code $?
else
  echo "skipping ${LIBJSON_RPC_CPP?}"
fi

# ---------------------------------------------------------------------------
if [ -n "$(contains ${COMPONENTS?} ${MHD?})" ]; then 
  section_downloading ${MHD?}
  fetch ${MHD_DOWNLOAD_URL?} ${MHD_BASE_DIR?}
  return_code $?
else
  echo "skipping ${MHD?}"
fi


# ===========================================================================

section_downloading "done"
tree -L 2 ${BASE_DIR?}


# ===========================================================================

