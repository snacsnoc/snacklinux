GENISOIMAGE=/usr/bin/genisoimage
MAKE=/usr/bin/make
GIT=/usr/bin/git

NOW=`date +'%d.%m.%y'`

CDIMAGE=snacklinux_i386

GIT_URL=https://github.com/snacsnoc/snacklinux.git

KERNEL_VERSION=4.0

ARCH=x86

.PHONY: all iso kernel docker

all: iso


iso: 
	mkdir -p iso boot/isolinux
	cd _install/; find . -print | cpio -o -H newc --quiet | gzip -6 > ../rootfs.gz 
	wait
	mv rootfs.gz boot/isolinux
	$(GENISOIMAGE) -l -J -R -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 -boot-info-table -o iso/$(CDIMAGE)_$(NOW).iso boot
	
docker:
	mkdir -p docker/
	tar --numeric-owner --xattrs --acls -cvf snacklinux-$(NOW)-docker.tar -C _install/ .
	mv snacklinux-$(NOW)-docker.tar docker/

clean:
	rm -rf iso
	rm -f boot/isolinux/linux*
	rm -f docker

download:
	$(GIT) clone $(GIT_URL)

kernel: 
	#Clone git repo and get .config, then build
	$(GIT) clone $(GIT_URL)
	wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-$(KERNEL_VERSION).tar.xz | tar xvf -
	cd linux-$(KERNEL_VERSION)/	
	cp ../snacklinux/linux-$(KERNEL_VERSION)/.config .
	
	$(MAKE) ARCH=$(ARCH) bzImage
	cp arch/$(ARCH)/boot/bzImage ../boot/isolinux
	cp arch/$(ARCH)/boot/bzImage ../_install/boot 
