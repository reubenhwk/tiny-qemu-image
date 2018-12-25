
# http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html

all: build/bzImage build/bin/busybox build/init initramfs

initramfs: initramfs-busybox-x86.cpio.gz

initramfs-busybox-x86.cpio.gz: build/busybox
	cd build ; find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs-busybox-x86.cpio.gz

build:
	mkdir -pv build/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}

build/init: build
	cp init build/init

build/busybox: build
	ln -f config/busybox.conf busybox/.config
	cd busybox ; $(MAKE) -j
	cp busybox/busybox build/bin/.
	cd build/bin ; ./busybox --install .

bzImage:
	ln -f config/linux.conf linux/.config
	cd linux ; $(MAKE) -j bzImage
	cp linux/arch/x86/boot/bzImage .

