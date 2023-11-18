GENISOIMAGE=/usr/bin/genisoimage
MAKE=/usr/bin/make
GIT=/usr/bin/git
STRIP=$(TARGET)-linux-musl-strip
PATCH=/usr/bin/patch

NOW=`date +'%d.%m.%y'`


# Set default architecture
ifndef TARGET	
	TARGET=i486
endif


ifndef JOBS
	JOBS=8
endif

CDIMAGE=snacklinux_$(TARGET)


GIT_URL=https://github.com/snacsnoc/snacklinux.git

PWD=$(shell pwd)

# Set root install path
ifndef ROOTFS_PATH
	ROOTFS_PATH=/opt/snacklinux_rootfs
endif



.PHONY: all iso kernel docker musl busybox bash binutils syslinux python openssl

all: iso

install: kernel-install musl-install busybox-install bash-install strip-fs 
	
system: musl busybox bash	

# Define a common target for shared steps
common_iso_steps:
	@mkdir -p iso boot/isolinux
	@cp ./configs/syslinux/isolinux.cfg boot/isolinux 
	@cp ./configs/syslinux/menu.txt boot/isolinux
	@cp ./syslinux/bios/core/isolinux.bin boot/isolinux
	@cp ./syslinux/bios/com32/elflink/ldlinux/ldlinux.c32 boot/isolinux

iso: common_iso_steps
	# Don't include the kernel in the root filesystem
	cd $(ROOTFS_PATH)/; find . -print | grep -v boot/bzImage | cpio -o -H newc --quiet | gzip > $(PWD)/rootfs.gz 
	wait
	mv rootfs.gz boot/isolinux
	$(GENISOIMAGE) -l -J -R -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 -boot-info-table -o iso/$(CDIMAGE)_$(NOW).iso boot

iso-with-kernel: common_iso_steps
	# If we're making the ISO with kernel, include the kernel in the root filesystem
	cd $(ROOTFS_PATH)/; find . -print | cpio -o -H newc --quiet | gzip > $(PWD)/rootfs.gz 
	wait
	mv rootfs.gz boot/isolinux
	$(GENISOIMAGE) -l -J -R -input-charset utf-8 -b isolinux/isolinux.bin -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 -boot-info-table -o iso/$(CDIMAGE)_$(NOW)-inc-kernel.iso boot

docker:
	mkdir -p docker/
	tar --numeric-owner --xattrs --acls -cvf snacklinux-$(NOW)-docker.tar -C $(ROOTFS_PATH)/ .
	mv snacklinux-$(NOW)-docker.tar docker/

# Delete build files
clean:
	rm -rf iso
	rm -f boot/isolinux/linux*
	rm -rf docker	
	# Clean package build dirs
	@cd linux && make clean
	@cd musl && make clean
	@cd busybox && make clean
	@cd bash && make distclean
	@cd python && make distclean
	echo "Clean ok"

kernel: 
ifeq ($(TARGET), aarch64)
	cp ./configs/linux/.config-arm64 linux/.config
	cd linux/	; \
	$(MAKE) ARCH=arm64 CROSS_COMPILE=$(TARGET)-linux-musl- -j$(JOBS) Image 

else ifeq ($(TARGET), x86_64)
	cp ./configs/linux/.config-x86_64 linux/.config
	cd linux/	; \
	$(MAKE) ARCH=x86_64 CROSS_COMPILE=$(TARGET)-linux-musl- -j$(JOBS) bzImage

else ifeq ($(TARGET), i486)	
	cp ./configs/linux/.config-x86 linux/.config
	cd linux/	; \
	$(MAKE) ARCH=x86 CROSS_COMPILE=$(TARGET)-linux-musl- -j$(JOBS) bzImage
endif
	
# Build musl
#
# Upstream documentation: https://musl.libc.org/doc/1.1.24/manual.html under "Build Options"
#
# Must be clean directory to run make (go figure)
musl:
ifeq ($(TARGET), aarch64)
	cd musl/ ; \
	CC=$(TARGET)-linux-musl-gcc ./configure --prefix=/ ; \
	$(MAKE) -j$(JOBS) 
else ifeq ($(TARGET), i486)
	cd musl/ ; \
	CC=$(TARGET)-linux-musl-gcc ./configure --prefix=/ ; \
	$(MAKE) -j$(JOBS) 
endif

busybox:
ifeq ($(TARGET), aarch64)
	@cp ./configs/busybox/.config-arm64 busybox/.config
else ifeq ($(TARGET), x86_64)
	@cp ./configs/busybox/.config-x86_64 busybox/.config ; \
	@cp ./patches/busybox/ifplugd.patch busybox/ ; \
	cd busybox/	; \
	$(PATCH) -p1 -i ifplugd.patch
