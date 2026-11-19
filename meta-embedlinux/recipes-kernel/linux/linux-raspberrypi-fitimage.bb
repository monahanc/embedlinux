SUMMARY = "Linux kernel FIT image for Raspberry Pi"
SECTION = "kernel"
LICENSE = "GPL-2.0-only WITH Linux-syscall-note"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-with-Linux-syscall-note;md5=0bad96c422c41c3a94009dcfe1bff992"

COMPATIBLE_MACHINE = "^rpi$"

inherit kernel-fit-image

UBOOT_ARCH = "${@oe.kernel.map_uboot_arch(d)}"
PKGV = "${@oe.kernel.get_version_file("${STAGING_KERNEL_BUILDDIR}")}"

# Bundle board DTBs into the FIT image (exclude RPi firmware overlay maps and unrelated HAT overlays)
KERNEL_DEVICETREE = "${RPI_KERNEL_DEVICETREE}"
