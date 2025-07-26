#! /bin/bash -x

cd swift
utils/build-script -R -i -t --debug-llvm --debug-swift


exit 0

# try this build command for full debug of swift...
utils/build-script --clean -d -S --host-target macosx-x86_64 --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR -DLLVM_ENABLE_BACKTRACES=Off"

dump from history...


  219  utils/build-script -r --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE
  220   utils/build-script 
  221   utils/build-script -help
  222  ls
  223  pwd
  224  ls ..
  225  cat ../carl-full-make-test-ios.sh 
  226  cat ../carl-make.sh 
  227  utils/build-script -r --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE  --cross-compile-hosts avr-atmel-linux-gnueabihf
  228  utils/build-script -r --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE  --cross-compile-hosts avr-atmel-linux-gnueabihf  --stdlib-deployment-targets avr-atmel-linux-gnueabihf 
  229  utils/build-script -r --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE  --cross-compile-hosts avr-atmel-linux-gnueabihf  --stdlib-deployment-targets avr-atmel-linux-gnueabihf 
  230  utils/build-script -r --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --cross-compile-tools-deployment-targets "linux-x86_64" --user-config-args="-DLLVM_ENABLE_BACKTRACES=Off"
  231  utils/build-script -r --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --cross-compile-hosts "linux-x86_64" --user-config-args="-DLLVM_ENABLE_BACKTRACES=Off"
  232  utils/build-script -r --extra-cmake-options="-DLLVM_ENABLE_BACKTRACES=Off -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --cross-compile-hosts "linux-x86_64"
  233  utils/build-script -r --extra-cmake-options="-DLLVM_ENABLE_BACKTRACES=Off -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --cross-compile-hosts "macos-x86_64"
  234  utils/build-script -r --extra-cmake-options="-DLLVM_ENABLE_BACKTRACES=Off -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --cross-compile-hosts linux-armv7
  235  utils/build-script -r --extra-cmake-options="-DLLVM_ENABLE_BACKTRACES=Off -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --cross-compile-hosts "linux-armv7 linux-avr"
  236  utils/build-script -r --extra-cmake-options="-DLLVM_ENABLE_BACKTRACES=Off -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --cross-compile-hosts linux-avr
  237  pwd
  238  utils/build-script -r --extra-cmake-options="-DLLVM_ENABLE_BACKTRACES=Off -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --build-swift-static-stdlib TRUE -- --stdlib-deployment-targets linux-avr


more recent...

  426  utils/build-script -R -S --clean --extra-cmake-options "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"--cross-compile-hosts embedded-avr
  427  utils/build-script -R -S --clean --extra-cmake-options "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR" --cross-compile-hosts embedded-avr
  428  utils/build-script -R -S --clean  --cross-compile-hosts embedded-avr --extra-cmake-options "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  429  utils/build-script -R -S --clean  --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  430  utils/build-script -R -S --clean  --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  431  utils/build-script -R -S --clean  --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  432  utils/build-script -R -S --clean  --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  433  utils/build-script -R -S --clean  --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  434  shopt
  435  shopt
  436  set +x
  437  utils/build-script -R -S --clean  --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  438  utils/build-script -R -S --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  439  utils/build-script -R -S --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  440  utils/build-script -help
  441  utils/build-script -R -S --host-target macosx-x86_64 --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  442  utils/build-script -R -S --host-target macosx-x86_64 --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  443  open -e /Users/carlpeto/avr-swift/build/Ninja-ReleaseAssert/swift-embedded-avr/CMakeFiles/CMakeError.log
  444  find . -name SwiftUtils.cmake
  445  find . -name SwiftUtils.cmake
  446  utils/build-script -R -S --host-target macosx-x86_64 --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  447  utils/build-script -R -S --host-target macosx-x86_64 --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"
  448  pwd
  449  cd ../build
  450  ls
  451  cd Ninja-ReleaseAssert/
  452  ls
  453  cd ..
  454  cd ..
  455  cd swift
  456  utils/build-script --clean -R -S --host-target macosx-x86_64 --cross-compile-hosts embedded-avr --extra-cmake-options="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR"

