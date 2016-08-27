#!/bin/bash
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

set -e

# ===========================================================================
function check_args() {
  TARGET_SUBTYPE=${1?} && shift
  CROSS_COMPILER_PROVENANCE=${1?} && shift  
  [ "${TARGET_SUBTYPE?}" == "armel" -o "${TARGET_SUBTYPE?}" == "armhf" ] && [ "${CROSS_COMPILER_PROVENANCE?}" == "apt" -o "${CROSS_COMPILER_PROVENANCE?}" == "manual" ] || {
    echo "ERROR: TODO $TARGET_SUBTYPE $CROSS_COMPILER_PROVENANCE"
    exit 1
  }
  echo "args are valid"
}

# ===========================================================================
function contains() {
  STR=${1?} && shift # colon-separated
  TARGET=${1?}
  echo ${STR?} | tr ':' '\n' | awk '/^'"${TARGET?}"'$/'
}

# ===========================================================================
function fetch() {
  URL=${1?} && shift
  DESTINATION_DIR=${1?} && shift

  IS_GIT=$(echo "${URL?}" | awk '/\.git$/')
  if [ -n "${IS_GIT?}" ]; then
    fetch_git "${URL?}" "${DESTINATION_DIR?}"   
  else
    fetch_non_git "${URL?}" "${DESTINATION_DIR?}"
  fi
  
  find ${DESTINATION_DIR?} -maxdepth 1
}

# ---------------------------------------------------------------------------
function fetch_git() { # private
  URL=${1?} && shift
  DESTINATION_DIR=${1?} && shift
  
  git clone ${URL?} ${DESTINATION_DIR?} 2>&1
}

