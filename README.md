SnackLinux
===========
:computer: SnackLinux is an ultra minimal Linux distribution 

:wrench: Utilizing a recent 6.x kernel with BusyBox, musl and Bash 

:small_orange_diamond: Built from scratch with a footprint of less than 20MB 

:file_folder:	Bash-based package manager [fbpkg](https://github.com/snacsnoc/fbpkg)

:package: x86 has 31 packages, including a working gcc toolchain and other GNU utilities 

:battery: arm64 support

:whale: (in-progress) Docker support 

Visit [snacklinux.geekness.eu](snacklinux.geekness.eu) for downloads, wiki and more information about SnackLinux.


The philosophy is to create a completely hackable Linux system, controllable by makefiles. The system installs to a local directory, anything in there is included in the final build. Imagine [Linux From Scratch](https://www.linuxfromscratch.org/) but with a lot less features.

SnackLinux runs a barebone kernel with downloadable extra kernel modules. Initially the project was created to run on old 486 CPUs with the latest software, so SnackLinux is optimized for size and low RAM. The x86 bootable ISO is 7MB in size!




Archtechtures supported:
* arm64
* i486 (updating)
* amd64/x86_64 (old, but works with effort)


Building SnackLinux from source
-------------------------------


# Build system

* Linux is preferable to build with
 
**Debian**
```
apt-get install build-essential git libgmp-dev libmpc-dev flex bison bc 
``` 
Optional:
```
apt-get install genisoimage #used for generating x86 ISO images
```

**Mac OS***
* Mac OS is **incredibly** difficult to get working alone to build the kernel, otherwise cross-compiling packages works
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

See cross-compiler.md

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


Installs to `output/` 
Add the toolchain to your shell's PATH:
`export PATH=$PATH:/path/to/out/bin`

# Building SnackLinux

## Environment vars

`JOBS` Set number of parallel jobs to create, defaults to -j8
Example
`make busybox JOBS=-j12`

### Architechtures
Change target arch by using switches with make:
```
TARGET=aarch64
TARGET=x86
TARGET=x86_64
```

Building for arm64:

Example
`make busybox TARGET=aarch64 JOBS=-j4`

Defaults to x86





## Versions
See `defs.sh` for kernel and package versions


## Getting started


Download source tars and link

`bash ./download_prereq.sh `

Set the amount of parallel jobs to run when using make
```
export JOBS=j16
```

Compile the kernel

```
make kernel
```

Build musl, Bash and BusyBox
```
make system
```

Install to `/opt/snacklinux_rootfs` directory

```
make install
```

Next step: [booting](#Booting)


#### Compile individual packages


#### Linux - 

```
make kernel
```

#### musl - 
```
make musl
```
#### BusyBox - 

```
make busybox
```
 
#### Bash - 

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
make TARGET=aarch64 strip-fs
```

#### additional packages
See 
# Booting
Prerequisites:
```
#Base files (/etc)
git clone https://github.com/snacsnoc/snacklinux-base.git
cp -R snacklinux-base/rootfs/* /opt/snacklinux_rootfs/

#Create /dev files and required directories
./tools/create_dev.sh

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
cd /opt/snacklinux_rootfs/; find . -print | cpio -o -H newc --quiet | gzip -6 > ~/rootfs.gz 
```
Then boot in qemu:

## arm64:
Linux:
```
qemu-system-aarch64 -M virt,highmem=off -kernel linux/arch/arm64/boot/Image -initrd rootfs.gz -append "root=/dev/ram" -m 256 -serial stdio -boot menu=off -cpu max -nodefaults -boot d -device virtio-gpu-pci -device virtio-keyboard-pci,id=kbd0,serial=virtio-keyboard
```

Mac OS (M1):
```
qemu-system-aarch64 -M virt,highmem=off -kernel Image -initrd rootfs.gz -append "root=/dev/ram" -m 128  -boot menu=off -cpu max -nodefaults -boot d -bios "/opt/homebrew/Cellar/qemu/7.1.0/share/qemu/edk2-aarch64-code.fd" -device virtio-gpu-pci  -device virtio-keyboard-pci,id=kbd0,serial=virtio-keyboard -accel hvf 
```

Run a VNC server with qemu:
`-vnc 12.34.56.78:0`

## x86:
```
qemu-system-i386 -cpu 486-v1 -m 256 -kernel bzImage -initrd rootfs.gz -append "root=/dev/ram rdinit=/sbin/init"
```


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

Rich Felker for creating musl-cross-make and make building so easy https://github.com/richfelker/musl-cross-make

Here are links to the software used in SnackLinux:

[syslinux](https://www.kernel.org/pub/linux/utils/boot/syslinux/)

[linux](https://www.kernel.org)

[busybox](http://www.busybox.net/downloads/)

[bash](http://ftp.gnu.org/gnu/bash/)

[fbpkg](https://github.com/snacsnoc/fbpkg)

[binutils](http://ftp.gnu.org/gnu/binutils/)

[musl](http://www.musl-libc.org/)

Resources
----------
http://port70.net/~nsz/32_dynlink.html
https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
