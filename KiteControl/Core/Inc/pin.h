/*
 * pin.h
 *
 *  Created on: May 9, 2022
 *      Author: Erin
 */

#ifndef INC_PIN_H_
#define INC_PIN_H_

typedef struct PinStruct {
	uint16_t pin;
	uint16_t port;
	bool state;
} Pin;

#endif /* INC_PIN_H_ */
