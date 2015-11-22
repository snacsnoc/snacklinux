#!/bin/bash
#
# Create device files


if [ "$(id -u)" != "0" ]; then
   echo "You must run this as root" 1>&2
   exit 1
fi

mkdir -v /opt/snacklinux_rootfs/dev

mknod -m 600 /opt/snacklinux_rootfs/dev/console c 5 1
mknod -m 666 /opt/snacklinux_rootfs/dev/full c 1 7
mknod -m 666 /opt/snacklinux_rootfs/dev/kmem c 1 2
mknod -m 666 /opt/snacklinux_rootfs/dev/mem c 1 1
mknod -m 666 /opt/snacklinux_rootfs/dev/null c 1 3
mknod -m 666 /opt/snacklinux_rootfs/dev/port c 1 4
mknod -m 444 /opt/snacklinux_rootfs/dev/random c 1 8
mknod -m 444 /opt/snacklinux_rootfs/dev/urandom c 1 9
mknod -m 666 /opt/snacklinux_rootfs/dev/zero c 1 5
mknod -m 666 /opt/snacklinux_rootfs/dev/ram0 b 1 0
mknod -m 666 /opt/snacklinux_rootfs/dev/ptmx c 5 2


#Only create two hard drive devs, more can be added
mknod -m 644 /opt/snacklinux_rootfs/dev/hda b 3 0
mknod -m 644 /opt/snacklinux_rootfs/dev/hdb b 3 64

mknod -m 644 /opt/snacklinux_rootfs/dev/tty c 5 0
mknod -m 644 /opt/snacklinux_rootfs/dev/tty0 c 4 0
mknod -m 644 /opt/snacklinux_rootfs/dev/tty1 c 4 1 
mknod -m 644 /opt/snacklinux_rootfs/dev/tty2 c 4 2
mknod -m 644 /opt/snacklinux_rootfs/dev/tty3 c 4 3
mknod -m 644 /opt/snacklinux_rootfs/dev/tty4 c 4 4
mknod -m 644 /opt/snacklinux_rootfs/dev/tty5 c 4 5
mknod -m 644 /opt/snacklinux_rootfs/dev/tty6 c 4 6
mknod -m 644 /opt/snacklinux_rootfs/dev/vcs0 b 7 0

cp -avp /dev/core   /opt/snacklinux_rootfs/dev
cp -avp /dev/stderr   /opt/snacklinux_rootfs/dev
cp -avp /dev/stdin   /opt/snacklinux_rootfs/dev
cp -avp /dev/stdout   /opt/snacklinux_rootfs/dev

mkdir -v /opt/snacklinux_rootfs/dev/shm
mkdir -v /opt/snacklinux_rootfs/dev/pts

mkdir -v /opt/snacklinux_rootfs/proc
mkdir -v /opt/snacklinux_rootfs/tmp
