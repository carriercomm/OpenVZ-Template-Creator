#!/bin/bash
#
# OpenVZ Template OS Creator
# http://github.com/RogerSik/OpenVZ-Template-Creator
#
echo "Where to create the system? (default /mnt/dice)"
read input_path

echo "What is your host distro?"
echo "Supported: debian | ubuntu"
read input_host_distri

echo "clean umount"
umount $input_path/dev
umount $input_path/proc
umount $input_path/sys

echo "Clear/Create the path"
rm -rf $input_path/* 
mkdir $input_path

case "$input_host_distri" in
     ubuntu|debian)
		echo "Download and installation the latest debootstrap."
		wget http://files.yoschi.cc/debs/debootstrap.deb
		dpkg -i debootstrap.deb
		rm debootstrap.deb
		;;
     *)
		echo "Distri" $input_host_distri "not supported yet. Sorry."
		exit 0
		;; esac
clear

echo "What distri want you install?"
echo "Supported:"
echo "* Ubuntu 8.04 - Hardy Haron (hardy)"
echo "* Ubuntu 8.10 - Intrepid Ibex (intrepid)"
echo "* Ubuntu 9.04 - Jaunty  Jackalope (jaunty)"
echo "* Ubuntu 9.10 - Karmic Koala (karmic)"
echo "* Ubuntu 10.04 - Lucid Lync (lucid)"
echo " = "
read input_distri

echo ""
echo "i386 or amd64?"
echo ""
read input_arch

debootstrap --variant=minbase --arch $input_arch $input_distri $input_path

wget http://files.yoschi.cc/vpsmem
chmod +x vpsmem
mv vpsmem $input_path/usr/local/bin

#mount -o bind /dev $input_path/dev
mount -t proc none $input_path/proc # because another openssh-server will not configured to the end
#mount -t sysfs none $input_path/sys

chroot $input_path
