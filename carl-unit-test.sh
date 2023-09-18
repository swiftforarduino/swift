#! /bin/bash -x

# useful blog: https://medium.com/@mshockwave/using-llvm-lit-out-of-tree-5cddada85a78


SCRIPT_DIR=$(dirname "$0")

function realpath {
    [[ $1 = /* ]] && echo "$1" || echo "$SCRIPT_DIR/${1#./}"
}

if [ -z "$1" ]
then
	echo "usage: $0 <path to swift build> [<specific test>]"
	echo "e.g.: $0 ~/Documents/Code/swift/build/Ninja-ReleaseAssert/swift-macosx-x86_64"
	echo "or: $0 ~/Documents/Code/swift/build/Ninja-ReleaseAssert/swift-macosx-x86_64 test/AVR/attr_interruptHandler.swift"
	echo "Make sure to have the S4A IDE running unless you have a security system bypass."
	exit 1
fi

LLVM_SOURCE_ROOT=$(realpath "../llvm-project/llvm")
SWIFT_BUILD_DIR=../
SWIFT_SOURCE_ROOT=$SCRIPT_DIR
SWIFT_BUILD_DIR=$1

if [ -z "$2" ]
then
	TEST_SUBDIRECTORY=test/AVR
else
	TEST_SUBDIRECTORY=$2
fi

${LLVM_SOURCE_ROOT}/utils/lit/lit.py -v \
--param swift_site_config=${SWIFT_BUILD_DIR}/test-macosx-x86_64/lit.site.cfg \
--param swift-version=5 ${SWIFT_SOURCE_ROOT}/${TEST_SUBDIRECTORY}
