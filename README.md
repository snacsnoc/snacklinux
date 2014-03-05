SnackLinux
===========

Visit [snacklinux.org](http://snacklinux.org) for downloads, wiki and more information about SnackLinux.

Building
--------
Note:
Be sure to run `./createdev` once to create the correct `/dev` files if you are building SnackLinux from source.
It's recommended to build SnackLinux on a 32-bit host, so there's no need to mess around with multilib packages.


##### Toolchain
1. Download buildroot 2013.11 and `.config` and `uClibc-0.9.33.config` from this repo and place the files in the buildroot directory.
2. Run `make menuconfig` and/or `make uclibc-menuconfig` to change any options, namely paths. If all is well, run `make` 
3. If everything went well, set your $PATH to /path-to-buildroot/buildroot-x.x/output/host/usr/bin:${PATH} to include the gcc toolchain

#### uClibc
Thankfully buildroot already creates uClibc for us, so we copy `lib/` and `usr/` from `buildroot-2013.11/output/host/usr/i686-buildroot-linux-uclibc/sysroot` to the SnackLinux root `_install`.


Note: you might also want to `export LD_LIBRARY_PATH=/path/to/buildroot-x.x/output/host/usr/i686-buildroot-linux-uclibc/sysroot/usr/lib` so if you do cross compile, you are linking against the correct libs.

##### BusyBox
1. Clone this git repo or just get the [busybox-1.22.1/.config](https://bitbucket.org/snacsnoc/snacklinux/src/master/busybox-1.22.1/.config) file and place it in the busybox-1.22.1 directory
2. Run `make menuconfig` to change any config value, notably the sysroot path (CONFIG_SYSROOT) and compiler prefix
3. Compile `make` and install `make install`
4. Run `cp -r _install/ ..` to copy BusyBox folder structure to root system

##### Bash
1. Compile Bash 4.2 with `./configure --enable-static-link --enable-largefile --prefix=/path-to-root-fs/_install --without-bash-malloc`
2. Run `CC='i686-linux-cc' make` (to use the toolchain), then `make install`

#### Syslinux
You can either copy `isolinux.bin` from your distribution from `/var/lib/syslinux` or compile it yourself. The recommended version is 5.01. If you want to compile Syslinux, [download it](https://www.kernel.org/pub/linux/utils/boot/syslinux/), extract and run `make`. Copy `core/isolinux.bin` and `com32/elflink/ldlinux/ldlinux.c32` to `snacklinux/boot/isolinux`. 

##### Kernel
Run `make kernel`. This will compile the kernel.

##### ISO image
Run `make iso`. The output ISO will be in `iso/`

Note: you do not have to have the toolchain to create the ISO


Packages
-------
Read the [Packages page](http://snacklinux.org/packages) for building packages.
For SnackLinux's package manager fbpkg, see [here](https://bitbucket.org/snacsnoc/fbpkg).

Hacking
-------
Edit anything in `_install`, it is the root filesystem.
The kernel can also be recompiled to fit your needs. 

The `boot/isolinux` directory is where ISOLINUX resides, edit the menu to adjust to your needs.

Thanks
------
Mike Chirico for http://souptonuts.sourceforge.net/cdrom.htm

Tiny Core Linux distribution for inspiration and documentation http://tinycorelinux.net

