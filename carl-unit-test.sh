#! /bin/bash -sh

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

if [ -z "$1" ]
then
	echo "usage: $0 <path to swift build>"
	exit 1
fi

LLVM_SOURCE_ROOT=realpath(../llvm-project/llvm)
SWIFT_BUILD_DIR=(../)
SWIFT_SOURCE_ROOT=realpath(.)
SWIFT_BUILD_DIR=$1

${LLVM_SOURCE_ROOT}/utils/lit/lit.py -sv \
--param swift_site_config=${SWIFT_BUILD_DIR}/test-macosx-x86_64/lit.site.cfg \
--param swift-version=5 ${SWIFT_SOURCE_ROOT}/test/AVR/runtime_scanner_attributes.swift