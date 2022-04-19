/*
 * promulgate.h
 *
 *  Created on: Apr. 18, 2022
 *      Author: Erin
 *
 * Promulgate is originally from:
 *      Erin K / RobotGrrl - May 21, 2014
 * --> https://robotmissions.org
 * --> http://RobotGrrl.com/blog
 * --> http://RoboBrrd.com
 *
 * MIT license, check LICENSE for more information
 * All text above must be included in any redistribution
 *
 */

#ifndef INC_PROMULGATE_H_
#define INC_PROMULGATE_H_

#include <string.h>
#include <math.h>
#include <stdio.h>
#include <stdbool.h>

#define MSG_MAX 30 // @L255,1023,L255,1023! = 20

enum Level {
		  ERROR,
		  WARN,
		  INFO,
		  DEBUGGY
		};

typedef struct {
	char msg[MSG_MAX];
	uint8_t msg_ind;
	bool reading_message;
	enum Level LOG_LEVEL;
} promulgate;

// TODO: get the uart here
//extern

void parse_message(promulgate *pg);
void promulgate_organize_message(promulgate *pg, char c);
void reset_buffer(promulgate *pg);


#endif /* INC_PROMULGATE_H_ */
