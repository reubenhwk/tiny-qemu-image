#!/usr/bin/env bash

mkdir -p cdroot
mkdir -p cdroot/boot
mkdir -p cdroot/grub

cp initramfs-busybox-x86.cpio.gz cdroot/boot
cp bzImage cdroot/boot
cat <<-EOF > cdroot/grub/grub.cfg
	set default="0"
	set timeout=20
	menuentry "Ubuntu CLI" {
	    linux /boot/bzImage textonly
	    initrd /boot/initramfs-busybox-x86.cpio.gz
	}
	menuentry "Memory Test" {
	    linux16 /boot/memtest86+.bin
	}
	menuentry "Boot from the first hard disk" {
	    set root=(hd0)
	    chainloader +1
	}
	EOF
