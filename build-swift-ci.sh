#! /bin/bash -ex

PLATFORM=macosx
ARCH=x86_64

cd swift

utils/build-script --skip-build-benchmarks \
  --extra-cmake-options="-DBUILD_SHARED_LIBS=NO,-DSWIFT_SHOULD_BUILD_EMBEDDED_STDLIB_CROSS_COMPILING=YES" \
  --swift-darwin-supported-archs "x86_64;arm64" \
  --${RELEASE_TYPE_FLAGS} --swift-disable-dead-stripping \
  --bootstrapping=hosttools --sccache

echo "** COMPLETED SWIFT COMPILER BUILD **"
