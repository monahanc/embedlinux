set default-list := true

export CROSS_COMPILE := "aarch64-none-linux-gnu-"

# Initialize and update git submodules
[group('setup')]
setup:
	git submodule update --init --recursive

# Configure U-Boot (qemu_arm64_defconfig)
[group('uboot')]
uboot-config:
	ARCH=arm64 make -C vendor/u-boot qemu_arm64_defconfig

# Build U-Boot
[group('uboot')]
uboot-build:
	make -C vendor/u-boot -j$(nproc)

# Configure and build U-Boot
[group('uboot')]
uboot: uboot-config uboot-build

# Boot U-Boot in QEMU
[group('uboot')]
uboot-sim:
	qemu-system-aarch64 -M virt -cpu cortex-a76 -bios vendor/u-boot/u-boot.bin -m 2G -nographic

# Configure Linux kernel (defconfig)
[group('linux')]
linux-config:
	ARCH=arm64 make -C vendor/linux defconfig

# Build Linux kernel
[group('linux')]
linux-build:
	ARCH=arm64 make -C vendor/linux -j$(nproc)

# Configure and build Linux kernel
[group('linux')]
linux: linux-config linux-build

# Boot Linux kernel + initramfs in QEMU
[group('linux')]
linux-sim:
	qemu-system-aarch64 -M virt -cpu cortex-a76 -nographic -smp 1 -kernel vendor/linux/arch/arm64/boot/Image -append "console=ttyAMA0" -m 2048 -initrd initramfs.cpio.gz

# Configure BusyBox (static build)
[group('busybox')]
busybox-config:
	make -C vendor/busybox_mirror defconfig
	sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' vendor/busybox_mirror/.config

# Build and install BusyBox
[group('busybox')]
busybox-build:
	make -C vendor/busybox_mirror -j$(nproc)
	make -C vendor/busybox_mirror install

# Configure and build BusyBox
[group('busybox')]
busybox: busybox-config busybox-build

# Build out-of-tree kernel modules
[group('rootfs')]
modules-build:
	ARCH=arm64 make -C modules

# Package BusyBox and kernel modules into initramfs.cpio.gz
[group('rootfs')]
initramfs-build:
	mkdir -p initramfs/{bin,sbin,etc,proc,sys,dev,usr/bin,usr/sbin,usr/modules}
	cp -t initramfs -a vendor/busybox_mirror/_install/*
	cp -t initramfs/usr/modules modules/*.ko
	cd initramfs && find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz

# Initialize Yocto build environment via bitbake-setup
[group('yocto')]
yocto-init:
	uv run bitbake-setup init --non-interactive --source-overrides sources-fixed-revisions.json ./yocto.conf.json poky distro/poky-altcfg machine/qemuarm64

# Build Yocto target (default: core-image-minimal)
[group('yocto')]
yocto-build *ARGS="core-image-minimal":
	bash -c 'source bitbake-builds/poky-altcfg-blacksail/build/init-build-env && bitbake {{ARGS}}'

# Boot Yocto image in QEMU via runqemu
[group('yocto')]
yocto-sim *ARGS="nographic slirp snapshot":
	bash -c 'source bitbake-builds/poky-altcfg-blacksail/build/init-build-env && runqemu {{ARGS}}'
