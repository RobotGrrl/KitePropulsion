// code from https://github.com/eleciawhite/reusable/tree/master/source
// license: public domain (https://github.com/eleciawhite/reusable/blob/master/LICENSE)
// april 27, 2022

// Console IO is a wrapper between the actual in and output and the console code

#ifndef CONSOLE_IO_H
#define CONSOLE_IO_H

#include <stdint.h>
#include "stm32f3xx_hal.h" // new
#include "input_buf.h" // new

extern UART_HandleTypeDef huart4; // new
extern input_buf uart_buf; // new

typedef enum {CONSOLE_SUCCESS = 0u, CONSOLE_ERROR = 1u } eConsoleError;

eConsoleError ConsoleIoInit(void);

eConsoleError ConsoleIoReceive(uint8_t *buffer, const uint32_t bufferLength, uint32_t *readLength);
eConsoleError ConsoleIoSendString(const char *buffer); // must be null terminated

#endif // CONSOLE_IO_H
