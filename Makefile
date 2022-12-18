GENISOIMAGE=/usr/bin/genisoimage
MAKE=/usr/bin/make
GIT=/usr/bin/git
STRIP=$(ARCH)-linux-musl-strip
PATCH=/usr/bin/patch

NOW=`date +'%d.%m.%y'`


# Set default architecture
ifndef ARCH	
	ARCH=i486
endif


ifndef JOBS
	JOBS=-j8
endif

CDIMAGE=snacklinux_$(ARCH)


GIT_URL=https://github.com/snacsnoc/snacklinux.git

PWD=$(shell pwd)

ROOTFS_PATH=/opt/snacklinux_rootfs

.PHONY: all iso kernel docker musl busybox bash binutils syslinux

all: iso

install: musl-install busybox-install bash-install strip-fs
	
system: musl busybox bash	

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

# Delete build files
clean:
	rm -rf iso
	rm -f boot/isolinux/linux*
	rm -f docker	
	# Clean package build dirs
	cd linux && make clean
	cd musl && make clean
	cd busybox && make clean
	cd bash && make distclean

kernel: 
ifeq ($(ARCH), aarch64)
	cp ./configs/linux/.config-arm64 linux/.config
	cd linux/	; \
	$(MAKE) ARCH=arm64 CROSS_COMPILE=$(ARCH)-linux-musl- $(JOBS) Image 

else ifeq ($(ARCH), x86_64)
	cp ./configs/linux/.config-x86_64 linux/.config
	cd linux/	; \
	$(MAKE) ARCH=x86_64 CROSS_COMPILE=$(ARCH)-musl-linux- $(JOBS) bzImage

else ifeq ($(ARCH), i486)	
	cp ./configs/linux/.config-x86 linux/.config
	cd linux/	; \
	$(MAKE) ARCH=x86 CROSS_COMPILE=$(ARCH)-linux-musl- $(JOBS) bzImage
endif
	
# Build musl
#
# Upstream documentation: https://musl.libc.org/doc/1.1.24/manual.html under "Build Options"
#
# Must be clean directory to run make (go figure)
musl:
	cd musl/ ; \
	CC=$(ARCH)-linux-musl-gcc ./configure --prefix=/ ; \
	$(MAKE) $(JOBS) ; \

busybox:
ifeq ($(ARCH), aarch64)
	@cp ./configs/busybox/.config-arm64 busybox/.config
else ifeq ($(ARCH), x86_64)

	@cp ./configs/busybox/.config-x86_64 busybox/.config ; \
	@cp ./patches/busybox/ifplugd.patch busybox/ ; \
	cd busybox/	; \
	$(PATCH) -p1 -i ifplugd.patch
else ifeq ($(ARCH), i486)
	@cp ./configs/busybox/.config-x86 busybox/.config
endif	
	cd busybox/	; \
	$(MAKE) $(JOBS) ; \

bash:
	cd bash/ ; \
	CROSS_COMPILE=$(ARCH)-linux-musl- ; \
	./configure --enable-largefile --prefix=/ --without-bash-malloc --enable-net-redirections --host=$(ARCH)-linux-musl --target=$(ARCH)-linux-musl --disable-nls 	; \
	$(MAKE) $(JOBS) ; \

binutils:
	cd binutils/ ; \
	LDFLAGS="-Wl,-static"  \
	CFLAGS="-D_GNU_SOURCE -D_LARGEFILE64_SOURCE -static -s"  \
	./configure --target=$(ARCH)-musl-linux  --host=$(ARCH)-musl-linux --disable-shared --disable-multilib --disable-nls  --prefix=/usr --with-sysroot=/	; \
	$(MAKE) $(JOBS) ; \

syslinux:
	# Check if this is still needed (probably not)
	@cp ./patches/syslinux/0014_fix_ftbfs_no_dynamic_linker.patch syslinux/
	$(PATCH) -p1 -i 0014_fix_ftbfs_no_dynamic_linker.patch ; \
	cd syslinux/ ; \
	$(MAKE) $(JOBS) ; \

kernel-install: kernel
ifeq ($(ARCH), aarch64)
	cd linux ; \
	@cp ./arch/arm64/boot/Image ../boot/isolinux ; \
	@cp ./arch/arm64/boot/Image $(ROOTFS_PATH)/boot 
else ifeq ($(ARCH), i486)	
	cd linux/	; \
	cp arch/x86/boot/bzImage ../boot/isolinux ; \
	cp arch/x86/boot/bzImage $(ROOTFS_PATH)/boot 
endif

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
	find $(ROOTFS_PATH) -type f | xargs file 2>/dev/null | grep "current ar archive" | cut -f 1 -d : | xargs $(STRIP) --strip-debug	   2>/dev/null || true
	#@$(STRIP) $(ROOTFS_PATH)/bin/bash 
