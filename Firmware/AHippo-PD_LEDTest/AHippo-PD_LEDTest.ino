/*
 * Hippo-PD LED Test
 * ----------------------
 * Test the leds
 * Aug. 4, 2022
 */

#include <Streaming.h>
#include "Board.h"
#include "Led.h"

struct TheLED *(all_leds[NUM_LEDS]);
struct TheLED *selected = NULL;

void setup() {
  Serial.begin(9600);

  setLeds();
  initLeds();
  pinMode(BUZZER_PIN, OUTPUT);
  
}

void loop() {

  updateLeds();

  if(Serial.available() > 0) {
    char c = Serial.read();
    switch(c) {
      case '1': // turn all on
        for(uint8_t i=0; i<NUM_LEDS; i++) {
          selected = all_leds[i];
          selected->on = true;
          selected->mode = 1;
          selected->last_on = millis();
        }
      break;
      case '0': // turn all off
        for(uint8_t i=0; i<NUM_LEDS; i++) {
          selected = all_leds[i];
          selected->on = false;
          selected->mode = 0;
        }
      break;
      case 'b': // turn all blink
        for(uint8_t i=0; i<NUM_LEDS; i++) {
          selected = all_leds[i];
          selected->on = true;
          selected->mode = 2;
          selected->last_on = millis();
        }
      break;
    }
  }
  
}
