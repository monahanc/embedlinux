FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FIT_BOOT_CONFIG ??= ""

do_compile() {
    sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
        -e 's/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/' \
        -e 's/@@BOOT_MEDIA@@/${BOOT_MEDIA}/' \
        -e 's/@@FIT_BOOT_CONFIG@@/${FIT_BOOT_CONFIG}/' \
        "${UNPACKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
    mkimage -A ${@oe.kernel.map_uboot_arch(d)} -T script -C none -n "Boot script" -d "${WORKDIR}/boot.cmd" boot.scr
}
