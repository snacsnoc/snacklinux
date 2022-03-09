SnackLinux
===========

Visit [snacklinux.geekness.eu](snacklinux.geekness.eu) for downloads, wiki and more information about SnackLinux.

Building SnackLinux from source
--------


##### Toolchain

###### Prebuilt
1. Download the musl 1.1.6 cross compiler [here](http://snacklinux.geekness.eu/tars/crossx86-i486-linux-musl-1.1.6.tar.xz). See also http://musl.codu.org/
2. Add it to your path with `export PATH=$PATH:/path/to/toolchain/bin` 

###### Build your own 
Compile your own toolchain with [musl-cross](https://github.com/GregorR/musl-cross)

Compiling SnackLinux from source is done through the Makefile

##### Linux - 4.15.2

```
make kernel
```

##### musl - 1.1.18
```
make musl
```
##### BusyBox - 1.28.0

```
make busybox
```
 

##### Bash - 4.4.18

```
make bash
```
##### Binutils 2.30 (optional)

```
make binutils
```

#### Syslinux 6.03

```
make syslinux
```

### Installing to rootfs directory

```
make install
```

If you would also like to install binutils, use:

```
make binutils-install
```

##### Booting
Prerequisites:
```
#Base files (/etc)
git clone https://github.com/snacsnoc/snacklinux-base.git
cp -R snacklinux-base/rootfs/* /opt/snacklinux_rootfs/
#Create ./dev files
./createdev.sh
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
qemu-system-x86_64 -m 256 -kernel bzImage -initrd rootfs.gz -append "root=/dev/ram rdinit=/sbin/init"
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

Gregor Richards for the many Musl compiler scripts https://github.com/GregorR

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
