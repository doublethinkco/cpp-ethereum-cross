#!/bin/bash -e
DEST_DIR=${1?}; if [ ! -w "${DEST_DIR?}" ]; then echo "ERROR: cannot write to the destination dir provided: '${DEST_DIR?}'"; exit 1; fi
./build-xcompiler-base.sh
CONTAINER_ID=$(date "+%y%m%d%H%M%S")
docker run \
   --name="${CONTAINER_ID?}" \
   -t xcompiler \
  ./ct-ng.sh \
    "/home/xcompiler/ct-ng" \
    "conf/wandboard.config" \
    "arm-unknown-linux-gnueabi" \
    "1.20.0"
docker cp \
  ${CONTAINER_ID?}:/home/xcompiler/x-tools.tgz \
  ${DEST_DIR?}/
ls ${DEST_DIR?}/x-tools.tgz

