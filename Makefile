GENISOIMAGE=/usr/bin/genisoimage
MAKE=/usr/bin/make
GIT=/usr/bin/git

NOW=`date +'%d.%m.%y'`

CDIMAGE=snacklinux_i386

GIT_URL=git@github.com:snacsnoc/snacklinux.git

KERNEL_VERSION=3.8.2
KERNEL_CANONICAL=38

ARCH=x86

.PHONY: all iso kernel 

all: iso


iso: 
	mkdir -p iso cdrom images
	dd if=/dev/zero of=images/initrd.img bs=1k count=128000
	/sbin/mke2fs -t ext3 -F -v -m0 images/initrd.img
	mount -o loop images/initrd.img ./cdrom
	chmod 4755 ./_install/bin/busybox
	cp -av _install/* ./cdrom/.
	umount ./cdrom
	gzip -9 < images/initrd.img > images/initrd.bin
	cp images/initrd.bin boot/isolinux/initrd.bin 

	$(GENISOIMAGE) -R -b isolinux/isolinux.bin -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 -boot-info-table -o iso/$(CDIMAGE)_$(NOW).iso boot

clean:
	rm -rf iso
	rm -rf cdrom
	rm -f boot/isolinux/linux*


download:
	$(GIT) clone $(GIT_URL)

kernel: 
	#Clone git repo and get .config, then build
	$(GIT) clone $(GIT_URL)
	wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-$(KERNEL_VERSION).tar.xz | tar xvf -
	cd linux-$(KERNEL_VERSION)/	
	cp ../snacklinux/linux-$(KERNEL_VERSION)/.config .
	
	$(MAKE) ARCH=$(ARCH) bzImage
	cp arch/$(ARCH)/boot/bzImage ../staging_iso_image/boot/isolinux/linux$(KERNEL_CANONICAL)
	
