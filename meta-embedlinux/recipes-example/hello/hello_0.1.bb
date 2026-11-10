SUMMARY = "Simple C++ Hello World application"
DESCRIPTION = "C++ Hello World application built with CMake and installed to /usr/local/bin/hello"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = " \
    file://CMakeLists.txt \
    file://hello.cpp \
"

S = "${UNPACKDIR}"

inherit cmake

EXTRA_OECMAKE = "-DCMAKE_INSTALL_PREFIX=/usr/local"

FILES:${PN} += "/usr/local/bin/hello"
