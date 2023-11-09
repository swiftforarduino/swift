#! /usr/bin/arch -arch x86_64 /bin/bash -ex

PATH=$PATH:/Applications/CMake.app/Contents/bin

# iota uSwift stdlib/runtime repository
USWIFT_RUNTIME_SUB_PATH=uSwift/Runtime
USWIFT_RUNTIME_URL=git@github.com:swiftforarduino/AVR2.git
USWIFT_RUNTIME_BRANCH=main
USWIFT_RUNTIME_LOCAL_DIR=AVR2

# setup uSwift
rm -rf $USWIFT_RUNTIME_LOCAL_DIR
git clone --depth=1 -b $USWIFT_RUNTIME_BRANCH $USWIFT_RUNTIME_URL $USWIFT_RUNTIME_LOCAL_DIR
rm -f swift/uSwiftRuntime
ln -s $USWIFT_RUNTIME_LOCAL_DIR/$USWIFT_RUNTIME_SUB_PATH swift/uSwiftRuntime

if pushd llvm-project
then
  # undo the patches if present, to ensure update-checkout runs cleanly
  git restore clang
  popd
fi

cd swift

utils/update-checkout --clone-with-ssh --skip-repository swift-nio \
--skip-repository swift-nio-ssh --skip-repository swift-lmdb --skip-repository swift-docc \
--skip-repository swift-docc-render-artifact --skip-repository swift-docc-symbolkit \
--skip-repository swift-markdown --skip-repository swift-experimental-string-processing \
--skip-repository swift-llvm-bindings --skip-repository swift-xcode-playground-support \
--skip-repository swift-corelibs-libdispatch --skip-repository swift-corelibs-foundation \
--skip-repository swift-corelibs-xctest --skip-repository swift-stress-tester \
--skip-repository swift-crypto --skip-repository swift-atomics \
--skip-repository swift-nio-ssl --skip-repository sourcekit-lsp \
--skip-repository indexstore-db --skip-repository swiftpm \
--skip-repository swift-numerics --skip-repository swift

# get the IOTA patches for llvm
pushd ../llvm-project
git apply ../swift/bool-c99-patch.diff
git apply ../swift/avr-swift-abi-patch-2.diff
popd


# uses repositories
#  'cmark'
#  'llbuild'
#  'swift-argument-parser'
#  'swift-collections'
#  'swift-driver'
#  'swift-numerics'
#  'swift-tools-support-core'
#  'swift-syntax'
#  'swift-system'
#  'swift-integration-tests'
#  'ninja'
#  'yams'
#  'swift-format'
#  'swift-installer-scripts'
#  'llvm-project'
#  'llbuild'

# Ideally one day it would be better to replace the very slow utils/update-checkout script with multiple...
# git clone --depth=1 -b release/5.8 https://github.com/<OWNER>/<REPOSITORY> <LOCAL_NAME>
# plus...
# ln -s llvm-project/clang clang
# ln -s llvm-project/llvm llvm
# ...and any other symlinks needed

if [[ "$1" == "debug" ]]
then
  DEBUG_SWIFT_OPT=--debug-swift
else
  DEBUG_SWIFT_OPT=
fi



if [[ "$1" == "fulldebug" ]]
then
  DEBUG_SWIFT_OPT="--debug-swift --debug-llvm"
else
  if [[ "$1" == "debug" ]]
  then
    DEBUG_SWIFT_OPT=--debug-swift
  else
    DEBUG_SWIFT_OPT=
  fi
fi


utils/build-script -R -S --clean ${DEBUG_SWIFT_OPT} --extra-cmake-options="-DLLVM_TARGETS_TO_BUILD=AVR;ARM"  --extra-cmake-options="-DLLVM_ENABLE_PROJECTS='clang'" \
--skip-build-benchmarks --skip-ios --skip-watchos --skip-tvos --darwin-deployment-version-osx 10.15 \
--skip-early-swift-driver=true --skip-early-swiftsyntax=true \
--swift-driver=false --swift-disable-dead-stripping --bootstrapping=hosttools

echo "** COMPLETED SWIFT CHECKOUT SOURCES AND CONFIGURATION **"

if [[ $2 == andbuild ]]
then
  ./build-swift-ci.sh $1
fi
