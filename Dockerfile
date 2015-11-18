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

# TODO - Is this 'apt-get update' required?  It it desirable?  We are
# explicitly specifying versions for all packages now, so this would not
# affect the versioning for the direct dependencies.   I suppose it still
# has an effect on the versions used for indirect dependencies, which will
# still use "latest", and which we are still abdicating control over.
# Is that problematic?  Maybe, maybe not.
RUN apt-get update

# External packages required by our scripts themselves
RUN apt-get install -y \
  bzip2=1.0.6-5 \
    git=1:1.9.1-1ubuntu0.1 \
   tree=1.6.0-1 \
  unzip=6.0-9ubuntu1.5 \
   wget=1.15-1ubuntu1.14.04.1

# External packages required by crosstool-ng
RUN apt-get install -y \
       automake=1:1.14.1-2ubuntu1 \
          bison=2:3.0.2.dfsg-2 \
            cvs=2:1.12.13+real-12 \
           flex=2.5.35-10.1ubuntu2 \
           gawk=1:4.0.1+dfsg-2.1ubuntu2 \
          gperf=3.0.4-1 \
  libncurses5-dev=5.9+20140118-1ubuntu1 \
        libtool=2.4.2-1.7ubuntu1 \
  libexpat1-dev=2.1.0-4ubuntu1.1 \
        texinfo=5.2.0.dfsg.1-2

# External packages required to build a newer version of cmake  
#
# TODO - Do we *need* to build cmake, or should we just get a
# newer prebuilt binary package from a specific PPA?   What is
# the specific requirement we are trying to meet?   Is this
# for cmake usage within the cross-compiler build?
RUN apt-get install -y \
  build-essential=11.6ubuntu6 \
            cmake=2.8.12.2-0ubuntu3

# Switch to a normal user account.  crosstool-ng refuses to run as root.
RUN useradd -ms /bin/bash xcompiler
USER xcompiler

# Clone the sandbox repo into the docker container, including sub-modules
WORKDIR /home/xcompiler
RUN git clone --recursive https://github.com/doublethinkco/webthree-umbrella.git

# Build the cross-compiler
WORKDIR /home/xcompiler/webthree-umbrella/cross-build/ct-ng
RUN ./ct-ng.sh ~/ct-ng "arm-unknown-linux-gnueabi" "1.20.0"

# Use that cross-compiler to build the ARM executable
WORKDIR /home/xcompiler/webthree-umbrella/cross-build/ethereum
#RUN ./main.sh ~/x-tools/arm-unknown-linux-gnueabi
