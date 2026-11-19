# Root partition (roota=mmcblk0p5 / rootb=mmcblk0p6) is appended dynamically by U-Boot.
# panic=10 ensures kernel panics reboot automatically so U-Boot can trigger A/B fallback.
CMDLINE_ROOTFS = "${CMDLINE_ROOT_FSTYPE} rootwait panic=10"
