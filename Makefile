GENISOIMAGE=/usr/bin/genisoimage
MAKE=/usr/bin/make
GIT=/usr/bin/git

NOW=`date +'%d.%m.%y'`

CDIMAGE=snacklinux_i386

GIT_URL=git@bitbucket.org:snacsnoc/snacklinux.git

KERNEL_VERSION=3.13

ARCH=x86

.PHONY: all iso kernel 

all: iso


iso: 
	mkdir -p iso boot/isolinux
	cd _install/; find . -print | cpio -o -H newc --quiet | gzip -2 > ../rootfs.gz 
	wait
	mv rootfs.gz boot/isolinux
	$(GENISOIMAGE) -l -J -R -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 -boot-info-table -o iso/$(CDIMAGE)_$(NOW).iso boot

clean:
	rm -rf iso
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
	cp arch/$(ARCH)/boot/bzImage ../boot/isolinux
	cp arch/$(ARCH)/boot/bzImage ../_install/boot 
