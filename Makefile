
all: bzImage busybox

bzImage:
	ln -f config/linux.conf linux/.config
	cd linux ; $(MAKE) -j bzImage
	cp linux/arch/x86/boot/bzImage .

busybox:
	ln -f config/busybox.conf busybox/.config
	cd busybox ; $(MAKE) -j
	cp busybox/busybox .
