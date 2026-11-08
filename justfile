set default-list := true

export CROSS_COMPILE := "aarch64-none-linux-gnu-"

setup:
	git submodule update --init --recursive

uboot-config:
	ARCH=arm64 make -C vendor/u-boot qemu_arm64_defconfig

uboot-build:
	make -C vendor/u-boot -j$(nproc)

uboot: uboot-config uboot-build

linux-config:
	ARCH=arm64 make -C vendor/linux defconfig

linux-build:
	ARCH=arm64 make -C vendor/linux -j$(nproc)

linux: linux-config linux-build

busybox-config:
	make -C vendor/busybox_mirror defconfig
	sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' vendor/busybox_mirror/.config

busybox-build:
	make -C vendor/busybox_mirror -j$(nproc)
	make -C vendor/busybox_mirror install

initramfs:
	mkdir -p initramfs/{bin,sbin,etc,proc,sys,dev,usr/bin,usr/sbin}
	cp -t initramfs -a vendor/busybox_mirror/_install/*
	cd initramfs && find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz

sim-linux:
	qemu-system-aarch64 -M virt -cpu cortex-a76 -nographic -smp 1 -kernel vendor/linux/arch/arm64/boot/Image -append "console=ttyAMA0" -m 2048 -initrd initramfs.cpio.gz

sim:
	qemu-system-aarch64 -M virt -cpu cortex-a76 -bios vendor/u-boot/u-boot.bin -m 2G -nographic