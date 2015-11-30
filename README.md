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

This cross-build support was developed for
[doublethinkco](http://doublethink.co) by
[Bob Summerwill](http://bobsummerwill.com)
and
[Anthony Cros](https://github.com/anthony-cros)
to bring Ethereum to mobile/wearable Linux platforms for the benefit
of the whole Ethereum community, current and future.

It is released as free software under the
[GPLv2 license](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/LICENSE.txt).

See [Porting Ethereum to Mobile Linux](http://doublethink.co/2015/09/22/porting-ethereum-to-mobile-linux/)
blog for an overview of our efforts.

# How to use it

Clone this repo and build and run [Dockerfile-eth](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-eth):

    $ git clone https://github.com/doublethinkco/webthree-umbrella-cross.git
    $ cd webthree-umbrella-cross
    $ sudo docker build -f Dockerfile-eth .

That generates a Docker *image*, which is not the same as a Docker
*container*.  Docker *images* are immutable binary images, which are
analogous to VM snapshots.  Docker *containers* are particular instances
of those images.  To get an instance of that newly created image running
you need to do:

    $ sudo docker run -i -t HASH_OF_IMAGE /bin/bash

In the shell for that container you will see the HASH for the container
instance.  That container will have a TGZ file in the ~ directory
which you can copy out to the host machine with the following command
from another shell instance on your host machine.  Your "docker run"
*must* still be running for this copy step to work.    If somebody who
has more Docker experience knows how to streamline this experience,
please speak up!

    $ sudo docker cp HASH_OF_CONTAINER:/FILENAME.tgz ~/

Then you can "exit" the "docker run" session, and stop that Docker
container running.   It has served its purpose.

[Dockerfile-eth](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-eth)
makes use of the [crosstool-NG](http://crosstool-ng.org/) toolchain-building
scripts to generate a cross-compiler which is then used in the rest of the
build process.  The cross-compiler was originally built and then used as
part of the same Docker flow, but that was slow and unnecessarily, so has
been split into its own [Dockerfile-xcompiler](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-xcompiler)
process, which can be run in a similar manner:

    $ git clone https://github.com/doublethinkco/webthree-umbrella-cross.git
    $ cd webthree-umbrella-cross
    $ sudo docker build -f Dockerfile-xcompiler .

The results of a particular run of this process are
[hard-coded in the Dockerfile-eth](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-eth#L46)
where they are copied directly into the container.


# Dependency graph for the webthree components

![Webthree](https://ipfs.pics/ipfs/QmcaAgncr7MgUKNBb4ebEDHVE4uro2g2NS6krMcGXyPq4n)

# Platform status


| Form factor      | Vendor                  | Device                | OS             | SoC | Native    | Cross     | Notes |
| ---------------- |:-----------------------:|:---------------------:|:--------------:| --- | --------- | --------- | ----------------------------
| Smartwatch      | Samsung                 | Gear S2               | Tizen 2.3.1    | Exynos 3250 / Qualcomm MSM8x26 |         | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)  | Working through ABI issues
| Smartwatch      | Apple                   | Apple Watch Sport     | watchOS 1.0    | Apple S1 |         | [TODO #41](https://github.com/doublethinkco/webthree-umbrella-cross/issues/41)    |
| Smartphone      | Samsung                 | Samsung Z1            | Tizen 2.3.0    | Spreadtrum SC7727S |         | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20) | Working through ABI issues
| Smartphone      | Samsung                 | Samsung Z3            | Tizen 2.4.0    | Spreadtrum SC7730SI |         | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)  | Working through ABI issues
| Smartphone      | LG                      | Nexus 5               | Sailfish 2.0   | Qualcomm Snapdragon 800 | [WIP](https://build.merproject.org/project/show/home:vgrade:ethereum) | [Broken #21](https://github.com/doublethinkco/webthree-umbrella-cross/issues/21) | Working through ABI issues
| Smartphone      | Jolla                   | Jolla Phone           | Sailfish 2.0   | Qualcomm Snapdragon 400 | [WIP](https://build.merproject.org/project/show/home:vgrade:ethereum) | [Broken #21](https://github.com/doublethinkco/webthree-umbrella-cross/issues/21) | Working through ABI issues
| Smartphone      | Intex                   | Aquafish              | Sailfish 2.0   | | [WIP](https://build.merproject.org/project/show/home:vgrade:ethereum) | [Broken #21](https://github.com/doublethinkco/webthree-umbrella-cross/issues/21) | Due for release in Q1 2016
| Smartphone      | Meizu                   | MX4 Ubuntu Edition    | Ubuntu Touch   | MediaTek MT6595 | TODO    | [TODO #3](https://github.com/doublethinkco/webthree-umbrella-cross/issues/3)    | Anthony struggling with device setup
| Smartphone      | Samsung                 | Galaxy S3             | Android        | Exynos 4412 Quad |         | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35) |
| Smartphone      | Samsung                 | Galaxy S4             | Android        | Exynos 5 Octa 5410 |         | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35) |
| Smartphone      | Samsung                 | Galaxy S6             | Android        | Exynos 7420 |         | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35) | 
| Smartphone      | Apple                   | iPhone 3GS            | iOS 3          | Samsung S5PC100 |         | [TODO #36](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36)    |
| Smartphone      | Apple                   | iPhone 5              | iOS 5          | Apple A6 |         | [TODO #36](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36)    |
| Developer phone | Samsung                 | RD-210                | Tizen 2.2.0    | Exynos 4210 |         | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)  | Working through ABI issues
| Developer phone | Samsung                 | RD-PQ                 | Tizen 2.3.0    | Exynos 4412 Quad |         | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)  | Working through ABI issues
| Developer phone | Samsung                 | TM1                   | Tizen 2.4.0    | Spreadtrum SC7730SI |         | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)  | Working through ABI issues
| Tablet          | Jolla                   | Jolla Tablet          | SailfishOS 2.0 | Intel Atom Z3735F | [WIP](https://build.merproject.org/project/show/home:vgrade:ethereum) | [Broken #21](https://github.com/doublethinkco/webthree-umbrella-cross/issues/21) | Working through ABI issues
| Tablet          | Asus                    | Nexus 7               | Android        | Nvidia Tegra 3 |         | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35) |
| Tablet          | Samsung                 | Galaxy Tab S 10.5     | Android        | Exynos 5 Octa 5420 |         | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35) |
| Tablet          | Apple                   | iPad Air 2            | iOS            | Apple A8X |         | [TODO #36](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36) |
| SBC             | Raspberry Pi Foundation | Raspberry Pi Model A  | Debian         | Broadcom BCM2835 | TODO    | TODO    |
| SBC             | Raspberry Pi Foundation | Raspberry Pi Model B+ | Debian         | Broadcom BCM2835 | Working | TODO    |
| SBC             | Raspberry Pi Foundation | Raspberry Pi Zero     | Debian         | Broadcom BCM2835 | TODO    | [Working](https://twitter.com/vgrade/status/670677685622939649) |
| SBC             | Raspberry Pi Foundation | Raspberry Pi 2        | Debian         | Broadcom BCM2836 | Working | [Working](https://twitter.com/EthEmbedded/status/670628642125438977) |
| SBC             | Odroid                  | Odroid XU3            |                | Exynos 5422 | Working | [Working](https://twitter.com/BobSummerwill/status/670585217384628224) |
| SBC             | Odroid                  | Odroid XU4            |                | Exynos 5422 | TODO    | TODO    |
| SBC             | Beaglebone              | Beaglebone Black      |                | TI AM3358/9 | Working | TODO    |
| SBC             | Wandboard               | Wandboard             |                | Freescale i.MX6 | Working | [Working](https://twitter.com/BobSummerwill/status/670573142914519040) |
| SBC             | C.H.I.P.                | C.H.I.P.              |                | Allwinner R8 | TODO    | [Broken #40](https://github.com/doublethinkco/webthree-umbrella-cross/issues/40) |
| SBC             | Intel                   | Intel NUC DCP847SKE   |                | Intel QS77 | TODO    | TODO    |
| SBC             | Intel                   | Intel Galileo         |                | Intel "Tangier" Quark X1000 | TODO | TODO    |
| SBC             | Intel                   | Intel Edison          |                | Intel "Tangier" Z34XX | Working | TODO    |
| SBC             | Intel                   | Intel Curie           |                | Intel Quark SE | TODO | TODO    |

# Limitations

At the time of writing, this cross-compilation process only supports
the building of ARM binaries, and specifically 'armel' binaries for
armv5 and software floating-point ABI.  These binaries are very
generic and should work on many, many devices.   We are adding support
for other ABIs right now:

- [Support armhf](https://github.com/doublethinkco/webthree-umbrella-cross/issues/10)
- [Support i386 and x86_64](https://github.com/doublethinkco/webthree-umbrella-cross/issues/37)

BEWARE - boot2docker on OSX does not "just work" when installed.
Here are the commands you will inevitably forget whenever you reboot
or start a new terminal session:

http://stackoverflow.com/questions/29594800/docker-tls-error-on-mac/


Copyright (c) 2015 Kitsilano Software Inc
