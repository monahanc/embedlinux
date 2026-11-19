set default-list := true

export KAS_WORK_DIR := env("KAS_WORK_DIR", justfile_directory() / "kas-work")
kas_config := "kas/base.yml"

# Fetch and check out Yocto layer repositories without building
[group('yocto')]
yocto-checkout:
	mkdir -p "$KAS_WORK_DIR"
	uv run kas-container checkout {{kas_config}}

# Build Yocto target in Docker via kas-container (e.g. just yocto-build qemuarm64)
[group('yocto')]
yocto-build MACHINE="raspberrypi0" TARGET="core-image-minimal" *ARGS="":
	mkdir -p "$KAS_WORK_DIR"
	KAS_MACHINE={{MACHINE}} KAS_TARGET="{{TARGET}}" uv run kas-container build {{ARGS}} {{kas_config}}

# Open an interactive BitBake shell inside the kas container
[group('yocto')]
yocto-shell MACHINE="raspberrypi0":
	mkdir -p "$KAS_WORK_DIR"
	KAS_MACHINE={{MACHINE}} uv run kas-container shell {{kas_config}}

# Boot Yocto image in QEMU inside the kas container via runqemu
[group('yocto')]
yocto-sim MACHINE="qemuarm64" *ARGS="nographic slirp snapshot":
	mkdir -p "$KAS_WORK_DIR"
	KAS_MACHINE={{MACHINE}} uv run kas-container $([ -e /dev/kvm ] && echo --kvm || true) shell {{kas_config}} -c "runqemu {{ARGS}}"

# Update pinned layer revisions in kas/base.lock.yml
[group('yocto')]
yocto-lock:
	mkdir -p "$KAS_WORK_DIR"
	uv run kas-container lock --update {{kas_config}}

# Clean build artifacts (keeps downloads and sstate cache)
[group('yocto')]
yocto-clean:
	mkdir -p "$KAS_WORK_DIR"
	uv run kas-container clean {{kas_config}}
