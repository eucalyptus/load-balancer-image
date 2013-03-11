#!/bin/bash

[ -d ./build ] && rm -rf build

rm -f *.src.rpm

mkdir -p build/{BUILD,BUILDROOT,SRPMS,RPMS,SOURCES,SPECS}

cp *.spec build/SPECS
cp *.tgz *.ks build-eustore-tarball.sh IMAGE-LICENSE build/SOURCES

if [ "$1" = "devel" ]; then
    rpmbuild --define "_topdir `pwd`/build" \
        --define "dist .el6" --define "devbuild 1" \
        -bs build/SPECS/eucalyptus-load-balancer-image.spec
else
    rpmbuild --define "_topdir `pwd`/build" \
        --define "dist .el6" \
        -bs build/SPECS/eucalyptus-load-balancer-image.spec
fi

mv build/SRPMS/*.src.rpm .

