SnackLinux
===========

Introduction
------------
SnackLinux is my experimentation with creating a functional Linux distribution. It contains a 3.x kernel with the latest BusyBox, uClibc and binutils. SnackLinux uses uClibc as the C library and ISOLINUX as the bootloader.


Building
--------
Note:
Be sure to run `./createdev` to create the correct `/dev` files.
It's recommended to build SnackLinux on a 32-bit host, so there's no need to mess around with multilib packages.


##### Toolchain
1. Download buildroot and place this file [buildroot-2013.05/.config](https://bitbucket.org/snacsnoc/snacklinux/src/master/buildroot-2013.05/.config) in the buildroot directory. Or, optionally compile buildroot with large file support and RPC for i686 (if target is x86)
2. Set your $PATH to /path-to-buildroot/buildroot-x.x/output/host/usr/bin:${PATH} to include the toolchain

##### BusyBox
1. Clone this git repo or just get the [busybox-1.21.1/.config](https://bitbucket.org/snacsnoc/snacklinux/src/master/busybox-1.21.1/.config) file and place it in the busybox-1.21.1 directory
2. Run `make menuconfig` to change any config value, notable the sysroot path and compiler prefix
3. Compile with  `make` (again, if the target is x86)
4. Run `cp -r _install/ ..` to copy BusyBox folder structure to root system

##### Bash
1. Compile Bash 4.2 with `./configure --enable-static-link --enable-largefile --prefix=/path-to-root-fs/_install --without-bash-malloc`
2. Run `CC='i686-linux-cc' make` (to use the toolchain), then `make install`

#### Syslinux
You can either copy `isolinux.bin` from your distribution in `/var/lib/syslinux` or compile it yourself. If you want to compile Syslinux, [download it](https://www.kernel.org/pub/linux/utils/boot/syslinux/), extract and run `make`. Copy `core/isolinux.bin` to `snacklinux/boot/isolinux`. 

##### Kernel
Run `make kernel`. This will compile the kernel.

##### ISO image
Run `make iso`. The output ISO will be in `iso/`

Note: you do not have to have the toolchain to create the ISO

Download
--------------
You can download ISOs of SnackLinux __[here](http://gelat.in/snacklinux/iso/)__. The ISOs are named in _day.month.year_ format.

Packages
-------
##### Generic building instruction
1. Set `./configure --prefix` or `make PREFIX= install` to `../_install` to install to the root filesystem
2. Compile staticly with toolchain and try to disable extraneous libraries
3. Test!

Hacking
-------
Edit anything in `_install`, it is the root filesystem.
The kernel can also be recompiled to fit your needs. 

The `boot/isolinux` directory is where ISOLINUX resides, edit the menu to adjust to your needs.

Thanks
------
Mike Chirico for http://souptonuts.sourceforge.net/cdrom.htm

Tiny Core Linux distrobution for inspiration and documentation http://http://tinycorelinux.net
