// code from https://github.com/eleciawhite/reusable/tree/master/source
// license: public domain (https://github.com/eleciawhite/reusable/blob/master/LICENSE)
// april 27, 2022

// Console IO is a wrapper between the actual in and output and the console code
// In an embedded system, this might interface to a UART driver.

#include "consoleIo.h"
#include <stdio.h>

eConsoleError ConsoleIoInit(void)
{
	return CONSOLE_SUCCESS;
}

eConsoleError ConsoleIoReceive(uint8_t *buffer, const uint32_t bufferLength, uint32_t *readLength)
{
	// new

	uint8_t i;
	for(i=0; i<30; i++) {
		if(uart_buf.buf[i] == 0) break;
		buffer[i] = (uint8_t)uart_buf.buf[i];
	}
	*readLength = i;

	return CONSOLE_SUCCESS;
}

eConsoleError ConsoleIoSendString(const char *buffer)
{
	// new
	// sizeof did not work

	uint8_t i;
	for(i=0; i<256; i++) {
		if(buffer[i] == '\0') break;
	}

	uint8_t the_size = i;
	HAL_UART_Transmit(&huart4, buffer, the_size, HAL_MAX_DELAY);

	return CONSOLE_SUCCESS;
}



