SnackLinux
===========

Archtechtures supported:
* arm64 (in-progress)
* x86_64 (old, but works with effort)

Visit [snacklinux.geekness.eu](snacklinux.geekness.eu) for downloads, wiki and more information about SnackLinux.

Building SnackLinux from source
------------------------------


# Build system

* Linux is preferable to build with
 
**Debian**
```
apt-get install build-essential git
``` 
**Mac OS***
* Mac OS is **incredibly** difficult to get working alone to build the kernel, otherwise cross-compiling works
* An alternative to a tradtional VM is to use something like [krunvm](https://github.com/containers/krunvm)

#### gcc
```
arch -arm64 brew install gcc@12
```

If you have an alternate version of gcc installed, create symlinks:
```
cd /opt/homebrew/bin
ln -s gcc-12 gcc 
ln -s g++-12 g++
```

# Toolchain


## Build your own 
Compile your own toolchain with [musl-cross-make](https://github.com/richfelker/musl-cross-make.git)


### arm64


```
TARGET=aarch64-linux-musl make
TARGET=aarch64-linux-musl make install
```

### TODO:x86_64



Installs to `output/` 
Add the toolchain to your shell's PATH:
`export PATH=$PATH:/path/to/out/bin`

# Building SnackLinux

## Environment vars

`JOBS` Set number of parallel jobs to create, defaults to -j8
Example
`make busybox JOBS=-j12`

### Architechtures

Building for arm64:

`ARCH=aarch64`
Example
`make busybox ARCH=aarch64 JOBS=-j4`
Defaults to x86_64



## Versions
See `defs.sh` for kernel and package versions




##### Linux - 

```
make kernel
```

##### musl - 
```
make musl
```
##### BusyBox - 

```
make busybox
```
 

##### Bash - 

```
make bash
```
##### Binutils (optional)

```
make binutils
```

#### Syslinux

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

# Booting
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
## ISO

Run `make iso`. The output ISO will be in `iso/`

Note: you do not have to have the toolchain to create the ISO

## qemu
Create a gzipped rootfs by running:
```
cd /opt/snacklinux_rootfs/; find . -print | cpio -o -H newc --quiet | gzip -6 > ../rootfs.gz 
```
Then boot in qemu:

## TODO: arm64:


## x86_64:
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
