
#include "Board.h"
#include "Signal.h"

struct Signal *(all_signals[NUM_SIGNALS]);
struct Signal *selected = NULL;

void setup() {
  Serial.begin(9600);

  pinInit();

  digitalWrite(LED_PIN, HIGH);

  initSignals();
  setSignals();

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


void setSignals() {

  all_signals[0] = &T5V_SIG;
  all_signals[1] = &IN_SIG;
  all_signals[2] = &S03_SIG4;
  all_signals[3] = &S03_SIG3;
  all_signals[4] = &S03_SIG2;
  all_signals[5] = &S03_SIGSMPS;
  all_signals[6] = &S03_SIG1;
  all_signals[7] = &S06_SIG1;
  all_signals[8] = &S06_SIGSMPS;
  all_signals[9] = &S04_SIG1;
  all_signals[10] = &S04_SIG2;
  all_signals[11] = &S04_SIG3;
  all_signals[12] = &S04_SIGSMPS;
  all_signals[13] = &S05_SIGNP;
  all_signals[14] = &S05_SIG2;
  all_signals[15] = &S05_SIG1;
  all_signals[16] = &S05_SIGSMPS;

  for(uint8_t i=0; i<NUM_SIGNALS; i++) {
    selected = all_signals[i];
    selected->val = 0;
    selected->prev_val = 0;
    selected->last_read = 0;
  }
  
}
