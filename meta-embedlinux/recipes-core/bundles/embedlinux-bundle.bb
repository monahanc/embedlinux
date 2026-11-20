SUMMARY = "EmbedLinux RAUC OTA update bundle"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit bundle

COMPATIBLE_MACHINE = "^rpi$"

RAUC_BUNDLE_COMPATIBLE = "embedlinux-${MACHINE}"
RAUC_BUNDLE_FORMAT = "verity"
RAUC_BUNDLE_VERSION ?= "1.0.0"
RAUC_BUNDLE_DESCRIPTION = "EmbedLinux A/B OTA bundle (FIT kernel + rootfs)"

RAUC_BUNDLE_SLOTS = "rootfs kernel"

RAUC_SLOT_rootfs = "core-image-minimal"
RAUC_SLOT_rootfs[fstype] = "ext4"
RAUC_SLOT_rootfs[adaptive] = "block-hash-index"

RAUC_SLOT_kernel = "linux-raspberrypi-fitimage"
RAUC_SLOT_kernel[type] = "file"
RAUC_SLOT_kernel[file] = "fitImage"
RAUC_SLOT_kernel[imagetype] = "raw"

# Development signing keys (generate locally via `just rauc-keygen`, or override for CI/HSM)
RAUC_KEY_FILE ?= "${@os.path.normpath('${THISDIR}/../rauc/files/development-1.key.pem')}"
RAUC_CERT_FILE ?= "${@os.path.normpath('${THISDIR}/../rauc/files/development-1.cert.pem')}"
RAUC_KEYRING_FILE ?= "${@os.path.normpath('${THISDIR}/../rauc/files/ca.cert.pem')}"
