SnackLinux
===========
![alt text](http://snacklinux.geekness.eu/_media/ezgif.com-gif-maker_1_.gif)

:computer: SnackLinux is an ultra minimal Linux distribution 

:wrench: Utilizing a recent 6.x kernel with BusyBox, musl and Bash 

:small_orange_diamond: Built from scratch with a footprint of less than 20MB 

:file_folder:	Bash-based package manager [fbpkg](https://github.com/snacsnoc/fbpkg)

:package: x86 has 31 packages, including a working gcc toolchain and other GNU utilities 

:battery: arm64 support

:whale: (in-progress) Docker support 

Visit [snacklinux.geekness.eu](http://snacklinux.geekness.eu) for downloads, wiki and more information about SnackLinux.
______
SnackLinux runs a barebone kernel with downloadable extra kernel modules.

The philosophy is to create a completely hackable Linux system using standard GNU utilities, controlled by makefiles. The system installs to a local directory, anything in there is included in the final build. Imagine [Linux From Scratch](https://www.linuxfromscratch.org/) but with a lot less features. If you've ever wanted to build your own Linux distribution in 30 minutes, this is the project you're after.

Initially the project was created to run on old 486 CPUs with the latest software, so SnackLinux is optimized for size and low RAM. The x86 bootable ISO is 7MB in size!




__Archtechtures supported:__
* arm64 (current, works) - Targeting Apple Silicon
* i486 (updating)
* amd64/x86_64 (old, but works with effort)


# Compiling SnackLinux from source
-------------------------------


# Build system

* Linux is preferable to build with
 
## Debian
```
apt-get install build-essential git libgmp-dev libmpc-dev flex bison bc 
``` 
_Optional:_
```
apt-get install genisoimage #used for generating x86 ISO images
```

## Mac OS*
* Mac OS is **incredibly** difficult to get working alone to build the kernel, otherwise cross-compiling packages works
* An alternative to a tradtional VM is to use something like [krunvm](https://github.com/containers/krunvm)

### gcc
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

`git clone https://github.com/richfelker/musl-cross-make.git`

### arm64

```
TARGET=aarch64-linux-musl make
TARGET=aarch64-linux-musl make install
```

### x86

```
TARGET=i486-linux-musl make
TARGET=i486-linux-musl make install
```


### TODO:x86_64


Toolchain installs to `output/` 

Add the toolchain to your shell's PATH:
```
export PATH=$PATH:/path/musl-cross-make/output/bin
```

# Building SnackLinux
After our toolchain is built, we can build SnackLinux which includes the kernel and user utilities.

## Environment vars

 `JOBS` 
Set number of parallel jobs to create, defaults to -j8
Example:
`export JOBS=-j12`

`ROOTFS_PATH`
Path to SnackLinux root filesystem, defaults to `/opt/snacklinux_rootfs`

### Architechtures
```
TARGET=aarch64
TARGET=i386
TARGET=x86_64
```
Defaults to `i486`

__Example, building for arm64:__

`export TARGET=aarch64 JOBS=-j4`


## Versions
See `defs.sh` for defined kernel and package versions


## Getting started


* Download source tars and link

`bash ./download_prereq.sh `


* Compile the kernel

```
make kernel
```

* Build musl, Bash and BusyBox
```
make system
```

* Install to `/opt/snacklinux_rootfs` directory

```
make install
```

Next step: [booting](#Booting)


#### Compile individual packages
You can alternatively build the individual software and install at your will.

#### Linux 

```
make kernel
```

#### musl 
```
make musl
```
#### BusyBox 

```
make busybox
```
 
#### Bash 

```
make bash
```
#### Binutils (optional)

```
make binutils
```

#### Syslinux

```
make syslinux
```

#### Python (experimental)

```
make python
```

If you would also like to install binutils, use:

```
make binutils-install
```

#### stripping symbols

This target strips all debug symbols files matching LSB executable, shared object or ar archive 
```
make strip-fs
```

#### additional packages
See 
# Booting
Prerequisites:

#### Base files (/etc)
```
git clone https://github.com/snacsnoc/snacklinux-base.git
cp -R snacklinux-base/rootfs/* /opt/snacklinux_rootfs/
```
### Create /dev files and required directories
```
./tools/create_dev.sh
```
### fbpkg (package manager)
```
git clone https://github.com/snacsnoc/fbpkg.git
cp fbpkg/src/fbpkg /opt/snacklinux_rootfs/usr/bin
```
# Booting 
## ISO

Run `make iso`. The output ISO will be in `iso/`

Note: you do not have to have the toolchain to create the ISO

## qemu
Create a gzipped rootfs by running:
```
cd /opt/snacklinux_rootfs/; find . -print | cpio -o -H newc --quiet | gzip -6 > ~/rootfs.gz 
```
Then boot in qemu:

### arm64:
Linux:
```
qemu-system-aarch64 -M virt,highmem=off -kernel linux/arch/arm64/boot/Image -initrd rootfs.gz -append "root=/dev/ram" -m 256 -serial stdio -boot menu=off -cpu max -nodefaults -boot d -device virtio-gpu-pci -device virtio-keyboard-pci,id=kbd0,serial=virtio-keyboard
```

Mac OS (Apple Silicon):
```
qemu-system-aarch64 -M virt,highmem=off -kernel Image -initrd rootfs.gz -append "root=/dev/ram" -m 128  -boot menu=off -cpu max -nodefaults -boot d -bios "/opt/homebrew/Cellar/qemu/7.1.0/share/qemu/edk2-aarch64-code.fd" -device virtio-gpu-pci  -device virtio-keyboard-pci,id=kbd0,serial=virtio-keyboard -accel hvf 
```

Run a VNC server with qemu:
`-vnc 12.34.56.78:0`

### x86:
```
qemu-system-i386 -cpu 486-v1 -m 256 -kernel bzImage -initrd rootfs.gz -append "root=/dev/ram rdinit=/sbin/init"
```


### x86_64:
```
qemu-system-x86_64 -m 256 -kernel bzImage -initrd rootfs.gz -append "root=/dev/ram rdinit=/sbin/init"
```

# Packages
Read the [Packages page](http://snacklinux.geekness.eu/packages) for building packages.
For SnackLinux's package manager fbpkg, see [here](https://github.com/snacsnoc/fbpkg).

# Hacking
Edit anything in `/opt/snacklinux_rootfs`, it is the root filesystem.
The kernel can also be recompiled to fit your needs. 

The `boot/isolinux` directory is where ISOLINUX resides, edit the menu to adjust to your needs.

# Contributing
SnackLinux is a personal project, but I welcome contributions from the community. If you have ideas, feedback, or code changes that can improve SnackLinux, your input is valued.

Thanks
------
Mike Chirico for http://souptonuts.sourceforge.net/cdrom.htm

Tiny Core Linux distribution for inspiration and documentation http://tinycorelinux.net

Gregor Richards for the many Musl compiler scripts https://github.com/GregorR

Linux From Scratch for excellent documentation http://www.linuxfromscratch.org/

The Arch Linux wiki https://wiki.archlinux.org/

Rich Felker for creating musl-cross-make and make building so easy https://github.com/richfelker/musl-cross-make

Here are links to the software used in SnackLinux:

[syslinux](https://www.kernel.org/pub/linux/utils/boot/syslinux/)

[linux](https://www.kernel.org)

[busybox](http://www.busybox.net/downloads/)

[bash](http://ftp.gnu.org/gnu/bash/)

[fbpkg](https://github.com/snacsnoc/fbpkg)

[binutils](http://ftp.gnu.org/gnu/binutils/)

[musl](http://www.musl-libc.org/)

# Resources
http://port70.net/~nsz/32_dynlink.html
https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
