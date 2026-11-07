set default-list := true

export CROSS_COMPILE := "aarch64-none-linux-gnu-"

setup:
	git submodule update --init --recursive

uboot-config:
	ARCH=arm64 make -C vendor/u-boot qemu_arm64_defconfig

uboot-build:
	make -C vendor/u-boot -j

uboot: uboot-config uboot-build

sim:
	qemu-system-aarch64 -M virt -cpu cortex-a76 -bios vendor/u-boot/u-boot.bin -m 2G -nographic