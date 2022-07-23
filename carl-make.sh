#! /bin/bash -x

#utils/build-script -R -t --debug-llvm --debug-swift
#utils/build-script -R -t --debug-llvm --debug-swift --extra-cmake-options "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
#utils/build-script -R --clean --reconfigure --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
#utils/build-script -R --clean --reconfigure --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --cross-compile-hosts avr-atmel-linux-gnueabihf
#utils/build-script -R --clean --reconfigure --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE
#utils/build-script -S -R --clean --reconfigure --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE

#utils/build-script -S -R --clean --debug-llvm --debug-swift --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE
#utils/build-script -T -o -t -R --debug-llvm --debug-swift --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE

#utils/build-script --clean --reconfigure -t -R --debug-llvm --debug-swift --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE


# this fails on master as at ce6493b356e21dc5deed4c62748c07ee97fae56f with a linking error
#utils/build-script -R --debug-llvm --debug-swift --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE

# this works on master as at ce6493b356e21dc5deed4c62748c07ee97fae56f
#utils/build-script --clean --reconfigure -R --build-swift-static-stdlib TRUE

#utils/build-script -t -R --build-swift-static-stdlib TRUE
utils/build-script -R --build-swift-static-stdlib TRUE


time cd build/Ninja-ReleaseAssert+swift-DebugAssert && (cd cmark-macosx-x86_64 && ninja) && (cd llvm-macosx-x86_64 && ninja) && (cd swift-macosx-x86_64 && ninja swift) && (cd llvm-embedded-avr && ninja) && (cd swift-embedded-avr && ninja swift)


# you will need python 2 available as this is an older distribution, you can get it here: https://www.python.org/downloads/release/python-2718/
# tediously, you may need to install six...
# pip install six

# also you'll need CMake


# Alternative approaches
# For the simplest possible configuration, release build from source code, using Ninja to build, use...
# utils/build-script -S -R --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
# add --clean to cleanup older builds
# add --xcode to make xcode project instead of Ninja build files (note this will be MUCH slower but might help control builds)
# The xcode build should be able to build everything in one step though.

# with the current toolchain, you'll need Xcode 12.5.1 (at the time of writing) ... check the README.md too
# use Xcodes GUI or command line to install it if you need to and use something like...
# export DEVELOPER_DIR=/Applications/Xcode-12.5.1.app/Contents/Developer
# to point the tools at the correct directory before running the above (or use xcode-select if you prefer but that's a system wide default)
