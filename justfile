set default-list := true

# Initialize Yocto build environment via bitbake-setup
[group('yocto')]
yocto-init MACHINE="raspberrypi0":
	uv run bitbake-setup init --non-interactive --source-overrides sources-fixed-revisions.json ./yocto.conf.json poky distro/poky-altcfg machine/{{MACHINE}}

# Sync active Yocto setup with changes in yocto.conf.json
[group('yocto')]
yocto-update:
	uv run bitbake-setup update --update-bb-conf=yes --setup-dir bitbake-builds/poky-altcfg-blacksail

# Switch target machine in active Yocto setup (e.g. raspberrypi0, raspberrypi0-wifi, qemuarm64)
[group('yocto')]
yocto-machine MACHINE="raspberrypi0":
	bash -c 'source bitbake-builds/poky-altcfg-blacksail/build/init-build-env && bitbake-config-build enable-fragment machine/{{MACHINE}}'

# Build Yocto target (default: core-image-minimal)
[group('yocto')]
yocto-build *ARGS="core-image-minimal":
	bash -c 'source bitbake-builds/poky-altcfg-blacksail/build/init-build-env && bitbake {{ARGS}}'

# Boot Yocto image in QEMU via runqemu
[group('yocto')]
yocto-sim *ARGS="nographic slirp snapshot":
	bash -c 'source bitbake-builds/poky-altcfg-blacksail/build/init-build-env && runqemu {{ARGS}}'
