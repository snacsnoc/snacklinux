#!/bin/bash

# Download package prerequisites
# Mirrors of the packages can also be found at http://snacklinux.geekness.eu/tars/
# Original script from gcc
#
# (C) 2010 Free Software Foundation
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.

source defs.sh

wget http://kernel.org/pub/linux/kernel/v6.x/$LINUX.tar.xz || exit 1
tar xf $LINUX.tar.xz || exit 1
ln -sf $LINUX linux || exit 1

wget http://www.musl-libc.org/releases/$MUSL.tar.gz || exit 1
tar xf $MUSL.tar.gz || exit 1
ln -sf $MUSL musl || exit 1

wget http://ftp.gnu.org/gnu/binutils/$BINUTILS.tar.bz2 || exit 1
tar xjf $BINUTILS.tar.bz2 || exit 1
ln -sf $BINUTILS binutils || exit 1

wget http://www.busybox.net/downloads/$BUSYBOX.tar.bz2 || exit 1
tar xjf $BUSYBOX.tar.bz2 || exit 1
ln -sf $BUSYBOX busybox || exit 1

wget https://ftp.gnu.org/gnu/bash/$BASH.tar.gz || exit 1
tar xf $BASH.tar.gz || exit 1
ln -sf $BASH bash || exit 1

wget https://www.kernel.org/pub/linux/utils/boot/syslinux/$SYSLINUX.tar.gz || exit 1
tar xf $SYSLINUX.tar.gz || exit 1
ln -sf $SYSLINUX syslinux || exit 1

wget https://www.python.org/ftp/python/$PYTHON/$PYTHON.tar.xz
tar xvf $PYTHON.tar.xz || exit 1
ln -sf $PYTHON.tar.xz python || exit 1
