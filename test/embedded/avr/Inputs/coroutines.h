// equivalent of AVR libc #include <stdint.h>...

typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef uint16_t uintptr_t;

typedef signed char int8_t;
typedef signed int int16_t;
typedef int16_t intptr_t;

static inline uint8_t _volatileRegisterReadUInt8(uintptr_t address) {
  volatile uint8_t *ptr = (volatile uint8_t *)address;
  return *ptr;
}

static inline void _volatileRegisterWriteUInt8(uintptr_t address, uint8_t value) {
  volatile uint8_t *ptr = (volatile uint8_t *)address;
  *ptr = value;
}
