#!/bin/bash
docker build \
  -t xcompiler \
  -f Dockerfile-xcompiler \
  .
docker run \
   -t xcompiler \
  ./ct-ng.sh \
    /home/xcompiler/ct-ng \
    "conf/wandboard.config" \
    "arm-unknown-linux-gnueabi" \
    "1.20.0"

