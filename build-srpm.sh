#!/bin/bash

[ -d ./build ] && rm -rf build

rm -f *.src.rpm

mkdir -p build/{BUILD,BUILDROOT,SRPMS,RPMS,SOURCES,SPECS}

cp *.spec build/SPECS
cp *.tgz *.ks build-eustore-tarball.sh IMAGE-LICENSE build/SOURCES

rpmbuild --define "_topdir `pwd`/build" --define "dist .el6" \
    -bs build/SPECS/eucalyptus-load-balancer-image.spec

mv build/SRPMS/*.src.rpm .

