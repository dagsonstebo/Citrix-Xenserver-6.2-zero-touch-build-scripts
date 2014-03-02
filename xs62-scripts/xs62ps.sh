#!/bin/bash
#
# Copyright 2014 Dag Sonstebo
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
BUILDSERVER="http://192.168.0.100";

# Download host config file
mkdir /tmp/root/root/build
cd /tmp/root/root/build
strConfigfile=`grep HOSTNAME /tmp/root/etc/sysconfig/network | cut -d"=" -f2 | cut -d"." -f1`".cfg"
wget ${BUILDSERVER}/ks/xs62/${strConfigfile}

# Download model specific drivers
mkdir /tmp/root/root/build/drivers	
cd /tmp/root/root/build/drivers	
strManufacturer=`dmidecode --string system-manufacturer | sed 's/\ /_/g' | sed 's/\.//g' | sed 's/\,//g'`
strModel=`dmidecode --string system-product-name | sed 's/\ /_/g' | sed 's/\.//g' | sed 's/\,//g'`
strDriverfile="XS62_"${strManufacturer}"_"${strModel}".tgz"
wget ${BUILDSERVER}/xs62-drivers/${strDriverfile}

# Download patches
mkdir /tmp/root/root/build/patches
cd /tmp/root/root/build/patches
wget ${BUILDSERVER}/xs62-patches/xs62patches.tgz

# Tweak splash screen
cd /tmp/root/usr/share/splashy/themes/citrix-theme
wget ${BUILDSERVER}/xs62-scripts/xsbuildbackground.png
mv background.png ctxbackground.orig
mv xsbuildbackground.png background.png

# Download and start build script
cd /tmp/root/etc/init.d
wget ${BUILDSERVER}/xs62-scripts/xs62buildsvc
chmod 755 xs62buildsvc
chroot /tmp/root /sbin/chkconfig xs62buildsvc on
reboot