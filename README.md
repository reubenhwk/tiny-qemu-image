
This builds a tiny linux kernel (bzImage) and initramfs.  It
should boot in less than 1 second.

Most of this comes from the following howto guide...

    http://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html

After running 'make', you can run the results with this command...

    qemu-system-x86_64 \
        -kernel bzImage \
        -initrd initramfs-busybox-x86.cpio.gz \
        -nographic \
        -append "console=ttyS0"

If/when you build an ISO, boot it like so...

    qemu-system-x86_64 -boot d -cdrom image.iso -nographic -m 128

Enjoy! :D
