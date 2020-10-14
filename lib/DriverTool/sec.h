//
//  sec.h
//  Swift For Arduino
//
//  Created by Carl Peto on 11/10/2020.
//  Copyright © 2020 Carl Peto. All rights reserved.
//

#ifndef sec_h
#define sec_h

#ifdef __cplusplus
extern "C" {
#else
#include <stdbool.h>
#endif

#define SHM_SIZE 100

// Usage:
// Build engine - setup shared memory token at build start, zero it and remove it at build end
// IDE - on menu item "Install command line tools", create tools, on "Remove command line tools", delete them
// Build tool (swift) - check for shared memory token, then if missing check for environment variable

// the command line tools installed will be uswift, which is a simple shell script to wrap uSwift
// and ullc which is a simple shell script to wrap avr llc
// each shell script will first export an environment variable like U_TKN, this will be fed in after
// being created by the IDE, like...
// #! /bin/sh
// export U_TKN=lafk31$fs
// /Applications/Swift for Arduino.app/Contents/XPCServices/S4A Build Engine/Contents/Resources/swift-5.3/swift $*

// shared memory create token function
void _sct_(bool transient);
// shared memory destroy token function
void _sdm_(void);
// shared memory check token function
bool _sch_(bool transient);

// get long life token
void _ksdm_(char * buffer);

// check long life token
bool _ksch_(char * tokenName);

#ifdef __cplusplus
}
#endif

#endif /* sec_h */
