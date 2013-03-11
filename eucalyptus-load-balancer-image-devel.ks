#
# Eucalyptus Loadbalancer Development Image
# 
# This image is meant solely for development purposes. Each time an instance
# is started the latest load-balancer-servo code will be pulled down from
# github.
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
services --enabled=network

#
# Provide a default password for developer access
rootpw foobar

#
# Define how large you want your rootfs to be
# NOTE: S3-backed AMIs have a limit of 10G
#
part / --size 1024 --fstype ext3

#
# Repositories
repo --name=CentOS6-Base --baseurl=http://mirror.qa.eucalyptus-systems.com/centos/6.3/os/$basearch/
repo --name=CentOS6-Updates --baseurl=http://mirror.qa.eucalyptus-systems.com/centos/6.3/updates/$basearch/
repo --name=EPEL --baseurl=http://mirror.qa.eucalyptus-systems.com/epel/6/$basearch/

# Needed for HAProxy development builds
repo --name=HAProxy --baseurl=http://packages.release.eucalyptus-systems.com/yum/tags/balancer-master-build-bootstrap/centos/6/$basearch/

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
# servo packages
haproxy
python-httplib2
python-boto

#
# development tools
git
ipython
pylint

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
# Configure cloud-init
%post --erroronfail
cat > /etc/cloud/cloud.cfg << EOF
user: root
disable_root: 0
ssh_pwauth:   1

# Mounts for instance-store
mounts:
 - [ ephemeral0, /mnt ]
 - [ swap, none, swap, sw, 0, 0 ]

cc_ready_cmd: ['/bin/true']
locale_configfile: /etc/sysconfig/i18n
mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
ssh_deletekeys:   0
ssh_genkeytypes:  ~
ssh_svcname:      sshd
syslog_fix_perms: ~

cloud_init_modules:
 - bootcmd
 - resizefs
 - set_hostname
 - rsyslog
 - ssh

cloud_config_modules:
 - mounts
 - ssh-import-id
 - locale
 - set-passwords
 - timezone
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - keys-to-console
 - phone-home
 - final-message

# vim:syntax=yaml
EOF
%end

#
# Add cloud-init script that will bootstrap the load-balancer-servo package for us
%post --erroronfail
mkdir -p /var/lib/cloud/scripts/per-boot
cat > /var/lib/cloud/scripts/per-boot/bootstrap-servo.sh << EOF
#!/bin/bash
git clone git://github.com/eucalyptus/load-balancer-servo.git /mnt/load-balancer-servo
cd /mnt/load-balancer-servo
./install-servo.sh
service load-balancer-servo start
EOF
chmod 755 /var/lib/cloud/scripts/per-boot/bootstrap-jenkins.sh
%end

