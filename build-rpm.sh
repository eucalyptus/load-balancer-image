#!/bin/bash

if [ ! -d ./rpmfab ]; then
    git clone git://github.com/gholms/rpmfab.git
fi

rpmfab/build-arch.py -r epel-6-x86_64 -o results \
    --mock-options "--uniqueext $BUILD_TAG" *.src.rpm

