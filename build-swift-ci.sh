#! /bin/bash -ex

if [[ "$1" == "fulldebug" ]]
then
  BUILD_SUBDIR=Ninja-DebugAssert
else
  if [[ "$1" == "debug" ]]
  then
    BUILD_SUBDIR=Ninja-ReleaseAssert+swift-DebugAssert
  else
    BUILD_SUBDIR=Ninja-ReleaseAssert
  fi
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
ninja swift-ide-test
popd

echo "** COMPLETED SWIFT COMPILER BUILD **"
