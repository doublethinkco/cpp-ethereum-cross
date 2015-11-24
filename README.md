# webthree-umbrella-cross

Repository containing a Docker file for cross-compilation of the
components which comprise "webthree-umbrella", the C++ implementation
of
[Ethereum](http://ethereum.org/).
That codebase is also referred to as cpp-ethereum,
TurboEthereum and Hardcore Ethereum in various places.

# How to use it

* git clone https://github.com/doublethinkco/webthree-umbrella-cross.git
* cd webthree-umbrella-cross
* docker build .
* docker run -i -t <hash> /bin/bash
* And then inside that docker container
** ./main.sh ~/x-tools/arm-unknown-linux-gnueabi
* You end up with a TGZ file in the ~ directory
* From outside of the container
** docker cp <hash>:/<filename>.tgz ~/filename.tgz
* If you are running this in a VM then copy it back out with something like:
** scp <machine>:/filename.tgz ~

![Webthree](https://ipfs.pics/ipfs/QmU5DL8HnBvn3FpHBCFX69suLpSh2qCBZKg1FzmUfBiDX5)

This support was developed by
[Bob Summerwill](http://bobsummerwill.com)
and
[Anthony Cros](https://github.com/anthony-cros) to
bring Ethereum to mobile/wearable Linux platforms for
[doublethinkco](http://doublethink.co),
with the intention of contributing it back to the community.

See http://doublethink.co/2015/09/22/porting-ethereum-to-mobile-linux/

At the time of writing, this cross-compilation process only supports
the building of ARM binaries, and specifically 'armel' binaries for
armv7 and software floating-point ABI.  These binaries are very
generic and should work on many, many devices.  We will look at other
ARM ABIs and at x86/x64 support later.

* Tizen OS
* Sailfish OS
* Ubuntu Phone
* Android
* iOS

See https://github.com/doublethinkco/webthree-umbrella-cross/issues/10

boot2docker on Mac does not "just work" when installed.  Here are the
commands you will inevitably forget whenever you reboot or start a new
terminal session:

http://stackoverflow.com/questions/29594800/docker-tls-error-on-mac/

# High priority issues

* finish dot file
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/16
* Create go-ethereum-cross repo
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/29
* Dockerfile: apply light client PR to go-ethereum-cross
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/24
* test run PR on existing container
* https://github.com/doublethinkco/webthree-umbrella-cross/issues/23
* Document how to attach GDB
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/28
* try geth ARM binary on sailfish
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/21
* try geth ARM binary on Ubuntu Touch
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/22
* try geth ARM binary on Android
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/26
* try geth ARM binary on iOS
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/27
* eth run time error on Tizen
** https://github.com/doublethinkco/webthree-umbrella-cross/issues/20

Copyright (c) 2015 Kitsilano Software Inc
