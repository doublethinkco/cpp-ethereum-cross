# webthree-umbrella-cross

Repository containing a Docker file for cross-compilation of the
components which comprise "webthree-umbrella", the C++ implementation
of Ethereum.   That codebase is also referred to as cpp-ethereum,
TurboEthereum and Hardcore Ethereum in various places.

See http://ethereum.org/ to learn more about Ethereum

https://ipfs.pics/QmYj2TSuqp3tRJCRMUyu1Nm5LoMnkaTZ5pnENomx9YKUtf

This support was developed by Bob Summerwill and Anthony Cros to
bring Ethereum to mobile/wearable Linux platforms for doublethinkco,
with the intention of contributing it back to the community.

See http://doublethink.co/2015/09/22/porting-ethereum-to-mobile-linux/

See http://doublethink.co/ to learn more about doublethinkco

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
