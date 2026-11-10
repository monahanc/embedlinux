SUMMARY = "Process wrapper for sending stop commands to a child server on SIGINT/SIGTERM"
HOMEPAGE = "https://github.com/monahanc/mcwrapper"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"

SRC_URI = " \
    git://github.com/monahanc/mcwrapper.git;protocol=https;branch=master \
    file://0001-Add-cmake_minimum_required.patch \
"
SRCREV = "bfee9f24b38e091287fe020f18936c8be9cc819c"
PV = "0.1+git"

inherit cmake
