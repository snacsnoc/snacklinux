#!/bin/bash
#
# Create device files

# Check for ROOTFS_PATH environment variable, default to /opt/snacklinux_rootfs if not set
ROOTFS_PATH=${ROOTFS_PATH:-/opt/snacklinux_rootfs}

if [ "$(id -u)" != "0" ]; then
   echo "You must run this as root" 1>&2
   exit 1
fi

mkdir -v ${ROOTFS_PATH}/dev

mknod -m 600 ${ROOTFS_PATH}/dev/console c 5 1
mknod -m 666 ${ROOTFS_PATH}/dev/full c 1 7
mknod -m 666 ${ROOTFS_PATH}/dev/kmem c 1 2
mknod -m 666 ${ROOTFS_PATH}/dev/mem c 1 1
mknod -m 666 ${ROOTFS_PATH}/dev/null c 1 3
mknod -m 666 ${ROOTFS_PATH}/dev/port c 1 4
mknod -m 444 ${ROOTFS_PATH}/dev/random c 1 8
mknod -m 444 ${ROOTFS_PATH}/dev/urandom c 1 9
mknod -m 666 ${ROOTFS_PATH}/dev/zero c 1 5
mknod -m 666 ${ROOTFS_PATH}/dev/ram0 b 1 0
mknod -m 666 ${ROOTFS_PATH}/dev/ptmx c 5 2

# Only create two hard drive devs, more can be added
mknod -m 644 ${ROOTFS_PATH}/dev/hda b 3 0
mknod -m 644 ${ROOTFS_PATH}/dev/hdb b 3 64

mknod -m 644 ${ROOTFS_PATH}/dev/tty c 5 0
mknod -m 644 ${ROOTFS_PATH}/dev/tty0 c 4 0
mknod -m 644 ${ROOTFS_PATH}/dev/tty1 c 4 1 
mknod -m 644 ${ROOTFS_PATH}/dev/tty2 c 4 2
mknod -m 644 ${ROOTFS_PATH}/dev/tty3 c 4 3
mknod -m 644 ${ROOTFS_PATH}/dev/tty4 c 4 4
mknod -m 644 ${ROOTFS_PATH}/dev/tty5 c 4 5
mknod -m 644 ${ROOTFS_PATH}/dev/tty6 c 4 6
mknod -m 644 ${ROOTFS_PATH}/dev/vcs0 b 7 0

cp -avp /dev/core ${ROOTFS_PATH}/dev
cp -avp /dev/stderr ${ROOTFS_PATH}/dev
cp -avp /dev/stdin ${ROOTFS_PATH}/dev
cp -avp /dev/stdout ${ROOTFS_PATH}/dev

mkdir -v ${ROOTFS_PATH}/dev/shm
mkdir -v ${ROOTFS_PATH}/dev/pts

mkdir -v ${ROOTFS_PATH}/proc

mkdir -v ${ROOTFS_PATH}/usr
mkdir -v ${ROOTFS_PATH}/usr/bin

mkdir -v ${ROOTFS_PATH}/boot

mkdir -v ${ROOTFS_PATH}/tmp

mkdir -v ${ROOTFS_PATH}/sys

mkdir -vp ${ROOTFS_PATH}/var/log
