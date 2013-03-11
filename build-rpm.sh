#!/bin/bash

set -x

[ -d ./build ] && rm -rf build

mkdir -p build/{BUILD,BUILDROOT,SRPMS,RPMS,SOURCES,SPECS}
mkdir results
rpm -ivh --define "_topdir `pwd`/build" *.src.rpm

if [ "$1" = "devel" ]; then
    rpmbuild --define "_topdir `pwd`/build" \
        --define "dist .el6" --define "devbuild 1" \
        -ba build/SPECS/*.spec
else
    rpmbuild --define "_topdir `pwd`/build" \
        --define "dist .el6" \
        -ba build/SPECS/*.spec
fi

find build/ -name "*.rpm" -exec mv {} results/ \;

