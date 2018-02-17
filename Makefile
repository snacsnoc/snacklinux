GENISOIMAGE=/usr/bin/genisoimage
MAKE=/usr/bin/make
GIT=/usr/bin/git
STRIP=/usr/bin/strip
PATCH=/usr/bin/patch

NOW=`date +'%d.%m.%y'`

CDIMAGE=snacklinux_x86_64

GIT_URL=https://github.com/snacsnoc/snacklinux.git

ARCH=x86_64

MAKEFLAGS=-j8

PWD=$(shell pwd)

ROOTFS_PATH=/opt/snacklinux_rootfs


.PHONY: all iso kernel docker musl busybox bash binutils syslinux

all: iso

install: musl-install busybox-install bash-install strip-fs
	
	

iso: 
	@mkdir -p iso boot/isolinux
	@cp ./configs/syslinux/isolinux.cfg boot/isolinux 
	@cp ./configs/syslinux/menu.txt boot/isolinux 
	cd $(ROOTFS_PATH)/; find . -print | cpio -o -H newc --quiet | gzip -7 > $(PWD)/rootfs.gz 
	wait
	mv rootfs.gz boot/isolinux
	$(GENISOIMAGE) -l -J -R -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 -boot-info-table -o iso/$(CDIMAGE)_$(NOW).iso boot
	
docker:
	mkdir -p docker/
	tar --numeric-owner --xattrs --acls -cvf snacklinux-$(NOW)-docker.tar -C $(ROOTFS_PATH)/ .
	mv snacklinux-$(NOW)-docker.tar docker/

clean:
	rm -rf iso
	rm -f boot/isolinux/linux*
	rm -f docker

kernel: 
	cp ./configs/linux/.config linux/
	cd linux/	; \
	$(MAKE) ARCH=$(ARCH) -j$(MAKEFLAGS) bzImage

musl:
	cd musl/ ; \
	CROSS_COMPILE=$(ARCH)-musl-linux- ./configure --prefix=/ ; \
	$(MAKE) -j$(MAKEFLAGS) ; \

busybox:
	@cp ./configs/busybox/.config busybox/ 
	@cp ./patches/busybox/ifplugd.patch busybox/
	cd busybox/	; \
	$(PATCH) -p1 -i ifplugd.patch ; \
	$(MAKE) -j$(MAKEFLAGS) ; \

bash:
	cd bash/ ; \
	CROSS_COMPILE=$(ARCH)-linux-musl- ./configure --enable-static-link --enable-largefile --prefix=/ --without-bash-malloc --enable-net-redirections --host=$(ARCH)-linux-musl --target=$(ARCH)-linux-musl --disable-nls -C	; \
	$(MAKE) -j$(MAKEFLAGS) ; \

binutils:
	cd binutils/ ; \
	LDFLAGS="-Wl,-static"  \
	CFLAGS="-D_GNU_SOURCE -D_LARGEFILE64_SOURCE -static -s"  \
	./configure --target=$(ARCH)-musl-linux  --host=$(ARCH)-musl-linux --disable-shared --disable-multilib --disable-nls  --prefix=/usr --with-sysroot=/	; \
	$(MAKE) -j$(MAKEFLAGS) ; \

syslinux:
	@cp ./patches/syslinux/0014_fix_ftbfs_no_dynamic_linker.patch syslinux/
	$(PATCH) -p1 -i 0014_fix_ftbfs_no_dynamic_linker.patch ; \
	cd syslinux/ ; \
	$(MAKE) -j$(MAKEFLAGS) ; \

kernel-install: kernel
	cd linux/	; \
	cp arch/$(ARCH)/boot/bzImage ../boot/isolinux ; \
	cp arch/$(ARCH)/boot/bzImage $(ROOTFS_PATH)/boot 

musl-install: musl
	cd musl/ ; \
	$(MAKE) DESTDIR=$(ROOTFS_PATH) install

busybox-install: busybox
	cd busybox/	; \
	$(MAKE) CONFIG_PREFIX=$(ROOTFS_PATH) install
	cd $(ROOTFS_PATH) ; \
	ln -s bin/busybox init ; \
	rm linuxrc

bash-install: bash		
	cd bash/ ; \
	$(MAKE) DESTDIR=$(ROOTFS_PATH) install
	@$(STRIP) $(ROOTFS_PATH)/bin/bash 

binutils-install: binutils
	cd binutils/ ; \
	$(MAKE) DESTDIR=$(ROOTFS_PATH) install	

syslinux-install:
	mkdir -p boot/isolinux
	cd syslinux/ ; \
	cp bios/core/isolinux.bin ../boot/isolinux ; \
	cp bios/com32/elflink/ldlinux/ldlinux.c32 ../boot/isolinux

strip-fs:
	find $(ROOTFS_PATH) -type f | xargs file 2>/dev/null | grep "LSB executable"     | cut -f 1 -d : | xargs $(STRIP) --strip-all      2>/dev/null || true
	find $(ROOTFS_PATH) -type f | xargs file 2>/dev/null | grep "shared object"      | cut -f 1 -d : | xargs $(STRIP) --strip-unneeded 2>/dev/null || true
	find $(ROOTFS_PATH) -type f | xargs file 2>/dev/null | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) --strip-debug
