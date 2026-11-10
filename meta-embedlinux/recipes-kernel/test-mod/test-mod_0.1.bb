SUMMARY = "Sus out-of-tree Linux kernel module"
DESCRIPTION = "${SUMMARY}"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI = " \
    file://Makefile \
    file://test.c \
"

S = "${UNPACKDIR}"

# module.bbclass automatically prefixes module packages with "kernel-module-"
RPROVIDES:${PN} += "kernel-module-test"
