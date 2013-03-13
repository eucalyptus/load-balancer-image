#!/bin/bash
#
# Copyright 2009-2013 Eucalyptus Systems, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.
#
# Please contact Eucalyptus Systems, Inc., 6755 Hollister Ave., Goleta
# CA 93117, USA or visit http://www.eucalyptus.com/licenses/ if you need
# additional information or have any questions.

if [ `id -u` -ne 0 ]; then
    echo "must run as root"
    exit 1
fi

KSFILE=$1

if [ -z $KSFILE ]; then
    echo "need to provide a kickstart file"
    exit 1
fi

PKGNAME=eucalyptus-load-balancer-image

if [ ! -d ./ami-creator ]; then
	git clone git://github.com/katzj/ami-creator.git
fi

mkdir -p ./tmp

./ami-creator/ami_creator/ami_creator.py \
	-c $KSFILE -t ./tmp \
	-n euca-lb -v -e || exit 1

rm -rf $PKGNAME

mkdir -p $PKGNAME

mv *.img vmlinuz* init* $PKGNAME/

tar -czvf $PKGNAME.tgz $PKGNAME

