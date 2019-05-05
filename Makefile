
# http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html

.PHONY: busybox linux initramfs clean grub

INITRAMFS=initramfs-busybox-x86.cpio.gz

all: linux initramfs grub

grub:
	cd grub ; ./autogen.sh
	cd grub ; ./configure
	cd grub ; $(MAKE)

initramfs: $(INITRAMFS)

$(INITRAMFS): busybox
	mkdir -pv initramfs/bin
	mkdir -pv initramfs/dev
	mkdir -pv initramfs/etc
	mkdir -pv initramfs/proc
	mkdir -pv initramfs/sbin
	mkdir -pv initramfs/sys
	cd initramfs/bin ; ../../busybox/busybox --install .
	cd initramfs ; find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../$(INITRAMFS)

busybox:
	ln -f config/busybox.conf busybox/.config
	cd busybox ; $(MAKE)

linux: bzImage

bzImage:
	ln -f config/linux.conf linux/.config
	cd linux ; $(MAKE) bzImage
	cp linux/arch/x86/boot/bzImage .

clean:
	rm -f bzImage linux/arch/x86/boot/bzImage busybox/busybox $(INITRAMFS)

