
all: bzImage

bzImage:
	ln -f tiny-kernel-config linux/.config
	cd linux ; $(MAKE) -j bzImage
	cp linux/arch/x86/boot/bzImage .
