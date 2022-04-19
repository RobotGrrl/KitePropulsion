/*
 * promulgate.c
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

#include "promulgate.h"


void promulgate_init(promulgate *pg) {
	if(NULL == pg) return;

	pg->LOG_LEVEL = DEBUGGY;
	reset_buffer(pg);
}


void parse_message(promulgate *pg) {
	if(NULL == pg) return;

	uint8_t len = strlen(pg->msg);

	if(len < 3) return; // we are not looking for short messages...

	// get the action specifier
	char action = pg->msg[0];

	if(action != '0') {

		// get the command
		char cmd = pg->msg[1];

		// find the , to see if there is a value for the key
		uint8_t comma = 0;
		for(uint8_t i=2; i<len-2; i++) {
			if(pg->msg[i] == ',') {
				comma = i;
				break;
			}
		}

		// there is no val
		bool find_val = true;
		if(comma == 0) {
			comma = len-1;
			find_val = false;
		}

		// get the key number
		uint8_t key = 0;
		uint8_t lb = 2; // index of leading digit
		uint8_t ub = comma-1; // index of last digit

		for(uint8_t i=lb; i<=ub; i++) {
			key += ( pg->msg[lb + (i-lb)] - '0') * pow(10, ub-i);
		}

		// find the next ,
		uint8_t comma2 = comma;
		for(uint8_t i=comma+1; i<len-2; i++) {
			if(pg->msg[i] == ',') {
				comma2 = i;
				break;
			}
		}

		// get the val number
		uint16_t val = 0;
		lb = comma+1;
		ub = comma2-1;

		if(find_val) {
			for(uint8_t i=lb; i<=ub; i++) {
				val += ( pg->msg[lb + (i-lb)] - '0' ) * pow(10, ub-i);
			}
		}

		// get the 2nd command
		char cmd2 = pg->msg[comma2+1];

		// find the 3rd ,
		uint8_t comma3 = comma2;
		for(uint8_t i=comma2+1; i<len-2; i++) {
			if(pg->msg[i] == ',') {
				comma3 = i;
				break;
			}
		}

		// get the 2nd key number
		uint8_t key2 = 0;
		lb = comma2+2; // index of leading digit
		ub = comma3-1; // index of last digit

		for(uint8_t i=lb; i<=ub; i++) {
			key2 += ( pg->msg[lb + (i-lb)] - '0') * pow(10, ub-i);
		}

		// get the 2nd val number
		uint16_t val2 = 0;
		lb = comma3+1;
		ub = len-2;

		for(uint8_t i=lb; i<=ub; i++) {
			val2 += ( pg->msg[lb + (i-lb)] - '0' ) * pow(10, ub-i);
		}

		// get the delimeter
		char delim = pg->msg[len-1];

		// print it for debugging

		if(pg->LOG_LEVEL >= DEBUGGY) {
			/*
			*debug_stream << "---RECEIVED---" << endl;
			*debug_stream << "Action specifier: " << action << endl;
			*debug_stream << "Command: " << cmd << endl;
			*debug_stream << "Key: " << key << endl;
			*debug_stream << "Value: " << val << endl;
			*debug_stream << "Command2: " << cmd2 << endl;
			*debug_stream << "Key2: " << key2 << endl;
			*debug_stream << "Value2: " << val2 << endl;
			*debug_stream << "Delim: " << delim << endl;
			*/
		}

		//_rxCallback(action, cmd, key, val, cmd2, key2, val2, delim);

	}

}

void promulgate_organize_message(promulgate *pg, char c) {
	if(NULL == pg) return;

	if(pg->reading_message == false) {

		// check for the action specifier
		if(c == '~' || c == '@' || c == '#' || c == '^' || c == '&' || c == '$') {
			pg->reading_message = true;
			pg->msg[pg->msg_ind] = c;
			pg->msg_ind = pg->msg_ind+1;
		}

	} else {

		pg->msg[pg->msg_ind] = c;
		pg->msg_ind = pg->msg_ind+1;

		// check for the delimeter
		if(c == '!' || c == '?' || c == ';') {
			pg->reading_message = false;
			parse_message(pg);
			reset_buffer(pg);
		}

	}

	if(pg->msg_ind >= MSG_MAX-1) {
		// something bad has happened if we are here...
		pg->msg_ind = 0;
		if(pg->LOG_LEVEL >= WARN) {
			//*debug_stream << "Message > 30 chars, resetting and not parsing" << endl;
		}
		pg->reading_message = false;
		reset_buffer(pg);
	}

}


void reset_buffer(promulgate *pg) {
	if(NULL == pg) return;

	memset(pg->msg, 0, MSG_MAX);
	pg->msg_ind = 0;
}
















