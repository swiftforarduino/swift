//
//  sec.c
//  Swift For Arduino
//
//  Created by Carl Peto on 11/10/2020.
//  Copyright © 2020 Carl Peto. All rights reserved.
//

#include "sec.h"
#include <sys/mman.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <stdio.h>
#include <fcntl.h>
#include "unistd.h"

#define SHM_KEY 469500468
#define SHM_ACCESS 0600

// functions for implementing security

// shared memory
// the IDEs will create a shared memory segment with a specific
// combination/key in that can be verified

// when the build engine starts, it checks this
// when swift starts it checks this

// ...slight change, we should setup the token at the start of a build and clear it down at the end
// that prevents someone from running the free version in the background to gain access to
// command line swift

// keychain
// for the professional IDE, create a keychain entry

// when swift starts, if it cannot find the shared memory verification
// it will fallback on looking for the keychain item

/* PRIVATE IMPLEMENTATION */


// Particles (the names have been changed to obscure the innocent)

// hostname (for use in keychain token) - max 100 chars
#define MAX_HOSTNAME 100

size_t _hn_(char * buffer, size_t bufferLength) {
    size_t hostnameLength = bufferLength;
    if (sysctlbyname("kern.hostname",&buffer[0],&hostnameLength,0,0)<0) {
        // perror("failed to get kern.hostname");
        return 0;
    } else {
        return hostnameLength;
    }
}

size_t _hdy_(char * buffer, size_t bufferLength) {
    time_t t0;
    return snprintf(buffer, bufferLength, "%ld", time(&t0) / 86400);
}

#define SK_1 "ecnerol3F"
#define SK_2 "drahci0R"
#define SK_SALT "eill2E"

#ifdef DEBUG
#define write_error(msg) perror(msg)
#else
#define write_error(msg)
#endif

// create a token and copy it into the buffer passed
// shm flag indicates its a shared memory token, meaning
// it's much more transient
void _tcr_(bool transient, char * buffer, size_t buflen) {
    if (transient) {
        // e.g. shared memory => s4aIloveFlorence + day -> hashed
        size_t tsize = _hdy_( buffer, buflen);
        size_t remaining = buflen - tsize;
        size_t sks = strlen(SK_2);
        strncpy(buffer+tsize, SK_1, sks < remaining ? sks : remaining);
    } else {
        // e.g. keychain => s4aIloveFlorence + machine identifier -> hashed
        size_t tsize = _hn_( buffer, buflen);
        size_t remaining = buflen - tsize;
        size_t sks = strlen(SK_1);
        strncpy(buffer+tsize, SK_1, sks < remaining ? sks : remaining);
    }

    // replace the buffer we made with the hash of it
    char * hash = crypt(buffer, SK_SALT);
    bzero(buffer, buflen);

    if (transient) {
        // shared memory uses a simple string representation
        strncpy(buffer, hash, buflen);
    } else {
        // long life token must use a hex encoded version
        // because it will be sent via a shell script
        size_t hashlen = strnlen(hash, buflen/2);
        char prebuf[3];
        size_t i = 0;
        for (;i<hashlen;i++) {
            snprintf(&prebuf[0],3,"%02X",hash[i]);
            buffer[i*2] = prebuf[0];
            buffer[i*2+1] = prebuf[1];
        }
    }
}

// pointer to the shared memory, and id for the shared memory
static char * _srm_ = 0;
static int _srimd_ = 0;

#define SHM_FILENAME "SWDC5K54B7.s4a/_srm_"

// get the shared memory pointer
// this uses the SHM APIs to either create or link to a shared
// memory segment, memory map it, return the pointer via an out parameter
// and save the id in a static variable
void _sgms_(char ** sharedMemory, bool create) {
    int sharedMemFd;

    int flags = O_RDWR;
    if (create) {
        flags |= O_CREAT;
    }

    if ((sharedMemFd = shm_open(SHM_FILENAME, flags, SHM_ACCESS)) < 0) {
        write_error("Error in creating shared memory segment");
        *sharedMemory = 0;
        return;
    }

    _srimd_ = sharedMemFd;

    if (create) {
        if (ftruncate(sharedMemFd, SHM_SIZE) < 0) {
            write_error("error ftruncate");
        }
    }

    void *sharedMemSpace;
    if ((sharedMemSpace = mmap(NULL, SHM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, sharedMemFd, 0)) == (char *)(-1)) {
        write_error("Error in attaching segment to data space");
        *sharedMemory = 0;
        return;
    }
    *sharedMemory = sharedMemSpace;
}

// shared memory connect
// this connects to or creates the shared memory segment
// (if not already in the static variable)
// and stores the pointer to it in a static variable
void _smrc_(bool create) {
    if (!_srm_) {
        char *sharedMemSpace;
        _sgms_(&sharedMemSpace, create);
        if (sharedMemSpace) {
            _srm_ = sharedMemSpace;
        }
    }
}

// shared memory disconnect
// if the static pointer to shared memory is set,
// disconnect from the segment and NULL the pointer
void _smdc_() {
    if (_srm_) {
        munmap(_srm_, SHM_SIZE);
        close(_srimd_);
        _srm_ = 0;
    }
}

// shared memory wipe token function
// clear the buffer pointed to by the static pointer variable
// this clears the token from shared memory, disabling authentication
void _shldt_() {
    if (_srm_) {
        bzero(_srm_, SHM_SIZE);
    }
}

/* PUBLIC INTERFACE */

// shared memory create token function
// this creates a shared memory segment or connects to it,
// setting static variables accordingly,
// and populates the buffer with a valid security token
void _sct_(bool transient) {
    _smrc_(true);
    if (_srm_) {
        bzero(_srm_, SHM_SIZE);
        _tcr_(transient, _srm_, SHM_SIZE);
    }
}

// shared memory destroy token function
// wipe the shared memory buffer,
// disconnect from the shared memory segment
// then delete the segment.
// finally, clear all static variables for a full reset
void _sdm_() {
    _shldt_();
    _smdc_();

    if (_srimd_) {
        shm_unlink(SHM_FILENAME);
        _srimd_ = 0;
    }
}

// shared memory check token function
// connect to the shared memory segment,
// check the contents of the buffer against what
// we have calculated should be its value,
// disconnect from the shared memory segment
// and return the result
bool _sch_(bool transient) {
    _smrc_(false);
    if (_srm_) {
        char expected[SHM_SIZE];
        _tcr_(transient, expected, SHM_SIZE);
        bool result = strncmp(expected, _srm_, SHM_SIZE) == 0;
        _smdc_();
        return result;
    } else {
        return false;
    }
}

// keychain is probably overkill and adds comoplexity for command line access from the swift tool
// instead, we can just drop a text file in /etc/s4a/clalicense.txt and the swift tool can read it
// installed at the same time we put symlinks into /usr/local for the tools uswift and ullc

// get long life token
void _ksdm_(char * buffer) {
    _tcr_(false, buffer, SHM_SIZE);
}

// check long life token
bool _ksch_(char * tokenName) {
    char * token = getenv(tokenName);
    if (!token) return false;
    char expected[SHM_SIZE];
    _tcr_(false, expected, SHM_SIZE);
    return strncmp(expected, token, SHM_SIZE) == 0;
}
