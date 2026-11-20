IMAGE_FEATURES:append = " ssh-server-dropbear"
IMAGE_INSTALL:append = " hello mcwrapper kernel-module-test"
IMAGE_INSTALL:append:rpi = " rauc usb-gadget"
IMAGE_FSTYPES:append:rpi = " ext4"

RPI_AB_WIC_DEPENDS = ""
RPI_AB_WIC_DEPENDS:rpi = " \
    linux-raspberrypi-fitimage:do_deploy \
    u-boot-default-script:do_deploy \
"
do_image_wic[depends] += "${RPI_AB_WIC_DEPENDS}"

configure_rpi_ab_fstab() {
    install -d ${IMAGE_ROOTFS}/boot ${IMAGE_ROOTFS}/data
    if ! grep -q '^/dev/mmcblk0p1' ${IMAGE_ROOTFS}/etc/fstab; then
        printf '/dev/mmcblk0p1       /boot                vfat       defaults              0  2\n' >> ${IMAGE_ROOTFS}/etc/fstab
    fi
    if ! grep -q '^/dev/mmcblk0p7' ${IMAGE_ROOTFS}/etc/fstab; then
        printf '/dev/mmcblk0p7       /data                ext4       defaults              0  2\n' >> ${IMAGE_ROOTFS}/etc/fstab
    fi
}
ROOTFS_POSTPROCESS_COMMAND:append:rpi = " configure_rpi_ab_fstab;"
do_rootfs[vardeps] += "configure_rpi_ab_fstab"
