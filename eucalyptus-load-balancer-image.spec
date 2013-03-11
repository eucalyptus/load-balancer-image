Name:           eucalyptus-load-balancer-image
Version:        1.0.0
Release:        0%{?build_id:.%build_id}%{?devbuild:.dev}%{?dist}
Summary:        Eucalyptus Elastic Load Balancer Machine Image

Group:          Applications/System
# License needs to be the *distro's* license (Fedora is GPLv2, for instance)
License:        GPLv2
URL:            http://www.eucalyptus.com/
# Eustore image tarball
Source0:        %{name}.tgz
# Image's OS's license
Source1:        IMAGE-LICENSE
# Script used to build the image
Source2:        build-eustore-tarball.sh
# Kickstart used to build the image
Source3:        %{name}.ks

%description
This package contains a machine image for use in Eucalyptus as a load
balancer virtual machine.


%prep
cp -p %{SOURCE1} IMAGE-LICENSE


%build
# No build required 

%install
mkdir -p $RPM_BUILD_ROOT/usr/share/%{name}
cp -p %{SOURCE0} %{SOURCE2} %{SOURCE3} $RPM_BUILD_ROOT/usr/share/%{name}/

%files
%doc IMAGE-LICENSE
/usr/share/%{name}

%changelog
* Tue Jan 29 2013 Eucalyptus Release Engineering <support@eucalyptus.com> - 0.1-0
- Created

