SnackLinux
===========

Visit [snacklinux.org](http://snacklinux.org) for downloads, wiki and more information about SnackLinux.

Building SnackLinux from source
--------
Note:
Be sure to run `./createdev` once to create the correct `/dev` files if you are building SnackLinux from source.
It's recommended to build SnackLinux on a 32-bit host, so there's no need to mess around with multilib packages.


##### Toolchain
1. Download the musl 1.1.6 cross compiler [here](https://e82b27f594c813a5a4ea5b07b06f16c3777c3b8c.googledrive.com/host/0BwnS5DMB0YQ6bDhPZkpOYVFhbk0/). See also http://musl.codu.org/
2. Add it to your path with `export PATH=$PATH:/path/to/toolchain/bin` 

##### Linux - 4.0.5

Use the config from the git repo and compile with:
```
make bzImage
```

##### musl - 1.1.9

```
CROSS_COMPILE=i486-musl-linux- ./configure --prefix=/ --enable-gcc-wrapper 
make 
make DESTDIR=/sysroot/path install
```

##### BusyBox - 1.23.2
1. Clone this git repo or just get the [busybox-1.23.2/.config](https://github.com/snacsnoc/snacklinux/blob/master/busybox-1.23.2/.config) file and place it in the busybox-1.23.2 directory
2. Run `make menuconfig` to change any config value, notably the install directory and compiler prefix (_i486-linux-musl-_)
3. Patch ifplugd, if using default SnackLinux config, with `patch -p1 -iifplugd.patch`. See http://wiki.musl-libc.org/wiki/Building_Busybox
4. Compile `make` and install `make install`
5. Run `cp -r _install/ ..` to copy BusyBox folder structure to root system
6. Once copied to the root filesystem, `cd` there and create init with `ln -s bin/busybox init`
 

##### Bash - 4.3

```
CC=i486-linux-musl-gcc CROSS_COMPILE=i486-linux-musl- ./configure --enable-static-link --enable-largefile --prefix=/path/to/install --without-bash-malloc --enable-net-redirections --host=i486-linux-musl --target=i486-linux-musl --disable-nls -C

CC=i486-linux-musl-gcc CROSS_COMPILE=i486-linux-musl- make 
make install
```
##### Binutils 2.25

```
LDFLAGS="-Wl,-static" 
CC="i486-musl-linux-gcc -static" 
CFLAGS="-D_GNU_SOURCE -D_LARGEFILE64_SOURCE" 
./configure --target=i486-musl-linux  --host=i486-musl-linux --disable-shared --disable-multilib --disable-nls --with-sysroot=/sysroot --prefix=/usr

make
make DESTDIR=/sysroot install
```


#### Syslinux
You can either copy `isolinux.bin` from your distribution from `/var/lib/syslinux` or compile it yourself. The recommended version is 5.01. If you want to compile Syslinux, [download it](https://www.kernel.org/pub/linux/utils/boot/syslinux/), extract and run `make`. Copy `core/isolinux.bin` and `com32/elflink/ldlinux/ldlinux.c32` to `snacklinux/boot/isolinux`. 


### Using the Makefile
###### Kernel
Run `make kernel`. This will compile the kernel.

###### ISO image
Prerequisites:
```
#Base files (/etc)
https://github.com/snacsnoc/snacklinux-base.git
cp -R snacklinux-base/rootfs/* _install/
#fbpkg (package manager)
git clone https://github.com/snacsnoc/fbpkg.git
cp fbpkg/fbpkg _install/usr/bin
```
Run `make iso`. The output ISO will be in `iso/`

Note: you do not have to have the toolchain to create the ISO


Packages
-------
Read the [Packages page](http://snacklinux.org/packages) for building packages.
For SnackLinux's package manager fbpkg, see [here](https://github.com/snacsnoc/fbpkg).

Hacking
-------
Edit anything in `_install`, it is the root filesystem.
The kernel can also be recompiled to fit your needs. 

The `boot/isolinux` directory is where ISOLINUX resides, edit the menu to adjust to your needs.

Thanks
------
Mike Chirico for http://souptonuts.sourceforge.net/cdrom.htm

Tiny Core Linux distribution for inspiration and documentation http://tinycorelinux.net

Linux From Scratch for excellent documentation http://www.linuxfromscratch.org/

Here are links to the software used in SnackLinux:

[syslinux 5.01](https://www.kernel.org/pub/linux/utils/boot/syslinux/)

[linux 4.0](https://www.kernel.org)

[busybox 1.23.2](http://www.busybox.net/downloads/)

[bash 4.3](http://ftp.gnu.org/gnu/bash/)

[fbpkg 0.1.5](https://github.com/snacsnoc/fbpkg)

[binutils 2.25](http://ftp.gnu.org/gnu/binutils/)
