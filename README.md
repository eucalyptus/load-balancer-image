Load Balancer Image
===================

What is this?
-------------

This repository contains kickstart templates and scripts used to build
the Eucalyptus Load Balancer EMI.

Installing from an RPM package
------------------------------

### Prerequisites

* Euca2ools 3.0.0 or newer, available [here](http://repos.fedorapeople.org/repos/gholms/cloud/)

### RPM Install

The easiest way to get Load Balancer support into your Eucalyptus 3.3
installation is to install the RPM package. The latest milestone
release can be obtained from the repository
[here](http://downloads.eucalyptus.com/software/eucalyptus/nightly/3.3/centos/6/x86_64/).
Of course, you'll first need to have the Eucalyptus 3.3 nightly
release installed on your system. Once that is complete, you can
install load balancer support from the same package repository. Run
the following command on the box hosting your Cloud Controller:

    $ yum install eucalyptus-load-balancer-image-devel

By running that command you'll install the development version of the
load balancer image. To install the release version of the image, you
can run the following instead:

    $ yum install eucalyptus-load-balancer-image

### Installing into the Cloud

You can read more about the differences between the development and
released versions of the image below. Now that you've installed the
package, you now need to load the image into Eucalyptus. You can do
that with the following commands:

    $ . /path/to/my/eucarc
    $ euca-install-load-balancer --install-default

Your Load Balancer is not installed, configured and ready to go! If
you're interesting in seeing which Load Balancer images you have
installed on your system, you can run:

    $ euca-install-load-balancer --list

This command will list all bundles installed with their versions as
well as showing you which machine image is enabled in Eucalyptus.

Repository information
----------------------

### Kickstart templates

You'll notice that in the repository there are two separate kickstart templates:

* eucalyptus-load-balancer-image.ks.in - This kickstart builds the image that will
  ship with Eucalyptus
* eucalyptus-load-balancer-image-devel.ks.in - This kickstart builds an image that
  is useful for development (e.g., you can SSH into this one and muck around)

### Prerequisites to building an image

PLEASE NOTE: It's highly recommended you build the EMI using Centos 6.4! These
instructions assume that you're doing just that.

You're first going to need to install the EPEL 6 repository release package:

    $ yum install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

In order to use the scripts to build an EMI image and the RPM package that
contains it, you'll have to install a few prerequisites:

    $ yum install git rpmdevtools python-jinja2 python-imgcreate

### Building an image

To build a tarball that is compatible with eustore, do the following:

    $ scripts/build-eustore-tarball.sh <kickstart-template>

Where *kickstart* is either the template for the release or development version of the EMI.
This tarball can then be packaged as an RPM by running the following commands:

    $ scripts/build-rpm.sh

If you're building the development version of the image, run this instead:
    
    $ scripts/build-rpm.sh devel

The RPM packages built will be placed in the *results* subdirectory.

Installation and configuration of the eustore tarball
-----------------------------------------------------

### Installing the Load Balancer Image

You'll need to use the *eustore* tools in order to install the image
into your cloud. First, copy the eustore tarball that was created when
you ran *build-eustore-tarball.sh* to your Eucalyptus Cloud Controller
along with the Load Balancer installation script
(euca-install-load-balancer). Then run the following command:

    $ ./euca-install-load-balancer -t eucalyptus-load-balancer-image.tgz

### Manually Enabling the Load Balancer

The command above will automatically enable the image you install. If
for any reason you need to manually set the machine image ID or other
Load Balancer parameters, you can use the commands below:

    $ euca-modify-property -p loadbalancing.loadbalancer_emi=emi-12345678
    $ euca-modify-property -p loadbalancing.loadbalancer_instance_type=m1.small