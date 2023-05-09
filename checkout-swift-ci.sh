#! /usr/bin/arch -arch x86_64 /bin/bash -x

PATH=$PATH:/Applications/CMake.app/Contents/bin

git clone --depth=1 -b main git@github.com:swiftforarduino/AVR2.git AVR2

if [[ "${CI_SERVER}" == "" ]]
then
  git clone --depth=1 -b avr-support-11 git@github.com:swiftforarduino/swift.git swift
fi

ln -s ../AVR2/uSwift/Runtime swift/uSwiftRuntime

cd swift

utils/update-checkout --clone-with-ssh --scheme release/5.8 --skip-repository swift-nio \
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

utils/build-script -R -S --clean ${DEBUG_SWIFT_OPT} --extra-cmake-options="-DLLVM_TARGETS_TO_BUILD=AVR;ARM"  --extra-cmake-options="-DLLVM_ENABLE_PROJECTS='clang'" \
--skip-build-benchmarks --skip-ios --skip-watchos --skip-tvos --darwin-deployment-version-osx 10.15 --swift-disable-dead-stripping --skip-early-swiftsyntax --bootstrapping=off
# --swift-darwin-supported-archs "$(uname -m)"

echo "** COMPLETED SWIFT CHECKOUT SOURCES AND CONFIGURATION **"
