#!/usr/bin/env bash

set -x -e

# Make sure only one instance of this
# script is running at a time.
exec 200>/var/lock/lrc-busycd
flock -n 200 || exit 1


# Make sure the path to the file
# exists, then copy the file, and
# copy the target if this is a link.
copyit () {
	mkdir -p $(dirname $2)
	cp -L $1 $2
}


rm -rf busycd
mkdir busycd
(
	cd busycd

	# These are all we need.
	mkdir etc
	mkdir boot
	mkdir boot/grub

	# Copy over the kernel
	cp ../initramfs-busybox-x86.cpio.gz   boot/.
	cp ../bzImage                         boot/.

	# Build a root filesystem
	mkdir rootfs
	(
		cd rootfs

		mkdir bin
		mkdir boot
		mkdir boot/grub
		mkdir dev
		mkdir etc
		mkdir etc/init.d
		mkdir etc/rc.d
		mkdir lib
		mkdir lib/modules
		mkdir lib64
		mkdir opt
		mkdir proc
		mkdir root
		mkdir run
		mkdir sbin
		mkdir sys
		mkdir usr
		mkdir usr/bin
		mkdir usr/lib
		mkdir usr/local
		mkdir usr/sbin
		mkdir usr/share
		mkdir var

		# Copy the two most important share objects
		copyit /lib/x86_64-linux-gnu/libc.so.6 lib/x86_64-linux-gnu/.
		copyit /lib64/ld-linux-x86-64.so.2 lib64/.

		# Copy and install busybox
		copyit ../../busybox/busybox bin/.
		(
			cd bin ; ./busybox --install .
		)

		# Init will run this rc file, which will mount
		# these filesystems.
		cat <<-EOF > etc/init.d/rcS
			mount none -t devtmpfs /dev
			mount none -t proc /proc
			mount none -t sysfs /sys
			EOF
		chmod +x etc/init.d/rcS

		## The kernel is going to need its modules...
		#cp -r /lib/modules/$(uname -r) lib/modules/.
	)
	mksquashfs rootfs rootfs.squashfs
	rm -rf rootfs

	# Copy the grub stuff
	#cp -r /boot/grub                  boot/.

	# Output a grub config
	cat <<-EOF > boot/grub/grub.cfg
		set default="0"
		set timeout=0

		menuentry "Linux" {
		linux /boot/bzImage textonly console=ttyS0
		initrd /boot/initramfs-busybox-x86.cpio.gz
		}

		menuentry "Boot from the first hard disk" {
		set root=(hd0)
		chainloader +1
		}
		EOF
)

grub-mkrescue -o busy.iso busycd

