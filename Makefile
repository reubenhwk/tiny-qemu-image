
# http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html

.PHONY: busybox linux initramfs build clean grub

INITRAMFS=initramfs-busybox-x86.cpio.gz

busy.iso: linux initramfs grub
	./busy.sh

grub/grub-mkrescue:
	cd grub ; ./autogen.sh
	cd grub ; ./configure
	cd grub ; $(MAKE)

initramfs: $(INITRAMFS)

$(INITRAMFS): build
	cd build ; find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../$(INITRAMFS)

build: busybox
	mkdir -pv build/bin
	mkdir -pv build/etc
	mkdir -pv build/proc
	mkdir -pv build/sbin
	mkdir -pv build/sys
	mkdir -pv build/usr/bin
	mkdir -pv build/usr/sbin
	cd build/bin ; ../../busybox/busybox --install .

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

