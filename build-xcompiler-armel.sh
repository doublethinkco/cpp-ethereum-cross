#!/bin/bash
docker build \
  -t xcompiler \
  -f Dockerfile-xcompiler \
  .
docker run \
   -t xcompiler \
  ./ct-ng.sh \
    /home/xcompiler/ct-ng \
    "none" \
    "arm-unknown-linux-gnueabi" \
    "1.20.0" # "none" is a special value, as opposed to a file path
