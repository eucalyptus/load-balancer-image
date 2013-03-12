load-balancer-image
===================

What is this?
-------------

This repository contains kickstart templates and scripts used to build the
Eucalyptus Load Balancer EMI.

Kickstart templates
-------------------

You'll notice that in the repository there are two separate kickstart templates:

* eucalyptus-load-balancer-image.ks - This kickstart builds the image that will
  ship with Eucalyptus
* eucalyptus-load-balancer-image-devel.ks - This kickstart builds an image that
  is useful for development (e.g., you can SSH into this one and muck around)

Building an image
-----------------

To build a tarball that is compatible with eustore, do the following:

    $ ./build-eustore-tarball.sh <kickstart>

Where *kickstart* is either the template for the release or development version of the EMI.
This tarball can then be packaged as an RPM by running the following commands:

    $ ./build-srpm.sh
    $ ./build-rpm.sh

The RPM packages built will be placed in the *results* subdirectory.

Installing the image in your cloud
----------------------------------

You'll need to use the *eustore* tools in order to install the image into your
cloud. First, copy the eustore tarball that was created when you ran
*build-eustore-tarball.sh* to your Eucalyptus Cloud Controller. Then run the
following command:

    $ eustore-install-image -b <bucket_name> -a x86_64 -s loadbalancer -t eucalyptus-load-balancer-image.tgz

Configuring support for loadbalancing
-------------------------------------

Now that the image is installed, you'll need to make sure that you configure
properties for the load balancer. At a minimum you will need to configure the
EMI of your load balancer, as well as the load balancer instance type.

    $ euca-modify-property -p loadbalancing.loadbalancer_emi=emi-12345678
    $ euca-modify-property -p loadbalancing.loadbalancer_instance_type=m1.small

