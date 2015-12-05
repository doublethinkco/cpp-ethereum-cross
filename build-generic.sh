#!/bin/bash -e

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

