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

wget https://www.python.org/ftp/python/$PYTHON/$PYTHON.tar.xz
tar xvf $PYTHON.tar.xz || exit 1
ln -sf $PYTHON python || exit 1

wget https://www.openssl.org/source/$OPENSSL.tar.gz
tar xvf $OPENSSL.tar.gz || exit 1
ln -sf $OPENSSL openssl || exit 1