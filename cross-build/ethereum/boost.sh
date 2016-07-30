#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script for cross-building Boost for ARM Linux devices.
#
# http://www.boost.org/
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
SCRIPT_DIR=$(dirname $0) && ([ -n "$SETUP" ] && ${SETUP?}) || source ${SCRIPT_DIR?}/setup.sh $*
cd_clone ${SOURCES_DIR?}/boost ${WORK_DIR?}/boost
export_cross_compiler && sanity_check_cross_compiler


# ===========================================================================
# configuration: Boost.Build

section_configuring boost
readonly BOOST_LIBRARIES="chrono,filesystem,regex,random,thread,date_time,program_options,test" # test --> unit_test_framework (throws warnings...)
./bootstrap.sh --with-libraries="${BOOST_LIBRARIES?}" # TODO: how to use an actual work dir rather than current dir?
return_code $?


# ---------------------------------------------------------------------------
section_hacking boost
generic_hack \
  ./project-config.jam \
  '{gsub(/using gcc/,"using gcc : arm : '${GCC_CROSS_COMPILER?}'")}1'
grep ${GCC_CROSS_COMPILER_PATTERN?} ./project-config.jam 2>&-  || { echo "ERROR: could not find '${GCC_CROSS_COMPILER?}' in project-config.jam"; exit 1; } # sanity check


# ===========================================================================
# cross-compile:

section_cross_compiling boost
./b2 \
  install \
  -j 8 \
  --debug-configuration \
  --prefix=${INSTALLS_DIR?}/boost # also installs (expect some warnings) - takes a while
return_code $?


# ===========================================================================
# install:

section_installing boost
ls ${INSTALLS_DIR?}/boost/lib/libboost_*.a # sanity check; already installed (see previous step)
return_code $?


# ===========================================================================

section "done" boost
tree -L 2 "${INSTALLS_DIR?}/boost"


# ===========================================================================
