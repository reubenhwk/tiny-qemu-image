
# http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html

all: build/bzImage build/busybox

build:
	mkdir -pv build/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}

build/bzImage: build
	ln -f config/linux.conf linux/.config
	cd linux ; $(MAKE) -j bzImage
	cp linux/arch/x86/boot/bzImage build

build/busybox: build
	ln -f config/busybox.conf busybox/.config
	cd busybox ; $(MAKE) -j
	cp busybox/busybox build/bin/.
	cd build/bin ; ./busybox --install .
