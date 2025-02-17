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

download_and_extract() {
    local url=$1
    local file=$2
    local extract_cmd=$3
    local link_name=$4

    if [[ ! -f $file ]]; then
        echo "Downloading $file..."
        wget "$url" -O "$file" || exit 1
    else
        echo "$file already exists, skipping download."
    fi

    # Extract and create symlink
    if [[ ! -d ${file%.*} ]]; then
        echo "Extracting $file..."
        $extract_cmd "$file" || exit 1
    else
        echo "$file already extracted, skipping."
    fi

    ln -sf ${file%.*} "$link_name" || exit 1
}

download_and_extract "http://kernel.org/pub/linux/kernel/v4.x/$LINUX.tar.xz" \
                     "$LINUX.tar.xz" "tar xf" "linux"

download_and_extract "http://www.musl-libc.org/releases/$MUSL.tar.gz" \
                     "$MUSL.tar.gz" "tar xf" "musl"

download_and_extract "http://ftp.gnu.org/gnu/binutils/$BINUTILS.tar.bz2" \
                     "$BINUTILS.tar.bz2" "tar xjf" "binutils"

download_and_extract "http://www.busybox.net/downloads/$BUSYBOX.tar.bz2" \
                     "$BUSYBOX.tar.bz2" "tar xjf" "busybox"

download_and_extract "https://ftp.gnu.org/gnu/bash/$BASH.tar.gz" \
                     "$BASH.tar.gz" "tar xf" "bash"

download_and_extract "https://www.kernel.org/pub/linux/utils/boot/syslinux/$SYSLINUX.tar.gz" \
                     "$SYSLINUX.tar.gz" "tar xf" "syslinux"
