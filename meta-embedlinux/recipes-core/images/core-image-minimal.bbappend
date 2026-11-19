IMAGE_INSTALL:append = " hello mcwrapper kernel-module-test"
IMAGE_INSTALL:append:rpi = " libubootenv-bin u-boot-default-env"

RPI_AB_WIC_DEPENDS = ""
RPI_AB_WIC_DEPENDS:rpi = " \
    linux-raspberrypi-fitimage:do_deploy \
    u-boot-default-script:do_deploy \
"
do_image_wic[depends] += "${RPI_AB_WIC_DEPENDS}"

create_data_mountpoint() {
    install -d ${IMAGE_ROOTFS}/data
}
ROOTFS_POSTPROCESS_COMMAND:append:rpi = " create_data_mountpoint;"
