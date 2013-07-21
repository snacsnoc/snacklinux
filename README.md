SnackLinux
===========

Introduction
------------
SnackLinux is my experimentation with creating a functional Linux distribution. It contains a 3.x kernel with the latest BusyBox, uClibc, binutils and tcc. SnackLinux uses uClibc as the C library and ISOLINUX as the bootloader.



Building
--------
Note:
Be sure to run `./_install/createdev` to create the correct `/dev` files.


##### Toolchain
1. Download and compile buildroot with large file support and RPC for i686 (if target is x86)
2. Set path to /path-to-buildroot/buildroot-x.x/output/host/usr/bin:${PATH}
3. Compile everything with `CC='i686-linux-cc' make`

##### BusyBox
1. Clone this git repo and [busybox-1.21.0/.config](busybox-1.21.0/.config)
2. Compile with `CC='i686-linux-cc' make` (again, if the target is x86)
3. Run `cp -r _install/ ..` to copy BusyBox folder structure to root system

##### Bash
Compile Bash with `./configure --enable-static-link --enable-largefile --prefix=/path-to-root-fs/_install --without-bash-malloc

##### Kernel
Run `make kernel`. This will compile the kernel.

##### ISO image
Run `make iso`. The output ISO will be in `iso/`

Download
--------------
You can download ISOs of SnackLinux __[here](http://gelat.in/snacklinux/iso/)__. The ISOs are named in _month.day.year_ format.

Packages
-------
##### Generic building instruction
1. Set `./configure --prefix` or `make PREFIX= install` to `../_install` to install to the root filesystem
2. Compile staticly with toolchain and try to `--disable-nls` with most packages
3. Test!

Hacking
-------
Edit anything in `_install`, it is the root filesystem.
The kernel can also be recompiled to fit your needs. 

The `boot/` directory is where ISOLINUX resides, edit the menu to adjust to your needs.

Thanks
------
Thanks to Mike Chirico for http://souptonuts.sourceforge.net/cdrom.htm
