#! /usr/bin/arch -arch x86_64 /bin/bash -x

PATH=$PATH:/Applications/CMake.app/Contents/bin

git clone --depth=1 -b release/5.8 https://github.com/apple/swift-cmark.git cmark
git clone --depth=1 -b avr-swift-additions-1 git@github.com:swiftforarduino/llvm-project.git llvm-project
git clone --depth=1 -b main git@github.com:swiftforarduino/AVR2.git AVR2

if [[ "${CI_SERVER}" == "" ]]
then
  git clone --depth=1 -b avr-support-11 git@github.com:swiftforarduino/swift.git swift
fi

ln -s ../AVR2/uSwift/Runtime swift/uSwiftRuntime

ln -s llvm-project/clang clang
ln -s llvm-project/llvm llvm

cd swift

if [[ "$1" == "debug" ]]
then
  DEBUG_SWIFT_OPT=--debug-swift
else
  DEBUG_SWIFT_OPT=
fi

# utils/build-script -R -S --clean ${DEBUG_SWIFT_OPT} --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"  --extra-cmake-options="-DLLVM_ENABLE_PROJECTS='clang'"

utils/build-script -R -S --clean ${DEBUG_SWIFT_OPT} --extra-cmake-options="-DLLVM_TARGETS_TO_BUILD=AVR"  --extra-cmake-options="-DLLVM_ENABLE_PROJECTS='clang'" \
--skip-build-benchmarks --skip-ios --skip-watchos --skip-tvos --swift-darwin-supported-archs "$(uname -m)" --swift-disable-dead-stripping --skip-early-swiftsyntax --bootstrapping=off

echo "** COMPLETED SWIFT CHECKOUT SOURCES AND CONFIGURATION **"
