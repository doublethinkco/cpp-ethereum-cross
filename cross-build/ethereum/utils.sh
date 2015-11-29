#!/bin/bash
#
# @author: Anthony Cros
#

set -e

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
  
   IS_TAR_GZ=$(echo "${URL?}" | awk '/\.tar.gz/')
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
   echo $PATH | grep ${TARGET_ARCHITECTURE?} >&/dev/null) || {
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
  export PATH="${CMAKE_INSTALL_DIR?}/usr/local/bin:$PATH"
}

# ---------------------------------------------------------------------------
# TODO: generalize
function set_cmake_library_path() { # private
  LIBS=${1?}
  unset CMAKE_LIBRARY_PATH
  
  if [ -n "$(contains ${LIBS?} ${LIBSCRYPT?})" ]; then
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${LIBSCRYPT_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${JSONCPP?})" ]; then
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${JSONCPP_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${BOOST?})" ]; then  
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${BOOST_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${LEVELDB?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${LEVELDB_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${CRYPTOPP?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${CRYPTOPP_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${GMP?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${GMP_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${CURL?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${CURL_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${LIBJSON_RPC_CPP?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${LIBJSON_RPC_CPP_INSTALL_DIR?}/lib"
  fi    
  if [ -n "$(contains ${LIBS?} ${MHD?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${MHD_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${LIBWEB3CORE?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${LIBWEB3CORE_INSTALL_DIR?}/lib"
  fi
  if [ -n "$(contains ${LIBS?} ${LIBETHEREUM?})" ]; then      
    CMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH:${LIBETHEREUM_INSTALL_DIR?}/lib"
  fi
  CMAKE_LIBRARY_PATH=$(echo "$CMAKE_LIBRARY_PATH" | sed 's/^://')
  
  export CMAKE_LIBRARY_PATH
}

# ---------------------------------------------------------------------------
function set_cmake_include_path() { # private
  INCLUDES=${1?}
  unset CMAKE_INCLUDE_PATH
  
  if [ -n "$(contains ${INCLUDES?} ${LIBSCRYPT?})" ]; then
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${LIBSCRYPT_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${JSONCPP?})" ]; then
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${JSONCPP_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${BOOST?})" ]; then
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${BOOST_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${LEVELDB?})" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${LEVELDB_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${CRYPTOPP?})" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${SOURCES_DIR?}" # hack + see softlink hack in install-dependencies script
  fi
  if [ -n "$(contains ${INCLUDES?} ${GMP?})" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${GMP_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${CURL?})" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${CURL_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${LIBJSON_RPC_CPP?})" ]; then
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${LIBJSON_RPC_CPP_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${MHD?})" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${MHD_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${LIBWEB3CORE?})" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${LIBWEB3CORE_INSTALL_DIR?}/include"
  fi
  if [ -n "$(contains ${INCLUDES?} ${LIBETHEREUM?})" ]; then    
    CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH:${LIBETHEREUM_INSTALL_DIR?}/include"
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

# ===========================================================================
function backupdir() {
  DIR_PATH=${1?} && shift
  BAK_DIR_PATH="${BACKUPS_DIR?}/bak${DIR_PATH////--}.$(generate_timestamp).bak" # replace '/' with '--'
  echo "backing up dir first: '${DIR_PATH?}' to '${BAK_DIR_PATH?}.tgz'"
  mv -i ${DIR_PATH?} ${BAK_DIR_PATH?}
  tar -C ${BAK_DIR_PATH?}/.. --remove-files -zcf ${BAK_DIR_PATH?}.tgz ./$(basename ${BAK_DIR_PATH?})
}

# ===========================================================================
function backup_potential_install_dir() {
  INSTALL_DIR=${1?}
  if [ -d ${INSTALL_DIR?} ]; then backupdir ${INSTALL_DIR?}; fi
}

# ---------------------------------------------------------------------------
function clone() {
  ORIGIN=${1?} && shift
  TARGET=${1?} && shift
  if [ -d ${TARGET?} ]; then backupdir ${TARGET?}; fi
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
  if [ -d ${DIR?} ]; then backupdir ${DIR?}; fi
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
