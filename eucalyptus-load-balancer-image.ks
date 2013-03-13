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

#
# Eucalyptus Loadbalancer Release Image
# 
# This image is meant to be distributed along with Eucalyptus
#
lang en_US.UTF-8
keyboard us
skipx
timezone UTC
auth --useshadow --enablemd5
selinux --permissive
firewall --disabled
bootloader --timeout=1  --append xen_blkfront.sda_is_xvda=1
network --bootproto=dhcp --device=eth0 --onboot=on
services --enabled=network,ntpd,ntpdate,load-balancer-servo
part / --size 524 --fstype ext3

#
# Repositories
repo --name=CentOS6-Base --baseurl=http://mirror.qa.eucalyptus-systems.com/centos/6.3/os/$basearch/
repo --name=CentOS6-Updates --baseurl=http://mirror.qa.eucalyptus-systems.com/centos/6.3/updates/$basearch/
repo --name=EPEL --baseurl=http://mirror.qa.eucalyptus-systems.com/epel/6/$basearch/

#
# Needed for HAProxy development builds and servo package
repo --name=LoadBalancerServo --mirrorlist=http://packages.release.eucalyptus-systems.com/api/1/genrepo/?distro=centos&releasever=6&arch=x86_64&ref=master&url=git://github.com/eucalyptus/load-balancer-servo.git

#
#
# Add all the packages after the base packages
#
%packages --nobase --excludedocs --instLangs=en
@core
acpid
audit
bash
chkconfig
cloud-init
coreutils
curl
e2fsprogs
grub
kernel-xen
openssh-clients
openssh-server
passwd
pciutils
policycoreutils
rootfiles
sudo
system-config-firewall-base
system-config-securitylevel-tui
ntp
ntpdate

#
# Loadbalancer packages
haproxy
load-balancer-servo
python-boto
python-httplib2

#
# Package exclusions
-atmel-firmware
-b43-openfwwf
-cyrus-sasl
-postfix
-sysstat
-xorg-x11-drv-ati-firmware
-yum-utils
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
-iwl1000-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6050-firmware
-libertas-usb8388-firmware
-rt61pci-firmware
-rt73usb-firmware
-mysql-libs
-zd1211-firmware
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware
-ql2400-firmware
-ql2500-firmware
-aic94xx-firmware
-iwl6000g2a-firmware
-iwl100-firmware
-bfa-firmware

%end

#
# Fix sudo settings so that servo is able to start haproxy without a tty
%post --erroronfail
sed -i '/requiretty/s/^/#/' /etc/sudoers
sed -i '/!visiblepw/s/^/#/' /etc/sudoers
%end