else ifeq ($(TARGET), i486)
	@cp ./configs/busybox/.config-x86 busybox/.config
endif	
	cd busybox/	; \
	$(MAKE) -j$(JOBS) ; \

bash:
	cd bash/ ; \
	CROSS_COMPILE=$(TARGET)-linux-musl-  \
	./configure --enable-largefile --prefix=/ --without-bash-malloc --enable-net-redirections --host=$(TARGET)-linux-musl --target=$(TARGET)-linux-musl --disable-nls 	; \
	$(MAKE) -j$(JOBS) ; \

binutils:
	cd binutils/ ; \
	LDFLAGS="-Wl,-static"  \
	CFLAGS="-D_GNU_SOURCE -D_LARGEFILE64_SOURCE -static -s"  \
	./configure --target=$(TARGET)-musl-linux  --host=$(TARGET)-musl-linux --disable-shared --disable-multilib --disable-nls  --prefix=/usr --with-sysroot=/	; \
	$(MAKE) -j$(JOBS) ; \

syslinux:
	# Check if this is still needed (probably not)
	@cp ./patches/syslinux/0014_fix_ftbfs_no_dynamic_linker.patch syslinux/
	$(PATCH) -p1 -i 0014_fix_ftbfs_no_dynamic_linker.patch ; \
	cd syslinux/ ; \
	$(MAKE) -j$(JOBS) ; \

python:
	cd python/ ; \
	CROSS_COMPILE=$(TARGET)-linux-musl-  \
	CC=$(TARGET)-linux-musl-gcc \
	./configure --build=$(TARGET)-linux-musl  --host=$(TARGET)-linux-musl --with-openssl=$(ROOTFS_PATH) ; \
	CROSS_COMPILE=$(TARGET)-linux-musl- \
	CC=$(TARGET)-linux-musl-gcc \
	$(MAKE) -j$(JOBS) BUILDARCH=$(TARGET)-linux-musl- HOSTARCH=$(TARGET)-linux-musl- CROSS_COMPILE_TARGET=yes; \

python-static:
	cd python/ ; \
	sed '1s/^/*static*\n/' Modules/Setup > Modules/Setup ; \
	CROSS_COMPILE=$(TARGET)-linux-musl-  \
	LDFLAGS="-static -static-libgcc" CPPFLAGS="-static" \
	CC=$(TARGET)-linux-musl-gcc \
	./configure --host=$(TARGET)-linux-musl --build=$(TARGET)-linux-musl --with-openssl-rpath=auto ; \
	sed -i '/LINKFORSHARED=/c\LINKFORSHARED=' Makefile ; \
	CROSS_COMPILE=$(TARGET)-linux-musl- \
	$(MAKE) -j$(JOBS) ; \

openssl:
ifeq ($(TARGET), aarch64)
	./Configure --prefix=$(ROOTFS_PATH)/usr/ shared no-ssl3-method enable-ec_nistp_64_gcc_128 linux-aarch64 
else ifeq ($(TARGET), x86_64)
	./Configure --prefix=$(ROOTFS_PATH)/usr/ shared no-ssl3-method enable-ec_nistp_64_gcc_128 linux-x86_64 
else ifeq ($(TARGET), i486)	
	cd openssl/ ; \
	CC=$(TARGET)-linux-musl-gcc \
	./Configure --prefix=$(ROOTFS_PATH)/usr/ shared linux-elf ; \
	make -j$(JOBS) ; \
	
endif


openssl-install:
	cd openssl/ ; \
	make install ; \

python-install:
	#LDFLAGS="-static -static-libgcc" CPPFLAGS="-static"
	cd python/ ; \
	CROSS_COMPILE=$(TARGET)-linux-musl- \
	$(MAKE) -j$(JOBS) install CROSS_COMPILE_TARGET=yes  prefix=$(ROOTFS_PATH); \


kernel-install: kernel
ifeq ($(TARGET), aarch64)
	cd linux ; \
	@cp ./arch/arm64/boot/Image ../boot/isolinux ; \
	@cp ./arch/arm64/boot/Image $(ROOTFS_PATH)/boot/Image 
else ifeq ($(TARGET), i486)	
	@mkdir -p boot/isolinux
	@mkdir -p $(ROOTFS_PATH)/boot
	cd linux/	; \
	cp arch/x86/boot/bzImage ../boot/isolinux ; \
	cp arch/x86/boot/bzImage $(ROOTFS_PATH)/boot/bzImage 
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
	rm -f $(ROOTFS_PATH)/bin/bashbug

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
