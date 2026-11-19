SUMMARY = "A/B boot confirmation, slot switching, and watchdog config"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = " \
    file://ab-boot-confirm \
    file://ab-boot-confirm.service \
    file://ab-switch \
    file://10-watchdog.conf \
"

S = "${UNPACKDIR}"

inherit systemd allarch

SYSTEMD_SERVICE:${PN} = "ab-boot-confirm.service"
SYSTEMD_AUTO_ENABLE = "enable"

RDEPENDS:${PN} = "libubootenv-bin u-boot-default-env"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/ab-boot-confirm ${D}${sbindir}/ab-boot-confirm
    install -m 0755 ${UNPACKDIR}/ab-switch ${D}${sbindir}/ab-switch

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/ab-boot-confirm.service ${D}${systemd_system_unitdir}/ab-boot-confirm.service

    install -d ${D}${sysconfdir}/systemd/system.conf.d
    install -m 0644 ${UNPACKDIR}/10-watchdog.conf ${D}${sysconfdir}/systemd/system.conf.d/10-watchdog.conf
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/ab-boot-confirm.service \
    ${sysconfdir}/systemd/system.conf.d/10-watchdog.conf \
"
