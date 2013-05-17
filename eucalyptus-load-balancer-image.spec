Name:           eucalyptus-load-balancer-image%{?devbuild:-devel}
Version:        %{build_version}
Release:        0%{?build_id:.%build_id}%{?dist}
Summary:        Elastic Load Balancer Machine Image

Group:          Applications/System
# License needs to be the *distro's* license (Fedora is GPLv2, for instance)
License:        GPLv2
URL:            http://www.eucalyptus.com/
# Eustore image tarball
Source0:        %{name}-%{build_version}%{?build_id:-%build_id}.tgz
# Image's OS's license
Source1:        IMAGE-LICENSE
# Kickstart used to build the image
Source2:        %{name}.ks
# Installation script
Source3:        euca-install-load-balancer

Requires: euca2ools >= 3.0.0

%description
This package contains a machine image for use in Eucalyptus as a load
balancer virtual machine.


%prep
cp -p %{SOURCE1} IMAGE-LICENSE
cp -p %{SOURCE2} %{name}.ks

%build
# No build required

%install
install -d -m 755 $RPM_BUILD_ROOT/usr/share/%{name}
cp -p %{SOURCE0} $RPM_BUILD_ROOT/usr/share/%{name}
install -d -m 755 $RPM_BUILD_ROOT/usr/bin
install -m 755 %{SOURCE3} $RPM_BUILD_ROOT/usr/bin

%files
%doc IMAGE-LICENSE %{name}.ks
/usr/share/%{name}
/usr/bin/euca-install-load-balancer

%changelog
* Thu May 16 2013 Eucalyptus Release Engineering <support@eucalyptus.com> - 1.0-0
- Added load balancer easy install script

* Tue May 07 2013 Eucalyptus Release Engineering <support@eucalyptus.com> - 0.1-0
- Removed eustore builder script since this is not necessary
- KS is now under docs

* Tue Jan 29 2013 Eucalyptus Release Engineering <support@eucalyptus.com> - 0.1-0
- Created