# ---------------------------------------------------------------------------
function fetch_non_git() { # private
  URL=${1?} && shift
  DESTINATION_DIR=${1?} && shift
  
   IS_TAR_GZ=$(echo "${URL?}" | awk '/\.tar.gz/ || /\.tgz/')
  IS_TAR_BZ2=$(echo "${URL?}" | awk '/\.tar.bz2/')
      IS_ZIP=$(echo "${URL?}" | awk '/\.zip/')

  TEMP_DIR=$(mktemp -d)
  
  # fetch tarball
  if [ -n "${IS_TAR_GZ?}" -o -n "${IS_TAR_BZ2?}" ]; then
    if [ -n "${IS_TAR_GZ?}" ]; then FLAG="z"; else FLAG="j"; fi
    wget -O- ${URL?} | tar ${FLAG?}x -C ${TEMP_DIR?} 2>&1 # TODO: can rename ouput dir too?  
    mv ${TEMP_DIR?}/* ${DESTINATION_DIR?}
    
  # fetch zip file
  elif [ -n "${IS_ZIP?}" ]; then # can't use stdin
    ZIP_FILE=${TEMP_DIR?}/tmp.zip  
    wget -O ${ZIP_FILE?} ${URL?} 2>&1
    unzip -d ${DESTINATION_DIR?} ${ZIP_FILE?}
    rm ${ZIP_FILE?}
    
  else
    echo "ERROR: unsupported extension for '${URL?}'"
    exit 1
  fi
  
  rmdir ${TEMP_DIR?}
}

# ===========================================================================
function generate_timestamp() {
  date '+%y%m%d%H%M%S'
}

# ===========================================================================
function section_downloading() {
  COMPONENT=${1?}
  section "downloading" ${COMPONENT?}
}

# ---------------------------------------------------------------------------
function section_configuring() {
  COMPONENT=${1?}
  section "configuring" ${COMPONENT?}
}

# ---------------------------------------------------------------------------
function section_cross_compiling() {
  COMPONENT=${1?}
  section "cross-compiling" ${COMPONENT?}
}

# ---------------------------------------------------------------------------
function section_compiling() {
  COMPONENT=${1?}
  section "compiling" ${COMPONENT?}
}

# ---------------------------------------------------------------------------
function section_installing() {
  COMPONENT=${1?}
  section "installing" ${COMPONENT?}
}

# ---------------------------------------------------------------------------
function section_hacking() {
  COMPONENT=${1?}
  section "hacking" ${COMPONENT?}
}

# ---------------------------------------------------------------------------
function section() {
  ACTION=${1?}
  TARGET=${2?}
  echo -e "\n\n"
  printf '=%.0s' {1..75}
  echo -e "\n${ACTION?}: ${TARGET?}\n\n"
}

# ===========================================================================
function export_cross_compiler() {
  export  CC=${GCC_CROSS_COMPILER?} # can't be readonly
  export CXX=${GXX_CROSS_COMPILER?} # can't be readonly

  # necessary for gmp and curl
  export PATH="$PATH:${CROSS_COMPILER_ROOT_DIR?}/bin"
}

# ---------------------------------------------------------------------------
function sanity_check_cross_compiler() {
  (echo $CC   | grep ${TARGET_ARCHITECTURE?} >&/dev/null && \
   echo $CXX  | grep ${TARGET_ARCHITECTURE?} >&/dev/null && \
   echo $PATH | tr ':' '\n' | xargs ls | grep ${TARGET_ARCHITECTURE?} >&/dev/null) || {
    echo "ERROR: CC and/or CXX and/or PATH are not properly configured: CC='$CC', CXX='$CXX', PATH='$PATH'"
    exit 1
  }
}

# ===========================================================================
function return_code() {
  CODE=${1?}
  echo -e "\nreturn code: '${CODE?}'"
}

# ===========================================================================
# populates CMake toolchain file (see http://www.vtk.org/Wiki/CMake_Cross_Compiling)
function get_cmake_toolchain_file_content() {
  cat << EOF
    SET(CMAKE_SYSTEM_NAME Linux)
    SET(CMAKE_SYSTEM_VERSION 1)
    SET(CMAKE_C_COMPILER     ${GCC_CROSS_COMPILER?})
    SET(CMAKE_CXX_COMPILER   ${GXX_CROSS_COMPILER?})
    SET(CMAKE_FIND_ROOT_PATH ${CROSS_COMPILER_ROOT_DIR?})
    SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
    SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
EOF
}

# ===========================================================================
function set_cmake_paths() {
  PACKAGES=${1?}
  set_cmake_library_path "${PACKAGES?}"
  set_cmake_include_path "${PACKAGES?}"
  check_cmake_paths
  format_cmake_paths
}

# ---------------------------------------------------------------------------
# TODO: generalize
function set_cmake_library_path() { # private
  LIBS=${1?}
  unset CMAKE_LIBRARY_PATH
  
  if [ -n "$(contains ${LIBS?} boost)" ]; then  
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/boost/lib"
  fi
  if [ -n "$(contains ${LIBS?} cryptopp)" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/cryptopp/lib"
  fi
  if [ -n "$(contains ${LIBS?} curl)" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/curl/lib"
  fi
  if [ -n "$(contains ${LIBS?} gmp)" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/gmp/lib"
  fi
  if [ -n "$(contains ${LIBS?} jsoncpp)" ]; then
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/jsoncpp/usr/local/lib"
  fi
  if [ -n "$(contains ${LIBS?} leveldb)" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/leveldb/lib"
  fi
  if [ -n "$(contains ${LIBS?} libjson-rpc-cpp)" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/libjson-rpc-cpp/usr/local/lib"
  fi    
  if [ -n "$(contains ${LIBS?} libmicrohttpd)" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${INSTALLS_DIR?}/libmicrohttpd/lib"
  fi
  CMAKE_LIBRARY_PATH=$(echo "$CMAKE_LIBRARY_PATH" | sed 's/^://')
  
  export CMAKE_LIBRARY_PATH
}

# ---------------------------------------------------------------------------
function set_cmake_include_path() { # private
  INCLUDES=${1?}
  unset CMAKE_INCLUDE_PATH
  
  if [ -n "$(contains ${INCLUDES?} boost)" ]; then
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${INSTALLS_DIR?}/boost/include"
  fi
  if [ -n "$(contains ${INCLUDES?} cryptopp)" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${SOURCES_DIR?}" # hack + see softlink hack in install-dependencies script
  fi
  if [ -n "$(contains ${INCLUDES?} curl)" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${INSTALLS_DIR?}/curl/include"
  fi
  if [ -n "$(contains ${INCLUDES?} gmp)" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${INSTALLS_DIR?}/gmp/include"
  fi
  if [ -n "$(contains ${INCLUDES?} jsoncpp)" ]; then
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${INSTALLS_DIR?}/jsoncpp/usr/local/include"
  fi
  if [ -n "$(contains ${INCLUDES?} leveldb)" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${INSTALLS_DIR?}/leveldb/include"
  fi
  if [ -n "$(contains ${INCLUDES?} libjson-rpc-cpp)" ]; then
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${INSTALLS_DIR?}/libjson-rpc-cpp/usr/local/include"
  fi
  if [ -n "$(contains ${INCLUDES?} libmicrohttpd)" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${INSTALLS_DIR?}/libmicrohttpd/include"
  fi
  CMAKE_INCLUDE_PATH=$(echo "$CMAKE_INCLUDE_PATH" | sed 's/^://')
      
  export CMAKE_INCLUDE_PATH
}

# ---------------------------------------------------------------------------
function check_cmake_paths() { # private
  for DIR in $(echo ${CMAKE_LIBRARY_PATH?} | tr ':' ' '); do
    [ -d "${DIR?}" ] || {
      echo "ERROR: '${DIR?}' does not exist."
      exit 1
    }
  done
}

# ---------------------------------------------------------------------------
function format_cmake_paths() { # private
  echo -e "CMAKE_LIBRARY_PATH:\n\n$(echo ${CMAKE_LIBRARY_PATH?} | tr ':' '\n')\n\n"
  echo -e "CMAKE_INCLUDE_PATH:\n\n$(echo ${CMAKE_INCLUDE_PATH?} | tr ':' '\n')\n\n"

  echo
  echo "export CMAKE_LIBRARY_PATH=${CMAKE_LIBRARY_PATH?}"
  echo  
  echo "export CMAKE_INCLUDE_PATH=${CMAKE_INCLUDE_PATH?}"
  echo  
}

# ===========================================================================
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
function clone() {
  ORIGIN=${1?} && shift
  TARGET=${1?} && shift
  echo "cloning dir: '${ORIGIN?}' to '${TARGET?}'"
  cp -r ${ORIGIN?} ${TARGET?} # so as to not pollute the original dir (makes git commits more difficult)
}

# ---------------------------------------------------------------------------
function cd_clone() {
  ORIGIN=${1?} && shift
  TARGET=${1?} && shift
  clone ${ORIGIN?} ${TARGET?}
  cd ${TARGET?}
  printf '=%.0s' {1..75} && echo && pwd
}

# ---------------------------------------------------------------------------
function cd_if_not_exists() { # TODO: rename
  DIR=${1?}
  mkdir -p ${DIR?}
  cd ${DIR?}
  printf '=%.0s' {1..75} && echo && pwd
}

# ---------------------------------------------------------------------------
function cd_if_exists() {
  DIR=${1?}
  if [ ! -d ${DIR?} ]; then
    read -p "please create dir first:\n  ${DIR?}"
  fi
  cd ${DIR?}
  printf '=%.0s' {1..75} && echo && pwd
}

# ===========================================================================
function ct_ng_to_awk_script() {
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
function ct_ng_quick_cleanup() { # removes empty lines/comments and trims
  awk '!/^ *$/ && !/^ *#/{sub(/^ */,"");sub(/ *$/,"");print}'
}

