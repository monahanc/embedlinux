FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:rpi = " \
    file://10-mounts.conf \
    file://10-watchdog.conf \
"

RDEPENDS:${PN}:append:rpi = " \
    libubootenv-bin \
    u-boot-default-env \
    kernel-module-dm-mod \
    kernel-module-dm-verity \
    kernel-module-squashfs \
    kernel-module-nbd \
"

do_install:append:rpi() {
    # Ensure /boot (uboot.env) and /data (rauc.status) are mounted before RAUC runs
    install -d ${D}${systemd_system_unitdir}/rauc.service.d
    install -m 0644 ${UNPACKDIR}/10-mounts.conf ${D}${systemd_system_unitdir}/rauc.service.d/10-mounts.conf

    install -d ${D}${systemd_system_unitdir}/rauc-mark-good.service.d
    install -m 0644 ${UNPACKDIR}/10-mounts.conf ${D}${systemd_system_unitdir}/rauc-mark-good.service.d/10-mounts.conf

    # Keep systemd petting the BCM2835 hardware watchdog armed by U-Boot
    install -d ${D}${sysconfdir}/systemd/system.conf.d
    install -m 0644 ${UNPACKDIR}/10-watchdog.conf ${D}${sysconfdir}/systemd/system.conf.d/10-watchdog.conf
}

FILES:${PN}-service:append:rpi = " ${systemd_system_unitdir}/rauc.service.d/10-mounts.conf"
FILES:${PN}-mark-good:append:rpi = " ${systemd_system_unitdir}/rauc-mark-good.service.d/10-mounts.conf"
FILES:${PN}:append:rpi = " ${sysconfdir}/systemd/system.conf.d/10-watchdog.conf"
