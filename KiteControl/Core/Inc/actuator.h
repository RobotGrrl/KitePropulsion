/*
 * actuator.h
 *
 *  Created on: May 8, 2022
 *      Author: Erin
 */

#ifndef SRC_ACTUATOR_H_
#define SRC_ACTUATOR_H_

#include <stdint.h>
#include <stdbool.h>
#include "stm32f3xx_hal.h"
#include "pin.h"


typedef enum ActuatorStateStruct {
	DISABLED,    // SLP driven LOW, all outputs LOW. axel should be free spinning (TODO: validate this)
	ENABLED,     // SLP driven HIGH
  BRAKE,       // axel should be held in position and all pins should be high (TODO: validate this)
  PARKED_E1,   // parked at endstop1
  PARKED_E2,   // parked at endstop2
  PARKED_HOME  // parked at home position
} ActuatorState;

typedef struct ActuatorStruct
{
    const char* name[20];
    ActuatorState state;

    Pin *pin1;
    Pin *pin2;
    Pin *pin3;
    Pin *pin4;
    Pin *slp;
    Pin *end1;
    Pin *end2;

    TIM_HandleTypeDef *htim;
    uint8_t step_count;      // count to 4 to switch which pins are enabled
    uint16_t step_time;      // amount of time in ms between steps

    uint16_t position;
    const uint16_t home_pos;
    const uint16_t min_pos;
    const uint16_t max_pos;

    const uint16_t steps_per_revolution; // property of the motor

} Actuator;


void setStepTime(Actuator *actuator, uint16_t t);


#endif /* SRC_ACTUATOR_H_ */




