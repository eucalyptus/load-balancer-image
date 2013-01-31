#!/bin/bash

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

./ami-creator/ami_creator/ami_creator.py \
	-c $KSFILE \
	-n euca-lb -v -e || exit 1

rm -rf $PKGNAME

mkdir -p $PKGNAME

mv *.img vmlinuz* init* $PKGNAME/

tar -czvf $PKGNAME.tgz $PKGNAME

