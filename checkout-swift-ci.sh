#! /usr/bin/arch -arch x86_64 /bin/bash -ex

# PATH=$PATH:/Applications/CMake.app/Contents/bin

# # iota uSwift stdlib/runtime repository
# USWIFT_RUNTIME_SUB_PATH=uSwift/Runtime
# USWIFT_RUNTIME_URL=git@github.com:swiftforarduino/AVR2.git
# USWIFT_RUNTIME_BRANCH=main
# USWIFT_RUNTIME_LOCAL_DIR=AVR2

# # setup uSwift - not sure this is used any more on this branch?
# rm -rf $USWIFT_RUNTIME_LOCAL_DIR
# git clone --depth=1 -b $USWIFT_RUNTIME_BRANCH $USWIFT_RUNTIME_URL $USWIFT_RUNTIME_LOCAL_DIR
# rm -f swift/uSwiftRuntime
# ln -s $USWIFT_RUNTIME_LOCAL_DIR/$USWIFT_RUNTIME_SUB_PATH swift/uSwiftRuntime

cd swift

# if [[ -d ../swift-driver ]]
# then
#   pushd ../swift-driver
#   git restore .
#   git clean -f .
#   popd
# fi

# utils/update-checkout --clone-with-ssh --clone-depth 1 --skip-repository swift

# Created by ChatGPT so it might be guff...

echo "tied to the 6.3 branches ** CORRECT IN FUTURE IF NEEDED **"

utils/update-checkout \
  --scheme release/6.3 \
  --clone \
  --skip-history \
  --skip-repository swift \
  --skip-repository swift-log \
  --skip-repository swift-async-algorithms \
  --skip-repository swift-corelibs-xctest \
  --skip-repository swift-stress-tester \
  --skip-repository swift-integration-tests \
  --skip-repository swift-corelibs-foundation \
  --skip-repository swift-foundation-icu \
  --skip-repository swift-corelibs-libdispatch \
  --skip-repository swift-foundation \
  --skip-repository swift-xcode-playground-support \
  --skip-repository swift-llvm-bindings \
  --skip-repository swift-sdk-generator \
  --skip-repository swift-nio \
  --skip-repository wasi-libc \
  --skip-repository wasmkit

# we are now going to attempt to build zlib, libxml2, curl and cmake too
# they shouldn't take too long, and it should remove the dependency on
# cmake being installed on the machine
  # --skip-repository zlib \
  # --skip-repository libxml2 \
  # --skip-repository curl \
  # --skip-repository cmake \



# seems to be needed by swift-driver
# swift-argument-parser
# swift-tools-support-core

# needed by the swift regex...
# swift-experimental-string-processing

# required to build toolchains...
# swift-installer-scripts

# needed by swiftpm
# swift-crypto
# swift-certificates
# swift-collections
# swift-toolchain-sqlite
# swift-system
# llbuild
# swift-build
# swift-asn (transitive)

# needed by sourcekit-lsp
# indexstore-db
# swift-lmdb (transitive)

cp swift-driver-patch2.txt ../swift-driver

pushd ../swift-driver
patch < swift-driver-patch2.txt
popd



echo "** COMPLETED SWIFT CHECKOUT SOURCES **"

# if [[ $2 == andbuild ]]
# then
#   ./build-swift-ci.sh $1
# fi
