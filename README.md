# webthree-umbrella-cross

Repository containing Docker files for cross-compilation of the
components within the "webthree umbrella".

[Gavin Wood](https://github.com/gavofyork) says ...

    The many names reflect the fact that it is not a single project.
    Rather it's a collection of software that just happens to have
    a team (mostly) in common.
    
    cpp-ethereum is the historical name.
    webthree is the name for the repository implementing the webthree framework
    eth is the name for the webthree client (historical; should be renamed to web3 at some point)
    ++eth is its sometime "stylish" name.
    Aleth* are the GUIs
    TurboEthereum is the stylish name for the C++ core.

This cross-build support was developed by under GPLv2 by
[Bob Summerwill](http://bobsummerwill.com)
and
[Anthony Cros](https://github.com/anthony-cros) to
bring Ethereum to mobile/wearable Linux platforms for
[doublethinkco](http://doublethink.co),
with the intention of contributing the support back to the community.

See [Porting Ethereum to Mobile Linux](http://doublethink.co/2015/09/22/porting-ethereum-to-mobile-linux/)
blog for an overview.

# How to use it

Clone this repo and build and run [Dockerfile-eth](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-eth):

    $ git clone https://github.com/doublethinkco/webthree-umbrella-cross.git
    $ cd webthree-umbrella-cross
    $ sudo docker build -f Dockerfile-eth .
    $ sudo docker run -i -t HASH /bin/bash

You end up with a TGZ file in the ~ directory inside that container,
which you can copy out to the host machine like so ...

    $ sudo docker cp HASH:/FILENAME.tgz ~/

If your host machine is a VM (maybe a CoreOS instance in AWS or Azure)
then you can copy that back with something like ...

    $ scp VM_IP_ADDRESS:/home/xcompiler/FILENAME.tgz ~

# Dependency graph for the Webthree components

![Webthree](https://ipfs.pics/ipfs/QmPoeqadSbjshYZeibtTgdkXAXCyvCtsrejSe8xY2hSure)

# Limitations

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

* Infrastructure
    * [Generalize cross-build scripts to support armhf, i386 and x86_64](https://github.com/doublethinkco/webthree-umbrella-cross/issues/10)
* Eth porting (C++ client)
    * [Get to a working eth binary for Sailfish](https://github.com/doublethinkco/webthree-umbrella-cross/issues/21)
    * [Get to a working eth binary for Tizen](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)
    * [Get to a working eth binary for Ubuntu Touch](https://github.com/doublethinkco/webthree-umbrella-cross/issues/3)
    * [Get to a working eth binary for Android](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36)
    * [Get to a working eth binary for iOS](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36)
* Geth (go client)
    * [Test if the buildbot geth binary works on Ubuntu Touch](https://github.com/doublethinkco/webthree-umbrella-cross/issues/22)
    * [Test if the buildbot geth binary works on Android](https://github.com/doublethinkco/webthree-umbrella-cross/issues/26)
    * [Test if the buildbot geth binary works on iOS](https://github.com/doublethinkco/webthree-umbrella-cross/issues/27)

Copyright (c) 2015 Kitsilano Software Inc
