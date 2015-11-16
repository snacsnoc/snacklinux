SnackLinux
===========

Visit [snacklinux.org](http://snacklinux.org) for downloads, wiki and more information about SnackLinux.

Building SnackLinux from source
--------
Note:
Be sure to run `./createdev.sh` once to create the correct `/dev` files if you are building SnackLinux from source.
It's recommended to build SnackLinux on a 32-bit host, so there's no need to mess around with multilib packages.


##### Toolchain

###### Prebuilt
1. Download the musl 1.1.6 cross compiler [here](https://e82b27f594c813a5a4ea5b07b06f16c3777c3b8c.googledrive.com/host/0BwnS5DMB0YQ6bDhPZkpOYVFhbk0/). See also http://musl.codu.org/
2. Add it to your path with `export PATH=$PATH:/path/to/toolchain/bin` 

###### Build your own 
Compile your own toolchain with [musl-cross](https://bitbucket.org/GregorR/musl-cross)

Compiling SnackLinux from source is done through the Makefile

##### Linux - 4.0.5

```
make kernel
```

##### musl - 1.1.12
```
make musl
```
##### BusyBox - 1.23.2

```
make busybox
```
 

##### Bash - 4.3

```
make bash
```
##### Binutils 2.25

```
make binutils
```


#### Syslinux

You can either copy `isolinux.bin` from your distribution from `/var/lib/syslinux` or compile it yourself. The recommended version is 5.01. If you want to compile Syslinux, [download it](https://www.kernel.org/pub/linux/utils/boot/syslinux/), extract and run `make`. Copy `core/isolinux.bin` and `com32/elflink/ldlinux/ldlinux.c32` to `snacklinux/boot/isolinux`. 


##### Booting
Prerequisites:
```
#Base files (/etc)
git clone https://github.com/snacsnoc/snacklinux-base.git
cp -R snacklinux-base/rootfs/* /opt/snacklinux_rootfs/
#fbpkg (package manager)
git clone https://github.com/snacsnoc/fbpkg.git
cp fbpkg/src/fbpkg /opt/snacklinux_rootfs/usr/bin
```
###### ISO

Run `make iso`. The output ISO will be in `iso/`

Note: you do not have to have the toolchain to create the ISO

###### qemu
Create a gzipped rootfs by running:
```
cd /opt/snacklinux_rootfs/; find . -print | cpio -o -H newc --quiet | gzip -6 > ../rootfs.gz 
```
Then boot in qemu:
```
qemu-system-i386 -m 256 -kernel bzImage -initrd rootfs.gz -append "root=/dev/ram rdinit=/sbin/init"
```

Packages
-------
Read the [Packages page](http://snacklinux.org/packages) for building packages.
For SnackLinux's package manager fbpkg, see [here](https://github.com/snacsnoc/fbpkg).

Hacking
-------
Edit anything in `/opt/snacklinux_rootfs`, it is the root filesystem.
The kernel can also be recompiled to fit your needs. 

The `boot/isolinux` directory is where ISOLINUX resides, edit the menu to adjust to your needs.

Thanks
------
Mike Chirico for http://souptonuts.sourceforge.net/cdrom.htm

Tiny Core Linux distribution for inspiration and documentation http://tinycorelinux.net

Linux From Scratch for excellent documentation http://www.linuxfromscratch.org/

The Arch Linux wiki https://wiki.archlinux.org/

Here are links to the software used in SnackLinux:

[syslinux](https://www.kernel.org/pub/linux/utils/boot/syslinux/)

[linux](https://www.kernel.org)

[busybox](http://www.busybox.net/downloads/)

[bash](http://ftp.gnu.org/gnu/bash/)

[fbpkg](https://github.com/snacsnoc/fbpkg)

[binutils](http://ftp.gnu.org/gnu/binutils/)

[musl](http://www.musl-libc.org/)