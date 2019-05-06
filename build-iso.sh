#!/usr/bin/env bash

mkdir -p cdroot
mkdir -p cdroot/boot
mkdir -p cdroot/boot/grub

cp initramfs-busybox-x86.cpio.gz cdroot/boot
cp bzImage cdroot/boot
cat <<-EOF > cdroot/boot/grub/grub.cfg
	set default="0"
	set timeout=20
	menuentry "Busybox/Linux" {
	    linux /boot/bzImage textonly
	    initrd /boot/initramfs-busybox-x86.cpio.gz
	}
	menuentry "Boot from the first hard disk" {
	    set root=(hd0)
	    chainloader +1
	}
	EOF

grub-mkrescue -o image.iso cdroot
