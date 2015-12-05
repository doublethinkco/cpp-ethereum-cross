#!/bin/bash -e
DEST_DIR=$1; DEST_DIR=${DEST_DIR:="/tmp"}
./build-generic.sh \
  "xcompiler" \
  "${DEST_DIR?}" \
  "./ct-ng.sh" \
    "/home/xcompiler/ct-ng" \
    "conf/wandboard.config" \
    "arm-unknown-linux-gnueabihf"

