
#include "Board.h"
#include "Signal.h"

struct Signal *(all_signals[NUM_SIGNALS]);
struct Signal *selected = NULL;

void setup() {
  Serial.begin(9600);

  pinInit();

  digitalWrite(LED_PIN, HIGH);

  setSignals();
  initSignals();

}

void loop() {
  
  for(uint8_t i=0; i<NUM_SIGNALS; i++) {
    selected = all_signals[i];
    selected->prev_val = selected->val;
    selected->val = analogRead(selected->pin);
    selected->last_read = millis();
  }
  
}


void pinInit() {

  for(uint8_t i=0; i<NUM_SIGNALS; i++) {
    selected = all_signals[i];
    pinMode(selected->pin, INPUT);
  }
  
  pinMode(LED_S03C_PIN, OUTPUT);
  pinMode(LED_S01_PIN, OUTPUT);
  pinMode(LED_S03_PIN, OUTPUT);
  pinMode(LED_S04_PIN, OUTPUT);
  pinMode(LED_S05_PIN, OUTPUT);
  pinMode(LED_S06_PIN, OUTPUT);
  pinMode(LED_S03D_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(FREE1_PIN, INPUT);
  pinMode(BUTTON1_PIN, INPUT);
  pinMode(BUTTON2_PIN, INPUT);
  pinMode(BUTTON3_PIN, INPUT);
  pinMode(FREE2_PIN, INPUT);
  pinMode(FREE3_PIN, INPUT);
  pinMode(LED_S03A_PIN, OUTPUT);
  pinMode(LED_S03B_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
  
}
