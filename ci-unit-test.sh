#! /bin/bash -x

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

swift/carl-unit-test.sh build/${BUILD_SUBDIR}/swift-${PLATFORM}-${ARCH} swift/test/AVR
