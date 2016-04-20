# What is "cpp-ethereum-cross"?

This repo contains [Docker](https://www.docker.com/) files for
[cross-compilation](https://en.wikipedia.org/wiki/Cross_compiler) of the
[Ethereum](https://en.wikipedia.org/wiki/Ethereum) C++ components.

The C++ cross-build support was developed by
[Bob Summerwill](http://bobsummerwill.com)
and
[Anthony Cros](https://github.com/anthony-cros)
for [doublethinkco](http://doublethink.co).

The intention of the project is to bring Ethereum to mobile/wearable Linux
platforms for the benefit of the whole Ethereum community, current and future.
Given the ubiquitous nature of ARM processors, it was trivial to extend the
scope of the project from mobile/wearable to cover a huge range of devices
and OSes.  There is a large test matrix further down this document showing
our understanding of the status on a very broad range of devices.

Here is a photo of our nascent mobile/wearable build and testing farm:

![Build farm](https://doublethinkco.files.wordpress.com/2015/11/20151120_083926.jpg?w=788)

This code is released as open source software under the permissive
[MIT license](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/LICENSE).

We have written blogs and articles through development which are hosted at
[doublethink.co](http://doublethink.co).  Here are some key articles

* [Porting Ethereum to mobile Linux](http://doublethink.co/2015/09/22/porting-ethereum-to-mobile-linux/)
* [First working Ethereum C++ cross-builds](http://doublethink.co/2015/11/30/first-working-ethereum-c-cross-builds/)
* [New Year, New Focus](http://bobsummerwill.com/2015/12/24/new-year-new-focus/)

# Smartwatch status

| Form factor     | Vendor                  | Device                | OS                | ABI     | SoC                        | Core          | Native  | Cross |
| --------------- |:-----------------------:|:---------------------:|:-----------------:|:-------:|:--------------------------:|:-------------:|:-------:|:-----:|
| Smartwatch      | Samsung                 | Gear S2               | Tizen 2.3.1       | armv7   | Qualcomm MSM8x26           | 2 x Cortex-A7 | N/A     | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)
| Smartwatch      | Apple                   | Apple Watch Sport     | watchOS 2.0       | armv7k  | Apple S1                   | 1 x ARM-v7k   | N/A     | [TODO #41](https://github.com/doublethinkco/webthree-umbrella-cross/issues/41)

# Smartphone status

| Vendor                  | Device                | OS                | ABI     | SoC                        | Core          | Native  | Cross |
|:-----------------------:|:---------------------:|:-----------------:|:-------:|:--------------------------:|:-------------:|:-------:|:-----:|
| Samsung                 | Samsung Z1            | Tizen 2.3.0       | armv7   | Spreadtrum SC7727S         | 2 x Cortex-A7 | N/A     | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)
| Samsung                 | Samsung Z3            | Tizen 2.4.0       | armv7   | Spreadtrum SC7730S         | 4 x Cortex-A7 | N/A     | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)
| LG                      | Nexus 5               | Sailfish 2.0      | armv7   | Qualcomm Snapdragon 800    | 4 x Krait 400 | [Working](https://twitter.com/vgrade/status/671818784055889921) | [TODO #60](https://github.com/doublethinkco/webthree-umbrella-cross/issues/60)
| Jolla                   | Jolla Phone           | Sailfish 2.0      | armv7   | Qualcomm Snapdragon 400    | 2 x Krait 300 | [TODO #61](https://github.com/doublethinkco/webthree-umbrella-cross/issues/61) | [Working](https://twitter.com/doublethink_co/status/677942232549208064?lang=en)
| Intex                   | Aquafish              | Sailfish 2.0      | armv7   | Qualcomm Snapdragon ???    |               | TODO    | TODO
| Meizu                   | MX4 Ubuntu Edition    | Ubuntu Touch      | armv7   | MediaTek MT6595            | 4 x Cortex-A17, 4 x Cortex-A7 | [TODO #62](https://github.com/doublethinkco/webthree-umbrella-cross/issues/62) | [Working](https://twitter.com/doublethink_co/status/677662911687434241)
| Samsung                 | Galaxy S3             | Android 4.3       | armel   | Samsung Exynos 4412 Quad   | 4 x Cortex-A9 | N/A     | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35)
| Samsung                 | Galaxy S4             | Android 4.4       | armel   | Qualcomm Snapdragon 600    | 4 x Krait 300 | N/A     | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35)
| Samsung                 | Galaxy S6             | Android 5.0.2     | aarch64 | Samsung Exynos 7420        | 4 x Cortex-A57, 4 x Cortex-A53 | N/A | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35)
| Apple                   | iPhone 3GS            | iOS 3             | armv7   | Samsung S5PC100            | 1 x Cortex-A8 | N/A     | [TODO #36](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36)
| Apple                   | iPhone 5              | iOS 6             | armv7   | Apple A6                   | 2 x ARMv7A    | N/A     | [TODO #36](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36)
| Nokia                   | N900                  | Maemo 5           | armv7   | Apple A6                   | 2 x ARMv7A    | N/A     | [TODO #74](https://github.com/doublethinkco/webthree-umbrella-cross/issues/74)
| Nokia                   | N9                    | MeeGo 1.3         | armv7   | Apple A6                   | 2 x ARMv7A    | N/A     | [TODO #73](https://github.com/doublethinkco/webthree-umbrella-cross/issues/73)

# Developer phone status

| Vendor                  | Device                | OS                | ABI     | SoC                        | Core          | Native  | Cross |
|:-----------------------:|:---------------------:|:-----------------:|:-------:|:--------------------------:|:-------------:|:-------:|:-----:|
| Samsung                 | RD-210                | Tizen 2.2.0       | armv7   | Samsung Exynos 4210        | 2 x Cortex-A9 | N/A     | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)
| Samsung                 | RD-PQ                 | Tizen 2.3.0       | armv7   | Samsung Exynos 4412 Quad   | 4 x Cortex-A9 | N/A     | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)
| Samsung                 | TM1                   | Tizen 2.4.0       | armv7   | Spreadtrum SC7730S         | 4 x Cortex-A7 | N/A     | [Broken #20](https://github.com/doublethinkco/webthree-umbrella-cross/issues/20)

# Tablet status

| Vendor                  | Device                | OS                | ABI     | SoC                        | Core          | Native  | Cross |
|:-----------------------:|:---------------------:|:-----------------:|:-------:|:--------------------------:|:-------------:|:-------:|:-----:|
| Asus                    | Nexus 7               | Android 5.1.1     | armel   | Nvidia Tegra 3             | 4+1 x Cortex-A9 | N/A   | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35)
| Samsung                 | Galaxy Tab S 10.5     | Android 5.0.2     | armel   | Samsung Exynos 5 Octa 5420 | 4 x Cortex-A15, 4 x Cortex-A7 | N/A | [TODO #35](https://github.com/doublethinkco/webthree-umbrella-cross/issues/35)
| Apple                   | iPad Air 2            | iOS 8.1           | aarch64 | Apple A8X                  | 3 x ARMv8-A   | N/A     | [TODO #36](https://github.com/doublethinkco/webthree-umbrella-cross/issues/36)

# SBC (Single Board Computer) status

| Vendor                  | Device                | OS                | ABI     | SoC                        | Core          | Native  | Cross |
|:-----------------------:|:---------------------:|:-----------------:|:-------:|:--------------------------:|:-------------:|:-------:|:-----:|
| Raspberry Pi Foundation | Raspberry Pi Model A  | Raspbian          | armv6   | Broadcom BCM2835           | 1 x ARMv6     | TODO    | TODO
| Raspberry Pi Foundation | Raspberry Pi Model B+ | Raspbian          | armv6   | Broadcom BCM2835           | 1 x ARMv6     | Working | Working
| Raspberry Pi Foundation | Raspberry Pi Zero     | Raspbian          | armv6   | Broadcom BCM2835           | 1 x ARMv6     | TODO    | [Working](https://twitter.com/vgrade/status/670677685622939649)
| Raspberry Pi Foundation | Raspberry Pi 2        | Raspbian          | armv7   | Broadcom BCM2836           | 4 x Cortex-A7 | Working | [Working](https://twitter.com/EthEmbedded/status/670628642125438977)
| Raspberry Pi Foundation | Raspberry Pi 3        | Ubuntu 15.04 MATE | armv7   | Broadcom BCM2837           | 4 x Cortex-A53 | TODO | TODO
| Odroid                  | Odroid XU3            | Ubuntu 15.04 MATE | armv7   | Samsung Exynos 5422        | 4 x Cortex-A15, 4 x Cortex-A7 | Working | [Working](https://twitter.com/BobSummerwill/status/670585217384628224)
| Odroid                  | Odroid XU4            | Tizen 3.x         | armv7   | Samsung Exynos 5422        | 4 x Cortex-A15, 4 x Cortex-A7 | TODO    | TODO
| Beaglebone              | Beaglebone Black      | Debian            | armv7   | Texas Instruments AM3358/9 | 1 x Cortex-A8 | Working | Working
| Wandboard               | Wandboard Quad        | Debian            | armv7   | Freescale i.MX6            | 4 x Cortex-A9 | Working | [Working](https://twitter.com/BobSummerwill/status/670573142914519040)
| Dragonboard             | DragonBoard 410c      |                   | armv7   | Qualcomm Snapdragon 410    | 4 x Cortex-A7 | TODO    | TODO
| C.H.I.P.                | C.H.I.P.              | Debian            | armv7   | Allwinner R8               | 1 x Cortex-A8 | TODO    | [Working](https://twitter.com/EthEmbedded/status/697220510208258048)
| Minnowboard             | Minnowboard MAX       |                   | x86_64  | Intel Atom E3800           | 2 x Core      | TODO    | TODO
| Intel                   | Intel NUC DCP847SKE   |                   | i386    | Intel QS77 Express         |               | TODO    | TODO
| Intel                   | Intel Edison          | Yocto             | x86_64  | Intel "Tangier" Z34XX      |               | Working | TODO
| Intel                   | Intel Curie           |                   | i386    | Intel Quark SE             |               | TODO    | TODO

NOTE - Here is some information on [ARM options in GCC](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html).

See also [ARM Infocenter](http://infocenter.arm.com) and [ARM Architecture](https://en.wikipedia.org/wiki/ARM_architecture) page on Wikipedia.


# Releases

Prebuilt releases are [hosted on Github](https://github.com/doublethinkco/webthree-umbrella-cross/releases)
and are updated periodically.

See also [RELEASED – Cross-build eth binaries for Homestead](http://doublethink.co/2016/03/07/released-cross-build-eth-binaries-for-homestead/).

If you use these binaries please do let us know how you get on,
either via [cpp-ethereum](http://gitter.im/ethereum/porting) on Gitter
or by logging [an issue](https://github.com/doublethinkco/webthree-umbrella-cross/issues)
in Github.  Please give as much detail as you can, including your exact
device and operating system version.   Thanks!

# Cross-build from source

To cross-build the HEAD of **webthree-umbrella** from source yourself,
follow these instructions.

Clone this repo and use
[Dockerfile-crosseth](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-crosseth)
to build either 'armel' binaries or 'armhf' binaries:

    $ git clone https://github.com/doublethinkco/webthree-umbrella-cross.git
    $ cd webthree-umbrella-cross

And then one of ...

    $ sudo ./build-armel.sh
    $ sudo ./build-armhf.sh
    $ sudo ./build-armel-apt.sh
    $ sudo ./build-armhf-apt.sh

If the build succeeds then you will end up with an output file in **/tmp/crosseth.tgz**.

The "apt" versions use the pre-built **g++-arm-linux-gnueabi** and
**g++-arm-linux-gnueabihf** cross-compilers which "apt-get install"-ed,
rather than the cross-compilers which we built ourselves (see next paragraph).

[Dockerfile-crosseth](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-crosseth)
makes use of the [crosstool-NG](http://crosstool-ng.org/#introduction) toolchain-building
scripts to generate a cross-compiler which is then used in the rest of the
build process.  The cross-compiler was originally built and then used as
part of the same Docker flow, but that was slow and unnecessarily, so that
step was been split into its own [Dockerfile-xcompiler](https://github.com/doublethinkco/webthree-umbrella-cross/blob/master/Dockerfile-xcompiler)
process, which can be run in a similar manner:

    $ git clone https://github.com/doublethinkco/webthree-umbrella-cross.git
    $ cd webthree-umbrella-cross
    $ sudo ./build-xcompiler-armel.sh

or

    $ git clone https://github.com/doublethinkco/webthree-umbrella-cross.git
    $ cd webthree-umbrella-cross
    $ sudo ./build-xcompiler-armhf.sh

If the cross-compiler build succeeds then you will end up with an output file in **/tmp/xcompiler.tgz**.

The results from two specific runs of this process are stored as releases on
Github and are used in the crosseth build process.   The "glue"
for this process is in [cross-build/ethereum/setup.sh](https://github.com/doublethinkco/webthree-umbrella-cross/blob/873761bba4f9b9c8e401dd0c9ac52a8c8e9b780b/cross-build/ethereum/setup.sh#L197):

* [armel-15-12-04](https://github.com/doublethinkco/webthree-umbrella-cross/releases/tag/armel-15-12-04)
* [armhf-15-12-04](https://github.com/doublethinkco/webthree-umbrella-cross/releases/tag/armhf-15-12-04)


# Next steps?

The bulk of the remaining work is getting specific platforms and devices into
a working state.  For the ARM devices, that will mainly be a matter of
iterating on the ABI settings until we get working binaries.  Intel support
should not be too hard either - just more cross-compilers.

* [Milestone 1 - Loose Ends, Tizen](https://github.com/doublethinkco/webthree-umbrella-cross/milestones/Milestone%201%20-%20Loose%20ends,%20Tizen)
* [Milestone 2 - DevOps, Android, iOS](https://github.com/doublethinkco/webthree-umbrella-cross/milestones/Milestone%202%20-%20DevOps,%20Android,%20iOS)
* [Milestone 3 - Light Client Phase 1](https://github.com/doublethinkco/webthree-umbrella-cross/milestones/Milestone%203%20-%20Light%20Client%20Phase%201)