# ---------------------------------------------------------------------------
function ct_ng_config_hack() {
  FILE=${1?} && shift
  CHANGES_FILE=${1?} && shift
  
  AWK_SCRIPT=$(cat ${CHANGES_FILE?} | ct_ng_quick_cleanup | cut -d',' -f1 | ct_ng_to_awk_script)
  echo -e "using:\n\tawk '${AWK_SCRIPT?}' ${FILE?}"

  generic_hack ${FILE?} "${AWK_SCRIPT?}" 
}

# ===========================================================================

export -f check_args
export -f contains
export -f fetch
export -f fetch_git
export -f fetch_non_git
export -f generate_timestamp
export -f section_downloading
export -f section_configuring
export -f section_cross_compiling
export -f section_compiling
export -f section_installing
export -f section_hacking
export -f section
export -f export_cross_compiler
export -f sanity_check_cross_compiler
export -f return_code
export -f get_cmake_toolchain_file_content
export -f set_cmake_paths
export -f set_cmake_library_path
export -f set_cmake_include_path
export -f check_cmake_paths
export -f format_cmake_paths
export -f generic_hack
export -f clone
export -f cd_clone
export -f cd_if_not_exists
export -f cd_if_exists
export -f ct_ng_to_awk_script
export -f ct_ng_quick_cleanup
export -f ct_ng_config_hack

# ===========================================================================

