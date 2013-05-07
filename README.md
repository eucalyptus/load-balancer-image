load-balancer-image
===================

What is this?
-------------

This repository contains kickstart templates and scripts used to build the
Eucalyptus Load Balancer EMI.

Installing from an RPM package
------------------------------

The easiest way to get load balancer support into your Eucalyptus 3.3
installation is to install the RPM package. The latest milestone release can be
obtained from the repository
[here](http://downloads.eucalyptus.com/software/eucalyptus/nightly/3.3-m6/centos/6/x86_64/).
Of course, you'll first need to have the Eucalyptus 3.3 milestone 6 release
installed on your system. Once that is complete, you can install load balancer
support from the same package repository. Run the following command on the box
hosting your Cloud Controller:

    $ yum install eucalyptus-load-balancer-image-devel

By running that command you'll install the development version of the load
balancer image. To install the release version of the image, you can run the
following instead:

    $ yum install eucalyptus-load-balancer-image

You can read more about the differences between the development and released
versions of the image below. Now that you've installed the package, you now
need to load the image into Eucalyptus. You can do that with the following
commands:

    $ cd /usr/share/eucalyptus-load-balancer-image-devel
    $ eustore-install-image -t eucalyptus-load-balancer-image-devel.tgz \
        -a x86_64 -s loadbalancer -b loadbalancer

Once you've loaded the image, you'll need to find the EMI of the image by
describing installed images:

    $ . ~/eucarc # source your euca creds
    $ euca-describe-images | grep loadbalancer

Find the correct EMI number for the load balancer and use that to configure
load balancer support using the configuration instructions below.

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

### Installing the image in your cloud

You'll need to use the *eustore* tools in order to install the image into your
cloud. First, copy the eustore tarball that was created when you ran
*build-eustore-tarball.sh* to your Eucalyptus Cloud Controller. Then run the
following command:

    $ eustore-install-image -b <bucket_name> -a x86_64 -s loadbalancer -t eucalyptus-load-balancer-image.tgz

### Configuring support for loadbalancing

Now that the image is installed, you'll need to make sure that you configure
properties for the load balancer. At a minimum you will need to configure the
EMI of your load balancer, as well as the load balancer instance type.

    $ euca-modify-property -p loadbalancing.loadbalancer_emi=emi-12345678
    $ euca-modify-property -p loadbalancing.loadbalancer_instance_type=m1.small

