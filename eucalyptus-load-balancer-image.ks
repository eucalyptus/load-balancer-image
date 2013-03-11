# Build a basic CentOS 6 AMI
lang en_US.UTF-8
keyboard us
skipx
timezone UTC
auth --useshadow --enablemd5
selinux --permissive
firewall --enabled --ssh
bootloader --timeout=1  --append xen_blkfront.sda_is_xvda=1
network --bootproto=dhcp --device=eth0 --onboot=on
services --enabled=network,load-balancer-servo


# Uncomment the next line
# to make the root password be password
# By default the root password is emptied
#rootpw foobar

#
# Define how large you want your rootfs to be
# NOTE: S3-backed AMIs have a limit of 10G
#
part / --size 524 --fstype ext3

#
# Repositories
repo --name=CentOS6-Base --baseurl=http://mirror.qa.eucalyptus-systems.com/centos/6.3/os/$basearch/
repo --name=CentOS6-Updates --baseurl=http://mirror.qa.eucalyptus-systems.com/centos/6.3/updates/$basearch/
repo --name=EPEL --baseurl=http://mirror.qa.eucalyptus-systems.com/epel/6/$basearch/

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

#
# Loadbalancer packages
haproxy
load-balancer-servo

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

# set up ec2-user
%post --erroronfail
/usr/sbin/useradd ec2-user
echo 'ec2-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

%end


#
# Add custom post scripts after the base post.
#
%post
%end

