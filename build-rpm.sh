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

