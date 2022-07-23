#! /bin/bash -x

if [[ "$1" == "debug" ]]
then
  BUILD_SUBDIR=Ninja-ReleaseAssert+swift-DebugAssert
else
  BUILD_SUBDIR=Ninja-ReleaseAssert
fi

PLATFORM=macosx
ARCH=x86_64

cd build
cd ${BUILD_SUBDIR}
pushd cmark-${PLATFORM}-${ARCH}
ninja
popd
pushd llvm-${PLATFORM}-${ARCH}
ninja
popd
pushd swift-${PLATFORM}-${ARCH}
ninja swift
popd

echo "** COMPLETED SWIFT COMPILER BUILD **"
