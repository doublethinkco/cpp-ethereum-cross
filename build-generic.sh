#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Building-block bash script which uses docker to cross-build cpp-ethereum
# for ARM Linux.
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

GOAL=${1?} && shift # "xcompiler" or "cross-eth"
DEST_DIR=${1?} && shift
SCRIPT=${1?} && shift
ARGS=$*

if [ ! -w "${DEST_DIR?}" ]; then
  echo "ERROR: cannot write to the destination dir provided: '${DEST_DIR?}'"
  exit 1
fi

if [ ! -f "./cross-build/ethereum/utils.sh" ]; then echo "ERROR: wrong pwd"; exit 1; fi
source ./cross-build/ethereum/utils.sh

# build corresponding base image
docker build \
  -t ${GOAL?} \
  -f Dockerfile-${GOAL?} \
  .

# actually run command
CONTAINER_ID=$(generate_timestamp)
cd $(dirname ${SCRIPT?})
docker run \
   --name="${CONTAINER_ID?}" \
   -t ${GOAL?} \
   ./$(basename ${SCRIPT?}) ${ARGS?}
    
# fetch result from container
docker cp \
  ${CONTAINER_ID?}:/home/${GOAL?}/${GOAL?}.tgz \
  ${DEST_DIR?}/
  
# check for presence
ls ${DEST_DIR?}/${GOAL?}.tgz

