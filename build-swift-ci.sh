#! /bin/bash -ex

cd swift

utils/build-script --skip-build-benchmarks  --skip-ios --skip-watchos --skip-xros \
  --extra-cmake-options="-DBUILD_SHARED_LIBS=NO,-DSWIFT_SHOULD_BUILD_EMBEDDED_STDLIB_CROSS_COMPILING=YES,-DLLVM_ENABLE_ZSTD=NO" \
  --swift-darwin-supported-archs "arm64" \
  --${RELEASE_TYPE_FLAGS} --swift-disable-dead-stripping \
  --bootstrapping=hosttools ${SCCACHE_FLAG} --static-zlib TRUE --static-libxml2 TRUE

echo "** COMPLETED SWIFT COMPILER BUILD **"
