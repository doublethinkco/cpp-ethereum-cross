#!/bin/bash -e
DEST_DIR=$1; DEST_DIR=${DEST_DIR:="/tmp"}
./build-generic.sh \
  "crosseth" \
  "${DEST_DIR?}" \
  "./cross-build/ethereum/main.sh" "armhf" "manual"

