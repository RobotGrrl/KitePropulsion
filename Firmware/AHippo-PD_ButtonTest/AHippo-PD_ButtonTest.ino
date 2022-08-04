/*
 * Hippo-PD Button Test
 * ----------------------
 * Test the buttons and debouncing
 * Aug. 3, 2022
 */

#include <Bounce2.h>
#include <Streaming.h>
#include "Board.h"

#define DEBOUNCE_INTERVAL   5

Bounce bounce1 = Bounce();
Bounce bounce2 = Bounce();
Bounce bounce3 = Bounce();

bool pressed1 = false;
bool pressed2 = false;
bool pressed3 = false;

void setup() {
  Serial.begin(9600);

  bounce1.attach(BUTTON1_PIN, INPUT);
  bounce2.attach(BUTTON2_PIN, INPUT);
  bounce3.attach(BUTTON3_PIN, INPUT);

  bounce1.interval(DEBOUNCE_INTERVAL);
  bounce2.interval(DEBOUNCE_INTERVAL);
  bounce3.interval(DEBOUNCE_INTERVAL);

//  pinMode(BUTTON1_PIN, INPUT);
//  pinMode(BUTTON2_PIN, INPUT);
//  pinMode(BUTTON3_PIN, INPUT);
  pinMode(LED_PIN, OUTPUT);

}

void loop() {

  bounce1.update();
  bounce2.update();
  bounce3.update();

  if(bounce1.changed()) {
    if(bounce1.read() == HIGH) {
      pressed1 = true;
      if(pressed1) Serial << "button 1 pressed" << endl;
      digitalWrite(LED_PIN, HIGH);
    } else {
      pressed1 = false;
    }
  }

  if(bounce2.changed()) {
    if(bounce2.read() == HIGH) {
      pressed2 = true;
      if(pressed2) Serial << "button 2 pressed" << endl;
      digitalWrite(LED_PIN, HIGH);
    } else {
      pressed2 = false;
    }
  }

  if(bounce3.changed()) {
    if(bounce3.read() == HIGH) {
      pressed3 = true;
      if(pressed3) Serial << "button 3 pressed" << endl;
      digitalWrite(LED_PIN, HIGH);
    } else {
      pressed3 = false;
    }
  }
  
}
