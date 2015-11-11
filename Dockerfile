#-------------------------------------------------------------------------------
# Dockerfile for cross-compilation of Ethereum C++ components for mobile
# Linux platforms such as Tizen, Sailfish and Ubuntu Touch.
#
# See http://ethereum.org/ to learn more about Ethereum.
# See http://doublethink.co/ to learn more about doublethinkco
#
# boot2docker on Mac does not "just work" when installed.  Here are the
# commands you will inevitably forget whenever you reboot or start a new
# terminal session:
# http://stackoverflow.com/questions/29594800/docker-tls-error-on-mac/
#
# (c) 2015 Kitsilano Software Inc
#-------------------------------------------------------------------------------

FROM ubuntu:14.04
MAINTAINER Bob Summerwill <bob@summerwill.net>

# Dependencies below are probably NOT entirely minimal, but that's OK.
RUN apt-get update

# Required by our scripts themselves
# TODO: fix unzip=6.0-9ubuntu1.4, somehow not found
RUN apt-get install -y \
  git=1:1.9.1-1ubuntu0.1 \
  wget=1.15-1ubuntu1.14.04.1 \
  unzip \
  bzip2=1.0.6-5 \
  tree=1.6.0-1

# Required by crosstool-ng
RUN apt-get install -y \
  bison=2:3.0.2.dfsg-2 \
  flex=2.5.35-10.1ubuntu2 \
  texinfo=5.2.0.dfsg.1-2 \
  libtool=2.4.2-1.7ubuntu1 \
  cvs=2:1.12.13+real-12 \
  gperf=3.0.4-1 \
  libexpat1-dev=2.1.0-4ubuntu1.1

# Required to build a newer version of cmake  
RUN apt-get install -y \
  cmake=2.8.12.2-0ubuntu3 \
  build-essential=11.6ubuntu6
   
# Switch to a normal user account.  crosstool-ng refuses to run as root.
RUN useradd -ms /bin/bash xcompiler
USER xcompiler

ENV WEBTHREE_UMBRELLA_DIR /home/xcompiler/webthree-umbrella

# Clone the sandbox repo into the docker container and then build the cross-compiler.
RUN git clone https://github.com/doublethinkco/webthree-umbrella.git $WEBTHREE_UMBRELLA_DIR

WORKDIR $WEBTHREE_UMBRELLA_DIR/webthree-umbrella-cross/ct-ng
RUN ./ct-ng.sh ~/ct-ng "arm-unknown-linux-gnueabi" "1.20.0" # will produce /home/xcompiler/x-tools/arm-unknown-linux-gnueabi

WORKDIR $WEBTHREE_UMBRELLA_DIR/webthree-umbrella-cross/ethereum

RUN ./main.sh /home/xcompiler/x-tools/arm-unknown-linux-gnueabi
