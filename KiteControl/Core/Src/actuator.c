/*
 * actuator.c
 *
 *  Created on: May 8, 2022
 *      Author: Erin K
 */

#include "actuator.h"

void setStepTime(Actuator *actuator, uint16_t t) {

	actuator->step_time = t;

	// TODO: Also adjust the timer
	// actuator->htim

}

