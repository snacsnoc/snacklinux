SnackLinux
===========

Introduction
------------
SnackLinux is my experimentation with creating a functional Linux distribution. It contains a 3.x kernel with the latest BusyBox, uClibc and binutils. SnackLinux uses uClibc as the C library and ISOLINUX as the bootloader.


Quick start
-----------
Download the [latest ISO](http://snacklinux.org/iso) and boot into SnackLinux.

To set up networking, you can either use a static IP 
```
ifconfig eth0 192.168.0.100 netmask 255.255.255.0
route add default gw 192.168.0.1
```
or use `udhcpc` for DHCP.

Run `fbpkg update` to update the latest packages list to check if the network is up.

**SSH**

Install dropbear via fbpkg by running `fbpkg install dropbear`

Then set up the keys:
```
mkdir /etc/dropbear && cd /etc/dropbear
dropbearkey -t rsa -f dropbear_rsa_host_key
dropbearkey -t dss -f dropbear_dss_host_key
```
Now run `dropbear` to start the dropbear SSH server.

If you receive an error such as `PTY allocation request failed on channel 0` after you have installed when trying to SSH into SnackLinux, try the below:

```
rm -rf /dev/pts
mkdir /dev/pts
mount /dev/pts
```

Add `mkdir /dev/pts` above `/bin/mount -a` in `/etc/init.d/rcS`.

**Installation**

Run `/root/install-snacklinux.sh /dev/hda` and follow through the prompts to install to persistent media. The installation uses approximately 40 MB of disk space.

**Packages**

To see the available packages, run `cat /var/lib/fbpkg/packageslist`. 
Use `fbpkg install <package>` or `fbpkg remove <package>` for installation and removal. Run `fbpkg --help` for more information.

***


Building
--------
Note:
Be sure to run `./createdev` to create the correct `/dev` files.
It's recommended to build SnackLinux on a 32-bit host, so there's no need to mess around with multilib packages.


##### Toolchain
1. Download buildroot 2013.11 and place this file [buildroot-2013.11/.config](https://bitbucket.org/snacsnoc/snacklinux/src/master/buildroot-2013.11/.config) in the buildroot directory and run `make`.
2. Set your $PATH to /path-to-buildroot/buildroot-x.x/output/host/usr/bin:${PATH} to include the gcc toolchain

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
Read the [Packages wiki page](https://bitbucket.org/snacsnoc/snacklinux/wiki/Packages) for building packages.
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
