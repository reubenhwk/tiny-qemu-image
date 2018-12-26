
# http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html

.PHONY: busybox linux initramfs build clean

INITRAMFS=initramfs-busybox-x86.cpio.gz

all: linux initramfs

initramfs: $(INITRAMFS)

$(INITRAMFS): build
	cd build ; find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../$(INITRAMFS)

build: busybox
	mkdir -pv build/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}
	cd build/bin ; ../../busybox/busybox --install .

busybox:
	ln -f config/busybox.conf busybox/.config
	cd busybox ; $(MAKE) -j

linux: bzImage

bzImage:
	ln -f config/linux.conf linux/.config
	cd linux ; $(MAKE) -j bzImage
	cp linux/arch/x86/boot/bzImage .

clean:
	rm -f bzImage linux/arch/x86/boot/bzImage busybox/busybox $(INITRAMFS)

