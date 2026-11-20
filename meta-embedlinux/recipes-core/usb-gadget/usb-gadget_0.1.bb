SUMMARY = "USB composite gadget (CDC NCM Ethernet + CDC ACM serial console)"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = " \
    file://usb-gadget \
    file://usb-gadget.service \
    file://99-usb-gadget-serial.rules \
    file://10-usb0.network \
    file://10-mdns.conf \
"

S = "${UNPACKDIR}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "usb-gadget.service"
SYSTEMD_AUTO_ENABLE = "enable"

RDEPENDS:${PN} = " \
    kernel-module-dwc2 \
    kernel-module-libcomposite \
    kernel-module-usb-f-ncm \
    kernel-module-usb-f-acm \
"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/usb-gadget ${D}${sbindir}/usb-gadget

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/usb-gadget.service ${D}${systemd_system_unitdir}/usb-gadget.service

    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${UNPACKDIR}/99-usb-gadget-serial.rules ${D}${sysconfdir}/udev/rules.d/99-usb-gadget-serial.rules

    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${UNPACKDIR}/10-usb0.network ${D}${sysconfdir}/systemd/network/10-usb0.network

    install -d ${D}${sysconfdir}/systemd/resolved.conf.d
    install -m 0644 ${UNPACKDIR}/10-mdns.conf ${D}${sysconfdir}/systemd/resolved.conf.d/10-mdns.conf
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/usb-gadget.service \
    ${sysconfdir}/udev/rules.d/99-usb-gadget-serial.rules \
    ${sysconfdir}/systemd/network/10-usb0.network \
    ${sysconfdir}/systemd/resolved.conf.d/10-mdns.conf \
"
