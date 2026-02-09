#! /bin/bash -ex

cd swift

utils/build-script --skip-build-benchmarks  --skip-ios --skip-watchos --skip-xros \
  --extra-cmake-options="-DBUILD_SHARED_LIBS=NO,-DSWIFT_SHOULD_BUILD_EMBEDDED_STDLIB_CROSS_COMPILING=YES,-DLLVM_USE_STATIC_ZSTD=TRUE,-DLLVM_ENABLE_ZSTD=NO" \
  --swift-darwin-supported-archs "arm64" \
  --${RELEASE_TYPE_FLAGS} --swift-disable-dead-stripping \
  --bootstrapping=hosttools ${SCCACHE_FLAG} --static-zlib TRUE --static-libxml2 TRUE
  # --sourcekit-lsp --install-all --infer

echo "** COMPLETED SWIFT COMPILER BUILD **"



#  /*
# utils/build-script --skip-build-benchmarks  --skip-ios --skip-watchos --skip-xros \
#   --extra-cmake-options="-DBUILD_SHARED_LIBS=NO,-DSWIFT_SHOULD_BUILD_EMBEDDED_STDLIB_CROSS_COMPILING=YES,-DLLVM_USE_STATIC_ZSTD=TRUE" \
#   --swift-darwin-supported-archs "arm64" \
#   -r --swift-disable-dead-stripping \
#   --bootstrapping=hosttools --sccache --static-zlib --static-libxml2


# Without sccache...


# Known good (use sccache too though)...


# utils/build-script --skip-build-benchmarks  --skip-ios --skip-watchos --skip-xros --install-all --infer --extra-cmake-options="-DBUILD_SHARED_LIBS=NO,-DSWIFT_SHOULD_BUILD_EMBEDDED_STDLIB_CROSS_COMPILING=YES,-DLLVM_USE_STATIC_ZSTD=TRUE" --swift-darwin-supported-archs "arm64" -r --swift-disable-dead-stripping --bootstrapping=hosttools --static-zlib --static-libxml2


# Swiftpm still failing, seems due to llbuild failing, possibly issues with linking libc++ statically/mismatch try...

# -DSWIFT_USE_SYSTEM_LIBCXX=YES 

# Like this...

# utils/build-script --skip-build-benchmarks  --skip-ios --skip-watchos --skip-xros --install-all --infer --extra-cmake-options="-DBUILD_SHARED_LIBS=NO,-DSWIFT_SHOULD_BUILD_EMBEDDED_STDLIB_CROSS_COMPILING=YES,-DLLVM_USE_STATIC_ZSTD=TRUE,-DSWIFT_USE_SYSTEM_LIBCXX=YES" --swift-darwin-supported-archs "arm64" -r --swift-disable-dead-stripping --bootstrapping=hosttools --static-zlib --static-libxml2

# Oops I mean...

# utils/build-script --skip-build-benchmarks  --skip-ios --skip-watchos --skip-xros --install-all --infer --extra-cmake-options="-DBUILD_SHARED_LIBS=NO,-DSWIFT_SHOULD_BUILD_EMBEDDED_STDLIB_CROSS_COMPILING=YES,-DLLVM_USE_STATIC_ZSTD=TRUE,-DSWIFT_USE_SYSTEM_LIBCXX=YES" --swift-darwin-supported-archs "arm64" -r --swift-disable-dead-stripping --bootstrapping=hosttools --static-zlib --static-libxml2 --swiftpm --llbuild --libcxx 

#  */

