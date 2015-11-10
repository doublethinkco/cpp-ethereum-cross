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

FROM ubuntu:utopic
MAINTAINER Bob Summerwill <bob@summerwill.net>

# Additional repository so we can get cmake 3.x.  The default package
# repository for Ubuntu only has an older version.
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:george-edison55/cmake-3.x

# These are probably NOT entirely minimal, but that's OK.
RUN apt-get update && apt-get install -y \
  cmake \
  git \
  tree \
  openssh-server \
  curl \
  wget \
  man \
  unzip \
  bzip2 \
  p7zip \
  xz-utils \
  build-essential \
  cmake \
  locate \
  g++ \
  make \
  gawk \
  bison \
  flex \
  texinfo \
  gawk \
  automake \
  libtool \
  cvs \
  ncurses-dev \
  gperf \
  libexpat1-dev

# Switch to a normal user account.  crosstool-ng refuses to run as root.
RUN useradd -ms /bin/bash xcompiler
USER xcompiler
WORKDIR /home/xcompiler/

# Clone the sandbox repo into the docker container and then build the cross-compiler.
# The fact that we are using the same repo from the "outside" and the "inside" is
# probably indicative of incorrect boundaries.   The split will be wrong.
RUN git clone https://github.com/doublethinkco/sandbox.git ~/sandbox/
RUN ~/sandbox/cpp-ethereum/scripts/xcompiler.sh ~/crosstool-ng/
