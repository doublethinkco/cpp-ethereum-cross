#!/bin/bash
# configures, cross-compiles and installs libjson RPC CPP (https://github.com/cinemast/libjson-rpc-cpp)
# depends on CUrl (see dedicated script)
# @author: Anthony Cros

# ===========================================================================
set -e
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
COMPONENT=${LIBJSON_RPC_CPP?}
cd ${LIBJSON_RPC_CPP_BASE_DIR?} && git checkout ${LIBJSON_RPC_CPP_VERSION?}
cd_if_not_exists ${LIBJSON_RPC_CPP_WORK_DIR?}
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration:

section_configuring ${COMPONENT?}
set_cmake_paths "${JSONCPP?}:${CURL?}:${MHD?}"
cmake \
   ${LIBJSON_RPC_CPP_BASE_DIR?} \
  -DCMAKE_VERBOSE_MAKEFILE=true \
  -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE?} \
  -DHTTP_SERVER=YES \
  -DHTTP_CLIENT=YES \
  -DUNIX_DOMAIN_SOCKET_SERVER=NO \
  -DUNIX_DOMAIN_SOCKET_CLIENT=NO \
  -DCOMPILE_TESTS=NO \
  -DCOMPILE_STUBGEN=NO \
  -DCOMPILE_EXAMPLES=NO # watch for UNIX_DOMAIN_SOCKET_SERVER spelling (TODO: detail)
return_code $?


# ===========================================================================
# cross-compile:

section_cross_compiling ${COMPONENT?}

# somehow these aren't available as is (throws a lot of warnings and eventually dies for lack of finding curl.h)
generic_hack ./src/jsonrpccpp/CMakeFiles/jsonrpccommon.dir/flags.make '{gsub(/^CXX_FLAGS = /,"CXX_FLAGS = -std=c++11 -isystem'${CURL_INSTALL_DIR}'/include ")}1'
generic_hack ./src/jsonrpccpp/CMakeFiles/jsonrpcserver.dir/flags.make '{gsub(/^CXX_FLAGS = /,"CXX_FLAGS = -std=c++11 -isystem'${CURL_INSTALL_DIR}'/include ")}1'
generic_hack ./src/jsonrpccpp/CMakeFiles/jsonrpcclient.dir/flags.make '{gsub(/^CXX_FLAGS = /,"CXX_FLAGS = -std=c++11 -isystem'${CURL_INSTALL_DIR}'/include ")}1'

make
return_code $?


# ===========================================================================
# install:

section_installing ${COMPONENT?}
backup_potential_install_dir ${LIBJSON_RPC_CPP_INSTALL_DIR?}
make DESTDIR="${LIBJSON_RPC_CPP_INSTALL_DIR?}" install
return_code $?

# homogenization
ln -s ${LIBJSON_RPC_CPP_INSTALL_DIR?}/usr/local/lib     ${LIBJSON_RPC_CPP_INSTALL_DIR?}/lib
ln -s ${LIBJSON_RPC_CPP_INSTALL_DIR?}/usr/local/include ${LIBJSON_RPC_CPP_INSTALL_DIR?}/include


# ===========================================================================

section "done" ${COMPONENT?}
tree ${LIBJSON_RPC_CPP_INSTALL_DIR?}


# ===========================================================================
